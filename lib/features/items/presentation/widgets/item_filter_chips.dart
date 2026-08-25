import 'package:flutter/material.dart';

/// Widget Bộ Lọc Danh Mục & Yêu Thích
class ItemFilterChips extends StatelessWidget {
  const ItemFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onlyFavorites,
    required this.onCategorySelected,
    required this.onToggleFavorite,
  });

  final List<String> categories;
  final String? selectedCategory;
  final bool onlyFavorites;
  final ValueChanged<String?> onCategorySelected;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          // Favorite Filter Chip
          FilterChip(
            selected: onlyFavorites,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  onlyFavorites ? Icons.star : Icons.star_border,
                  size: 16,
                  color: onlyFavorites ? Colors.amber : null,
                ),
                const SizedBox(width: 4),
                const Text('Yêu thích'),
              ],
            ),
            onSelected: (_) => onToggleFavorite(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(width: 8),

          // Categories Chips
          ...categories.map((cat) {
            final isSelected = (cat == 'Tất cả' && selectedCategory == null) || (selectedCategory == cat);
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (selected) {
                  onCategorySelected(cat == 'Tất cả' ? null : cat);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }),
        ],
      ),
    );
  }
}
