import '../../domain/entities/maintenance_task_entity.dart';
import '../models/maintenance_task_model.dart';

/// Bộ chuyển đổi 2 chiều giữa MaintenanceTaskModel và MaintenanceTaskEntity
class MaintenanceTaskMapper {
  MaintenanceTaskMapper._();

  static MaintenanceTaskEntity toEntity(MaintenanceTaskModel model) {
    return MaintenanceTaskEntity(
      id: model.id,
      itemId: model.itemId,
      taskName: model.taskName,
      frequencyMonths: model.frequencyMonths,
      nextDueDate: model.nextDueDate,
      itemName: model.itemName,
      itemLocation: model.itemLocation,
      lastCompletedAt: model.lastCompletedAt,
      isCompleted: model.isCompleted,
      priority: model.priority,
      technicianName: model.technicianName,
      technicianPhone: model.technicianPhone,
      estimatedCost: model.estimatedCost,
      cost: model.cost,
      notes: model.notes,
      createdAt: model.createdAt,
    );
  }

  static MaintenanceTaskModel toModel(MaintenanceTaskEntity entity) {
    return MaintenanceTaskModel(
      id: entity.id,
      itemId: entity.itemId,
      taskName: entity.taskName,
      frequencyMonths: entity.frequencyMonths,
      nextDueDate: entity.nextDueDate,
      itemName: entity.itemName,
      itemLocation: entity.itemLocation,
      lastCompletedAt: entity.lastCompletedAt,
      isCompleted: entity.isCompleted,
      priority: entity.priority,
      technicianName: entity.technicianName,
      technicianPhone: entity.technicianPhone,
      estimatedCost: entity.estimatedCost,
      cost: entity.cost,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }
}
