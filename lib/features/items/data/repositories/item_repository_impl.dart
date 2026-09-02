import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/utils/api_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/features/items/domain/repositories/item_repository.dart';
import 'package:home_sync/features/items/data/mappers/item_mapper.dart';
import 'package:home_sync/features/items/data/models/item_document_model.dart';
import 'package:home_sync/features/items/data/models/item_model.dart';

/// Remote Data Source cho Items giao tiếp Supabase PostgreSQL (Hỗ trợ Idempotent Upsert)
class ItemsRemoteDataSource {
  ItemsRemoteDataSource({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<ItemModel>> getItems({String? categoryId, String? location, String? query}) async {
    var request = _client.from('items').select('*, categories(name, icon_name)');

    if (categoryId != null && categoryId.isNotEmpty) {
      request = request.eq('category_id', categoryId);
    }
    if (location != null && location.isNotEmpty) {
      request = request.eq('location', location);
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim();
      request = request.or('name.ilike.%$q%,brand.ilike.%$q%,serial_number.ilike.%$q%,location.ilike.%$q%,store_name.ilike.%$q%');
    }

    final response = await request.order('created_at', ascending: false);
    final list = response as List<dynamic>;
    return list.map((itemJson) {
      final map = Map<String, dynamic>.from(itemJson as Map<String, dynamic>);
      if (map['categories'] != null && map['categories'] is Map) {
        final cat = map['categories'] as Map<String, dynamic>;
        map['category_name'] = cat['name'];
        map['category_icon'] = cat['icon_name'];
      }
      return ItemModel.fromJson(map);
    }).toList();
  }

  Future<ItemModel> getItemById(String id) async {
    final response = await _client
        .from('items')
        .select('*, categories(name, icon_name)')
        .eq('id', id)
        .single();
    final map = Map<String, dynamic>.from(response);
    if (map['categories'] != null && map['categories'] is Map) {
      final cat = map['categories'] as Map<String, dynamic>;
      map['category_name'] = cat['name'];
      map['category_icon'] = cat['icon_name'];
    }
    return ItemModel.fromJson(map);
  }

  /// Thêm thiết bị mới với cơ chế Idempotent Upsert (Chống trùng lặp khi retry)
  Future<ItemModel> addItem(ItemModel item) async {
    final data = item.toJson();
    // Giữ nguyên id nếu client đã sinh sẵn (Idempotency Key)
    if (item.id.isEmpty) {
      data.remove('id');
    }
    data.remove('category_name');
    data.remove('category_icon');

    final response = await _client
        .from('items')
        .upsert(data)
        .select('*, categories(name, icon_name)')
        .single();

    return ItemModel.fromJson(response);
  }

  Future<ItemModel> updateItem(ItemModel item) async {
    final data = item.toJson();
    data.remove('category_name');
    data.remove('category_icon');
    final response = await _client
        .from('items')
        .update(data)
        .eq('id', item.id)
        .select('*, categories(name, icon_name)')
        .single();
    return ItemModel.fromJson(response);
  }

  Future<void> deleteItem(String id) async {
    await _client.from('items').delete().eq('id', id);
  }

  Future<void> toggleFavorite(String id, bool isFavorite) async {
    await _client.from('items').update({'is_favorite': isFavorite}).eq('id', id);
  }

  Future<List<ItemDocumentModel>> getItemDocuments(String itemId) async {
    final response = await _client.from('item_documents').select().eq('item_id', itemId).order('created_at');
    final list = response as List<dynamic>;
    return list.map((json) => ItemDocumentModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> addItemDocument(ItemDocumentModel document) async {
    final data = document.toJson();
    if (document.id.isEmpty) {
      data.remove('id');
    }
    await _client.from('item_documents').upsert(data);
  }

  Future<void> deleteItemDocument(String documentId) async {
    await _client.from('item_documents').delete().eq('id', documentId);
  }
}

/// Repository Implementation cho Items sử dụng Global safeApiCall phòng thủ mạng
class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl({ItemsRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ItemsRemoteDataSource();

  final ItemsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<ItemEntity>>> getItems({String? categoryId, String? location, String? query}) {
    return safeApiCall(() async {
      final models = await _remoteDataSource.getItems(
        categoryId: categoryId,
        location: location,
        query: query,
      );
      return models.map(ItemMapper.toEntity).toList();
    });
  }

  @override
  Future<Either<Failure, ItemEntity>> getItemById(String id) {
    return safeApiCall(() async {
      final model = await _remoteDataSource.getItemById(id);
      return ItemMapper.toEntity(model);
    });
  }

  @override
  Future<Either<Failure, ItemEntity>> addItem(ItemEntity item) {
    return safeApiCall(() async {
      final model = ItemMapper.toModel(item);
      final savedModel = await _remoteDataSource.addItem(model);
      return ItemMapper.toEntity(savedModel);
    });
  }

  @override
  Future<Either<Failure, ItemEntity>> updateItem(ItemEntity item) {
    return safeApiCall(() async {
      final model = ItemMapper.toModel(item);
      final updatedModel = await _remoteDataSource.updateItem(model);
      return ItemMapper.toEntity(updatedModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) {
    return safeApiCall(() async {
      await _remoteDataSource.deleteItem(id);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(String id, bool isFavorite) {
    return safeApiCall(() async {
      await _remoteDataSource.toggleFavorite(id, isFavorite);
      return unit;
    });
  }

  @override
  Future<Either<Failure, List<ItemDocumentEntity>>> getItemDocuments(String itemId) {
    return safeApiCall(() async {
      final models = await _remoteDataSource.getItemDocuments(itemId);
      return models.map(ItemMapper.documentToEntity).toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> addItemDocument(ItemDocumentEntity document) {
    return safeApiCall(() async {
      final model = ItemMapper.documentToModel(document);
      await _remoteDataSource.addItemDocument(model);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteItemDocument(String documentId) {
    return safeApiCall(() async {
      await _remoteDataSource.deleteItemDocument(documentId);
      return unit;
    });
  }
}
