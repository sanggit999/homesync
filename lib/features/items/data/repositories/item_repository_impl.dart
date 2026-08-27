import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/features/items/domain/repositories/item_repository.dart';
import 'package:home_sync/features/items/data/mappers/item_mapper.dart';
import 'package:home_sync/features/items/data/models/item_document_model.dart';
import 'package:home_sync/features/items/data/models/item_model.dart';

/// Remote Data Source cho Items giao tiếp Supabase PostgreSQL
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
    return list.map((json) => ItemModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<ItemModel> getItemById(String id) async {
    final response = await _client
        .from('items')
        .select('*, categories(name, icon_name)')
        .eq('id', id)
        .single();
    return ItemModel.fromJson(response);
  }

  Future<ItemModel> addItem(ItemModel item) async {
    final data = item.toJson();
    data.remove('id'); // Tự sinh trên Supabase
    final response = await _client.from('items').insert(data).select('*, categories(name, icon_name)').single();
    return ItemModel.fromJson(response);
  }

  Future<ItemModel> updateItem(ItemModel item) async {
    final data = item.toJson();
    final response = await _client.from('items').update(data).eq('id', item.id).select('*, categories(name, icon_name)').single();
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
    data.remove('id');
    await _client.from('item_documents').insert(data);
  }

  Future<void> deleteItemDocument(String documentId) async {
    await _client.from('item_documents').delete().eq('id', documentId);
  }
}

/// Repository Implementation cho Items sử dụng fpdart Either
class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl({ItemsRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ItemsRemoteDataSource();

  final ItemsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<ItemEntity>>> getItems({String? categoryId, String? location, String? query}) async {
    try {
      final models = await _remoteDataSource.getItems(
        categoryId: categoryId,
        location: location,
        query: query,
      );
      return Right(models.map(ItemMapper.toEntity).toList());
    } on PostgrestException catch (e) {
      debugPrint('[HOMESYNC DB ERROR - ITEMS] Code: [${e.code}] Message: ${e.message} | Details: ${e.details} | Hint: ${e.hint}');
      return Left(ServerFailure('[${e.code}] ${e.message}'));
    } catch (e) {
      debugPrint('[HOMESYNC DB ERROR - ITEMS] Lỗi không xác định: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> getItemById(String id) async {
    try {
      final model = await _remoteDataSource.getItemById(id);
      return Right(ItemMapper.toEntity(model));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> addItem(ItemEntity item) async {
    try {
      final model = ItemMapper.toModel(item);
      final savedModel = await _remoteDataSource.addItem(model);
      return Right(ItemMapper.toEntity(savedModel));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> updateItem(ItemEntity item) async {
    try {
      final model = ItemMapper.toModel(item);
      final updatedModel = await _remoteDataSource.updateItem(model);
      return Right(ItemMapper.toEntity(updatedModel));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    try {
      await _remoteDataSource.deleteItem(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(String id, bool isFavorite) async {
    try {
      await _remoteDataSource.toggleFavorite(id, isFavorite);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemDocumentEntity>>> getItemDocuments(String itemId) async {
    try {
      final models = await _remoteDataSource.getItemDocuments(itemId);
      return Right(models.map(ItemMapper.documentToEntity).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addItemDocument(ItemDocumentEntity document) async {
    try {
      final model = ItemMapper.documentToModel(document);
      await _remoteDataSource.addItemDocument(model);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItemDocument(String documentId) async {
    try {
      await _remoteDataSource.deleteItemDocument(documentId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
