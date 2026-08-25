import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/usecases/item_usecases.dart';
import 'item_form_state.dart';

export 'item_form_state.dart';

/// Cubit quản lý biểu mẫu thêm/sửa/xóa thiết bị
class ItemFormCubit extends Cubit<ItemFormState> {
  ItemFormCubit({
    required this.addItemUseCase,
    required this.updateItemUseCase,
    required this.deleteItemUseCase,
  }) : super(const ItemFormInitial());

  final AddItemUseCase addItemUseCase;
  final UpdateItemUseCase updateItemUseCase;
  final DeleteItemUseCase deleteItemUseCase;

  /// Tạo thiết bị mới
  Future<void> submitCreateItem(ItemEntity item) async {
    emit(const ItemFormSubmitting());
    final result = await addItemUseCase(item);
    result.fold(
      (failure) => emit(ItemFormFailure(failure.message)),
      (savedItem) => emit(ItemFormSuccess(savedItem)),
    );
  }

  /// Cập nhật thiết bị hiện có
  Future<void> submitUpdateItem(ItemEntity item) async {
    emit(const ItemFormSubmitting());
    final result = await updateItemUseCase(item);
    result.fold(
      (failure) => emit(ItemFormFailure(failure.message)),
      (updatedItem) => emit(ItemFormSuccess(updatedItem)),
    );
  }

  /// Xóa thiết bị
  Future<void> deleteItem(String id) async {
    emit(const ItemFormSubmitting());
    final result = await deleteItemUseCase(id);
    result.fold(
      (failure) => emit(ItemFormFailure(failure.message)),
      (_) => emit(const ItemFormDeleteSuccess()),
    );
  }
}
