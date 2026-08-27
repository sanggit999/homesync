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
