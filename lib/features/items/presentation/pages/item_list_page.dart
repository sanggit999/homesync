import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/widgets/empty_state_widget.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_cubit.dart';
import 'package:home_sync/features/items/presentation/widgets/item_card.dart';
import 'package:home_sync/features/items/presentation/widgets/item_filter_chips.dart';
import 'package:home_sync/features/items/presentation/widgets/item_search_bar.dart';

/// Tab 2: Danh sách Thiết bị, Tìm kiếm tức thì & Lọc đa tiêu chí
class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'Tất cả',
    'Điện lạnh',
    'Điện tử',
    'Gia dụng',
    'Thiết bị bếp',
    'Xe cộ',
    'Cá nhân',
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thiết bị & Bảo hành'),
        actions: [
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
              final selectedCat = state is ItemListLoaded ? state.selectedCategoryId : null;
              final onlyFavorites = state is ItemListLoaded ? state.onlyFavorites : false;

              return ItemFilterChips(
                categories: _categories,
                selectedCategory: selectedCat,
                onlyFavorites: onlyFavorites,
                onCategorySelected: (cat) => context.read<ItemListCubit>().filterByCategory(cat),
                onToggleFavorite: () => context.read<ItemListCubit>().toggleFavoriteFilter(),
              );
            },
          ),

          const SizedBox(height: 8),

          // 3. Items List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => context.read<ItemListCubit>().loadItems(),
              child: BlocBuilder<ItemListCubit, ItemListState>(
                builder: (context, state) => switch (state) {
                  ItemListInitial() || ItemListLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ItemListError(:final message) => Center(
                      child: Text(message),
                    ),
                  ItemListLoaded(:final filteredItems) => filteredItems.isEmpty
                      ? EmptyStateWidget(
                          icon: LucideIcons.layers,
                          title: 'Không tìm thấy thiết bị',
                          subtitle: _searchController.text.isNotEmpty
                              ? 'Hãy thử tìm với từ khóa khác'
                              : 'Bắt đầu bằng việc thêm thiết bị đầu tiên vào ngôi nhà của bạn.',
                          actionLabel: _searchController.text.isEmpty ? 'Thêm thiết bị ngay' : null,
                          onAction: () => context.push(AppRoutes.itemsAdd),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                          itemCount: filteredItems.length,
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
