import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/utils/demo_data_seeder.dart';
import 'package:home_sync/core/utils/snackbar_utils.dart';
import 'package:home_sync/core/widgets/empty_state_widget.dart';
import 'package:home_sync/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_cubit.dart';
import 'package:home_sync/features/items/presentation/widgets/item_card.dart';
import 'package:home_sync/features/items/presentation/widgets/item_card_skeleton.dart';
import 'package:home_sync/features/items/presentation/widgets/item_filter_chips.dart';
import 'package:home_sync/features/items/presentation/widgets/item_search_bar.dart';
import 'package:home_sync/features/maintenance/domain/entities/category_entity.dart';

/// Tab 2: Danh sách Thiết bị, Tìm kiếm tức thì & Lọc đa tiêu chí
class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final _searchController = TextEditingController();
  bool _isSeeding = false;

  @override
  void initState() {
    super.initState();
    context.read<ItemListCubit>().loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleSeedDemoData() async {
    setState(() => _isSeeding = true);
    AppSnackBar.showSuccess(context, 'Đang tự động tạo 6 thiết bị mẫu...');
    
    final success = await DemoDataSeeder.seedDemoData();
    if (!mounted) return;

    setState(() => _isSeeding = false);
    if (success) {
      context.read<ItemListCubit>().loadItems();
      context.read<DashboardCubit>().loadDashboard();
      AppSnackBar.showSuccess(context, '🎉 Đã nạp thành công 6 thiết bị mẫu phong phú!');
    } else {
      AppSnackBar.showError(context, 'Không thể nạp dữ liệu mẫu. Vui lòng thử lại!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thiết bị & Bảo hành'),
        actions: [
          IconButton(
            icon: _isSeeding 
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(LucideIcons.sparkles, color: Colors.amber),
            tooltip: 'Nạp dữ liệu mẫu nhanh',
            onPressed: _isSeeding ? null : _handleSeedDemoData,
          ),
          IconButton(
            icon: const Icon(LucideIcons.plus),
            tooltip: 'Thêm thiết bị mới',
            onPressed: () => context.push(AppRoutes.itemsAdd),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'item_list_fab',
        onPressed: () => context.push(AppRoutes.itemsAdd),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Thêm thiết bị'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 1. Instant Search Bar
          ItemSearchBar(
            controller: _searchController,
            onChanged: (val) => context.read<ItemListCubit>().search(val),
            onClear: () {
              _searchController.clear();
              context.read<ItemListCubit>().search('');
            },
          ),

          // 2. Filter Bar (Category Chips + Favorite Toggle)
          BlocBuilder<ItemListCubit, ItemListState>(
            builder: (context, state) {
              final categories = state is ItemListLoaded ? state.categories : <CategoryEntity>[];
              final selectedCatId = state is ItemListLoaded ? state.selectedCategoryId : null;
              final onlyFavorites = state is ItemListLoaded ? state.onlyFavorites : false;

              return ItemFilterChips(
                categories: categories,
                selectedCategoryId: selectedCatId,
                onlyFavorites: onlyFavorites,
                onCategorySelected: (catId) => context.read<ItemListCubit>().filterByCategory(catId),
                onToggleFavorite: () => context.read<ItemListCubit>().toggleFavoriteFilter(),
              );
            },
          ),

          const SizedBox(height: 8),

          // 3. Items List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => context.read<ItemListCubit>().loadItems(),
              child: BlocConsumer<ItemListCubit, ItemListState>(
                listener: (context, state) {
                  if (state is ItemListError) {
                    AppSnackBar.showError(context, state.message);
                  }
                },
                builder: (context, state) => switch (state) {
                  ItemListInitial() || ItemListLoading() => const ItemListSkeletonView(),
                  ItemListError(:final message) => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 80),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(LucideIcons.wifiOff, size: 56, color: AppColors.error),
                                const SizedBox(height: 16),
                                Text(
                                  message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () => context.read<ItemListCubit>().loadItems(),
                                  icon: const Icon(LucideIcons.refreshCw, size: 16),
                                  label: const Text('Thử lại'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ItemListLoaded(:final filteredItems) => filteredItems.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(height: 40),
                            EmptyStateWidget(
                              icon: LucideIcons.layers,
                              title: 'Chưa có thiết bị nào',
                              subtitle: _searchController.text.isNotEmpty
                                  ? 'Hãy thử tìm với từ khóa khác'
                                  : 'Bạn có thể thêm thiết bị thủ công hoặc bấm nút bên dưới để tạo nhanh 7 thiết bị mẫu trải nghiệm.',
                              actionLabel: '✨ Nạp 7 thiết bị mẫu nhanh',
                              onAction: _handleSeedDemoData,
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                          itemCount: filteredItems.length,
                          scrollCacheExtent: const ScrollCacheExtent.pixels(500),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return ItemCard(
                              item: item,
                              onTap: () => context.push(AppRoutes.itemDetailPath(item.id)),
                              onToggleFavorite: () => context
                                  .read<ItemListCubit>()
                                  .toggleItemFavorite(item.id, item.isFavorite),
                            );
                          },
                        ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
