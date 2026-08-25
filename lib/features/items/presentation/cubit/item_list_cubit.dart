import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/usecases/item_usecases.dart';
import 'item_list_state.dart';

export 'item_list_state.dart';

/// Cubit quản lý danh sách thiết bị, tìm kiếm tức thì & bộ lọc đa tiêu chí
class ItemListCubit extends Cubit<ItemListState> {
  ItemListCubit({
    required this.getItemsUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(const ItemListInitial());

  final GetItemsUseCase getItemsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  List<ItemEntity> _allCachedItems = [];

  /// Tải toàn bộ danh sách thiết bị
  Future<void> loadItems() async {
    emit(const ItemListLoading());
    final result = await getItemsUseCase();
    result.fold(
      (failure) => emit(ItemListError(failure.message)),
      (items) {
        _allCachedItems = items;
        _applyFilters();
      },
    );
  }

  /// Lọc theo danh mục
  void filterByCategory(String? categoryId) {
    if (state is ItemListLoaded) {
      final current = state as ItemListLoaded;
      final newCategoryId = current.selectedCategoryId == categoryId ? null : categoryId;
      _applyFilters(
        selectedCategoryId: newCategoryId,
        selectedLocation: current.selectedLocation,
        searchQuery: current.searchQuery,
        onlyFavorites: current.onlyFavorites,
      );
    }
  }

  /// Lọc theo vị trí / phòng
  void filterByLocation(String? location) {
    if (state is ItemListLoaded) {
      final current = state as ItemListLoaded;
      final newLocation = current.selectedLocation == location ? null : location;
      _applyFilters(
        selectedCategoryId: current.selectedCategoryId,
        selectedLocation: newLocation,
        searchQuery: current.searchQuery,
        onlyFavorites: current.onlyFavorites,
      );
    }
  }

  /// Tìm kiếm tức thì (Global Instant Search)
  void search(String query) {
    if (state is ItemListLoaded) {
      final current = state as ItemListLoaded;
      _applyFilters(
        selectedCategoryId: current.selectedCategoryId,
        selectedLocation: current.selectedLocation,
        searchQuery: query,
        onlyFavorites: current.onlyFavorites,
      );
    }
  }

  /// Bật / Tắt lọc thiết bị yêu thích
  void toggleFavoriteFilter() {
    if (state is ItemListLoaded) {
      final current = state as ItemListLoaded;
      _applyFilters(
        selectedCategoryId: current.selectedCategoryId,
        selectedLocation: current.selectedLocation,
        searchQuery: current.searchQuery,
        onlyFavorites: !current.onlyFavorites,
      );
    }
  }

  /// Đánh dấu / Bỏ đánh dấu sao thiết bị yêu thích
  Future<void> toggleItemFavorite(String itemId, bool currentStatus) async {
    final newStatus = !currentStatus;
    // Cập nhật optimistic local cache
    _allCachedItems = _allCachedItems.map((item) {
      if (item.id == itemId) {
        return ItemEntity(
          id: item.id,
          userId: item.userId,
          homeId: item.homeId,
          categoryId: item.categoryId,
          categoryName: item.categoryName,
          categoryIcon: item.categoryIcon,
          name: item.name,
          brand: item.brand,
          modelNumber: item.modelNumber,
          serialNumber: item.serialNumber,
          location: item.location,
          price: item.price,
          storeName: item.storeName,
          status: item.status,
          isFavorite: newStatus,
          tags: item.tags,
          purchaseDate: item.purchaseDate,
          warrantyPeriodMonths: item.warrantyPeriodMonths,
          warrantyExpiryDate: item.warrantyExpiryDate,
          warrantyType: item.warrantyType,
          supportPhone: item.supportPhone,
          deviceImageUrl: item.deviceImageUrl,
          receiptImageUrl: item.receiptImageUrl,
          warrantyCardImageUrl: item.warrantyCardImageUrl,
          manualUrl: item.manualUrl,
          notes: item.notes,
          createdAt: item.createdAt,
        );
      }
      return item;
    }).toList();

    _applyFilters();
    await toggleFavoriteUseCase(ToggleFavoriteParams(id: itemId, isFavorite: newStatus));
  }

  void _applyFilters({
    String? selectedCategoryId,
    String? selectedLocation,
    String searchQuery = '',
    bool onlyFavorites = false,
  }) {
    List<ItemEntity> filtered = List.from(_allCachedItems);

    if (selectedCategoryId != null && selectedCategoryId.isNotEmpty) {
      filtered = filtered.where((item) => item.categoryId == selectedCategoryId).toList();
    }

    if (selectedLocation != null && selectedLocation.isNotEmpty) {
      filtered = filtered.where((item) => item.location == selectedLocation).toList();
    }

    if (onlyFavorites) {
      filtered = filtered.where((item) => item.isFavorite).toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      filtered = filtered.where((item) {
        final name = item.name.toLowerCase();
        final brand = (item.brand ?? '').toLowerCase();
        final serial = (item.serialNumber ?? '').toLowerCase();
        final model = (item.modelNumber ?? '').toLowerCase();
        final location = (item.location ?? '').toLowerCase();
        final store = (item.storeName ?? '').toLowerCase();
        return name.contains(q) ||
            brand.contains(q) ||
            serial.contains(q) ||
            model.contains(q) ||
            location.contains(q) ||
            store.contains(q);
      }).toList();
    }

    emit(ItemListLoaded(
      items: _allCachedItems,
      filteredItems: filtered,
      selectedCategoryId: selectedCategoryId,
      selectedLocation: selectedLocation,
      searchQuery: searchQuery,
      onlyFavorites: onlyFavorites,
    ));
  }
}
