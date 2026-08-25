import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:home_sync/features/items/domain/repositories/item_repository.dart';

/// Params cho GetItemsUseCase
class GetItemsParams {
  const GetItemsParams({this.categoryId, this.location, this.query});
  final String? categoryId;
  final String? location;
  final String? query;
}

/// Use Case: Lấy danh sách thiết bị có bộ lọc (danh mục, phòng, từ khóa tìm kiếm)
class GetItemsUseCase implements UseCase<List<ItemEntity>, GetItemsParams> {
  const GetItemsUseCase(this._repository);
  final ItemRepository _repository;

  @override
  Future<Either<Failure, List<ItemEntity>>> call([GetItemsParams params = const GetItemsParams()]) {
    return _repository.getItems(
      categoryId: params.categoryId,
      location: params.location,
      query: params.query,
    );
  }
}

/// Use Case: Lấy chi tiết 1 thiết bị theo ID
class GetItemByIdUseCase implements UseCase<ItemEntity, String> {
  const GetItemByIdUseCase(this._repository);
  final ItemRepository _repository;

  @override
  Future<Either<Failure, ItemEntity>> call(String id) {
    return _repository.getItemById(id);
  }
}

/// Use Case: Thêm mới thiết bị
class AddItemUseCase implements UseCase<ItemEntity, ItemEntity> {
  const AddItemUseCase(this._repository);
  final ItemRepository _repository;

  @override
  Future<Either<Failure, ItemEntity>> call(ItemEntity item) {
    return _repository.addItem(item);
  }
}

/// Use Case: Cập nhật thông tin thiết bị
class UpdateItemUseCase implements UseCase<ItemEntity, ItemEntity> {
  const UpdateItemUseCase(this._repository);
  final ItemRepository _repository;

  @override
  Future<Either<Failure, ItemEntity>> call(ItemEntity item) {
    return _repository.updateItem(item);
  }
}

/// Use Case: Xóa thiết bị
class DeleteItemUseCase implements UseCase<Unit, String> {
  const DeleteItemUseCase(this._repository);
  final ItemRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return _repository.deleteItem(id);
  }
}

/// Params cho ToggleFavoriteUseCase
class ToggleFavoriteParams {
  const ToggleFavoriteParams({required this.id, required this.isFavorite});
  final String id;
  final bool isFavorite;
}

/// Use Case: Đánh dấu / Hủy đánh dấu thiết bị yêu thích
class ToggleFavoriteUseCase implements UseCase<Unit, ToggleFavoriteParams> {
  const ToggleFavoriteUseCase(this._repository);
  final ItemRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ToggleFavoriteParams params) {
    return _repository.toggleFavorite(params.id, params.isFavorite);
  }
}

/// Use Case: Lấy danh sách tài liệu / hóa đơn đính kèm của thiết bị
class GetItemDocumentsUseCase implements UseCase<List<ItemDocumentEntity>, String> {
  const GetItemDocumentsUseCase(this._repository);
  final ItemRepository _repository;

  @override
  Future<Either<Failure, List<ItemDocumentEntity>>> call(String itemId) {
    return _repository.getItemDocuments(itemId);
  }
}

/// Use Case: Thêm tài liệu / hóa đơn đính kèm
class AddItemDocumentUseCase implements UseCase<Unit, ItemDocumentEntity> {
  const AddItemDocumentUseCase(this._repository);
  final ItemRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ItemDocumentEntity document) {
    return _repository.addItemDocument(document);
  }
}

/// Use Case: Xóa tài liệu / hóa đơn đính kèm
class DeleteItemDocumentUseCase implements UseCase<Unit, String> {
  const DeleteItemDocumentUseCase(this._repository);
  final ItemRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String documentId) {
    return _repository.deleteItemDocument(documentId);
  }
}
