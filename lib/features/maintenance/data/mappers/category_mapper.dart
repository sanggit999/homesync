import 'package:home_sync/features/maintenance/domain/entities/category_entity.dart';
import 'package:home_sync/features/maintenance/data/models/category_model.dart';
import 'package:home_sync/features/maintenance/data/models/maintenance_preset_model.dart';

/// Bộ chuyển đổi 2 chiều giữa CategoryModel / MaintenancePresetModel và CategoryEntity / MaintenancePresetEntity
class CategoryMapper {
  CategoryMapper._();

  static CategoryEntity toEntity(CategoryModel model) {
    return CategoryEntity(
      id: model.id,
      name: model.name,
      iconName: model.iconName,
      userId: model.userId,
      createdAt: model.createdAt,
    );
  }

  static CategoryModel toModel(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      iconName: entity.iconName,
      userId: entity.userId,
      createdAt: entity.createdAt,
    );
  }

  static MaintenancePresetEntity presetToEntity(MaintenancePresetModel model) {
    return MaintenancePresetEntity(
      id: model.id,
      categoryId: model.categoryId,
      presetName: model.presetName,
      defaultFrequencyMonths: model.defaultFrequencyMonths,
      suggestedPriority: model.suggestedPriority,
    );
  }

  static MaintenancePresetModel presetToModel(MaintenancePresetEntity entity) {
    return MaintenancePresetModel(
      id: entity.id,
      categoryId: entity.categoryId,
      presetName: entity.presetName,
      defaultFrequencyMonths: entity.defaultFrequencyMonths,
      suggestedPriority: entity.suggestedPriority,
    );
  }
}
