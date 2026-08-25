import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/features/items/domain/entities/item_document_entity.dart';
import 'package:home_sync/features/items/domain/entities/item_entity.dart';
export '../entities/item_document_entity.dart';
export '../entities/item_entity.dart';

/// Abstract Repository Contract cho Items & Tài liệu bảo hành sử dụng Either (fpdart)
abstract class ItemRepository {
  Future<Either<Failure, List<ItemEntity>>> getItems({
    String? categoryId,
    String? location,
    String? query,
  });

  Future<Either<Failure, ItemEntity>> getItemById(String id);

  Future<Either<Failure, ItemEntity>> addItem(ItemEntity item);

  Future<Either<Failure, ItemEntity>> updateItem(ItemEntity item);

  Future<Either<Failure, Unit>> deleteItem(String id);

  Future<Either<Failure, Unit>> toggleFavorite(String id, bool isFavorite);

  Future<Either<Failure, List<ItemDocumentEntity>>> getItemDocuments(String itemId);

  Future<Either<Failure, Unit>> addItemDocument(ItemDocumentEntity document);

  Future<Either<Failure, Unit>> deleteItemDocument(String documentId);
}
