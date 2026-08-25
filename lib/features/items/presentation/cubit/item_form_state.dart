import 'package:home_sync/features/items/domain/entities/item_entity.dart';

/// Dart 3 Sealed Class cho ItemForm State
sealed class ItemFormState {
  const ItemFormState();
}

final class ItemFormInitial extends ItemFormState {
  const ItemFormInitial();
}

final class ItemFormSubmitting extends ItemFormState {
  const ItemFormSubmitting();
}

final class ItemFormSuccess extends ItemFormState {
  const ItemFormSuccess(this.item);
  final ItemEntity item;
}

final class ItemFormDeleteSuccess extends ItemFormState {
  const ItemFormDeleteSuccess();
}

final class ItemFormFailure extends ItemFormState {
  const ItemFormFailure(this.message);
  final String message;
}
