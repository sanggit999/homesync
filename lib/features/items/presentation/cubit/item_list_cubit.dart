import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:home_sync/features/items/domain/entities/item_entity.dart';
import 'package:home_sync/features/items/domain/usecases/item_usecases.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_state.dart';
import 'package:home_sync/features/maintenance/domain/entities/category_entity.dart';
import 'package:home_sync/features/maintenance/domain/usecases/maintenance_usecases.dart';

export 'item_list_state.dart';

/// Cubit quản lý danh sách thiết bị, tìm kiếm tức thì & bộ lọc đa tiêu chí chuẩn Clean Architecture
class ItemListCubit extends Cubit<ItemListState> {
  ItemListCubit({
    required this.getItemsUseCase,
    required this.getCategoriesUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(const ItemListInitial());

  final GetItemsUseCase getItemsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  List<ItemEntity> _allCachedItems = [];
  List<CategoryEntity> _allCachedCategories = [];

  /// Tải toàn bộ danh sách thiết bị & danh mục thực tế từ Database
  Future<void> loadItems() async {
    emit(const ItemListLoading());
    final results = await Future.wait([
      getItemsUseCase(),
      getCategoriesUseCase(const NoParams()),
    ]);

    final itemsResult = results[0];
    final categoriesResult = results[1];

    itemsResult.fold(
      (failure) => emit(ItemListError(failure.message)),
      (items) {
        _allCachedItems = items as List<ItemEntity>;
        categoriesResult.fold(
          (_) => _allCachedCategories = [],
          (cats) => _allCachedCategories = cats as List<CategoryEntity>,
        );
        _applyFilters();
      },
    );
  }

  /// Lọc theo ID danh mục chuẩn xác (UUID Matching)
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

    // Lọc theo Category ID chuẩn 100% (Không hardcode hay fuzzy matching)
    if (selectedCategoryId != null && selectedCategoryId.isNotEmpty) {
      filtered = filtered.where((item) => item.categoryId == selectedCategoryId).toList();
    }

    // Lọc theo Vị trí
    if (selectedLocation != null && selectedLocation.isNotEmpty) {
      filtered = filtered.where((item) => item.location == selectedLocation).toList();
    }

    // Lọc theo Yêu thích
    if (onlyFavorites) {
      filtered = filtered.where((item) => item.isFavorite).toList();
    }

    // Tìm kiếm tức thì theo Domain Logic
    if (searchQuery.trim().isNotEmpty) {
      filtered = filtered.where((item) => item.matchesSearch(searchQuery)).toList();
    }

    emit(ItemListLoaded(
      items: _allCachedItems,
      filteredItems: filtered,
      categories: _allCachedCategories,
      selectedCategoryId: selectedCategoryId,
      selectedLocation: selectedLocation,
      searchQuery: searchQuery,
      onlyFavorites: onlyFavorites,
    ));
  }
}
