/// Entity đại diện cho Danh mục thiết bị
class CategoryEntity {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconName,
    this.createdAt,
  });

  final String id;
  final String name;
  final String iconName;
  final DateTime? createdAt;
}

/// Entity đại diện cho Mẫu Gợi Ý Chu Kỳ Bảo Trì Thông Minh (Presets)
class MaintenancePresetEntity {
  const MaintenancePresetEntity({
    required this.id,
    required this.categoryId,
    required this.presetName,
    required this.defaultFrequencyMonths,
    this.suggestedPriority = 'medium',
  });

  final String id;
  final String categoryId;
  final String presetName;
  final int defaultFrequencyMonths;
  final String suggestedPriority;
}
