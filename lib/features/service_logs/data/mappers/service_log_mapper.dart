import '../../domain/entities/service_log_entity.dart';
import '../models/service_log_model.dart';

/// Bộ chuyển đổi 2 chiều giữa ServiceLogModel và ServiceLogEntity
class ServiceLogMapper {
  ServiceLogMapper._();

  static ServiceLogEntity toEntity(ServiceLogModel model) {
    return ServiceLogEntity(
      id: model.id,
      userId: model.userId,
      itemId: model.itemId,
      taskId: model.taskId,
      itemName: model.itemName,
      serviceType: model.serviceType,
      title: model.title,
      serviceDate: model.serviceDate,
      cost: model.cost,
      technicianName: model.technicianName,
      technicianPhone: model.technicianPhone,
      receiptImageUrl: model.receiptImageUrl,
      notes: model.notes,
      createdAt: model.createdAt,
    );
  }

  static ServiceLogModel toModel(ServiceLogEntity entity) {
    return ServiceLogModel(
      id: entity.id,
      userId: entity.userId,
      itemId: entity.itemId,
      taskId: entity.taskId,
      itemName: entity.itemName,
      serviceType: entity.serviceType,
      title: entity.title,
      serviceDate: entity.serviceDate,
      cost: entity.cost,
      technicianName: entity.technicianName,
      technicianPhone: entity.technicianPhone,
      receiptImageUrl: entity.receiptImageUrl,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }
}
