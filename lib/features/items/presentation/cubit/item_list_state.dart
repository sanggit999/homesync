import 'package:home_sync/features/items/domain/entities/item_entity.dart';

/// Dart 3 Sealed Class cho ItemList State
sealed class ItemListState {
  const ItemListState();
}

final class ItemListInitial extends ItemListState {
  const ItemListInitial();
}

final class ItemListLoading extends ItemListState {
  const ItemListLoading();
}

final class ItemListLoaded extends ItemListState {
  const ItemListLoaded({
    required this.items,
    required this.filteredItems,
    this.selectedCategoryId,
    this.selectedLocation,
    this.searchQuery = '',
    this.onlyFavorites = false,
  });

  final List<ItemEntity> items;
  final List<ItemEntity> filteredItems;
  final String? selectedCategoryId;
  final String? selectedLocation;
  final String searchQuery;
  final bool onlyFavorites;

  ItemListLoaded copyWith({
    List<ItemEntity>? items,
    List<ItemEntity>? filteredItems,
    String? selectedCategoryId,
    String? selectedLocation,
    String? searchQuery,
    bool? onlyFavorites,
  }) {
    return ItemListLoaded(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      searchQuery: searchQuery ?? this.searchQuery,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
    );
  }
}

final class ItemListError extends ItemListState {
  const ItemListError(this.message);
  final String message;
}
