import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:home_sync/features/maintenance/domain/entities/category_entity.dart';

/// Widget Bộ Lọc Danh Mục dạng Thanh Cuộn Ngang (Horizontal ListView) mượt mà chuẩn Material 3
class ItemFilterChips extends StatelessWidget {
  const ItemFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onlyFavorites,
    required this.onCategorySelected,
    required this.onToggleFavorite,
  });

  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final bool onlyFavorites;
  final ValueChanged<String?> onCategorySelected;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    // Tổng số chip: 1 (Yêu thích) + 1 (Tất cả) + số lượng danh mục
    final totalCount = 2 + categories.length;

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        scrollCacheExtent: const ScrollCacheExtent.pixels(200),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: totalCount,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          // 1. Chip Yêu thích
          if (index == 0) {
            return FilterChip(
              selected: onlyFavorites,
              showCheckmark: false,
              avatar: Icon(
                onlyFavorites ? Icons.star : Icons.star_border,
                size: 16,
                color: onlyFavorites ? Colors.amber : null,
              ),
              label: const Text('Yêu thích'),
              onSelected: (_) => onToggleFavorite(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            );
          }

          // 2. Chip Tất cả
          if (index == 1) {
            return ChoiceChip(
              showCheckmark: false,
              label: const Text('Tất cả'),
              selected: selectedCategoryId == null,
              onSelected: (selected) {
                if (selected) onCategorySelected(null);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            );
          }

          // 3. Danh sách 7 Danh mục chuẩn ('Khác' luôn ở cuối)
          final catIndex = index - 2;
          final cat = categories[catIndex];
          final isSelected = selectedCategoryId == cat.id;

          return ChoiceChip(
            showCheckmark: false,
            label: Text(cat.name),
            selected: isSelected,
            onSelected: (selected) {
              onCategorySelected(selected ? cat.id : null);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        },
      ),
    );
  }
}
