import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:home_sync/features/maintenance/domain/repositories/maintenance_repository.dart';

/// Params cho GetTasksUseCase
class GetTasksParams {
  const GetTasksParams({this.itemId, this.isCompleted});
  final String? itemId;
  final bool? isCompleted;
}

/// Use Case: Lấy danh sách lịch bảo trì
class GetTasksUseCase implements UseCase<List<MaintenanceTaskEntity>, GetTasksParams> {
  const GetTasksUseCase(this._repository);
  final MaintenanceRepository _repository;

  @override
  Future<Either<Failure, List<MaintenanceTaskEntity>>> call([GetTasksParams params = const GetTasksParams()]) {
    return _repository.getTasks(itemId: params.itemId, isCompleted: params.isCompleted);
  }
}

/// Use Case: Thêm lịch bảo trì mới
class AddTaskUseCase implements UseCase<MaintenanceTaskEntity, MaintenanceTaskEntity> {
  const AddTaskUseCase(this._repository);
  final MaintenanceRepository _repository;

  @override
  Future<Either<Failure, MaintenanceTaskEntity>> call(MaintenanceTaskEntity task) {
    return _repository.addTask(task);
  }
}

/// Use Case: Cập nhật lịch bảo trì
class UpdateTaskUseCase implements UseCase<MaintenanceTaskEntity, MaintenanceTaskEntity> {
  const UpdateTaskUseCase(this._repository);
  final MaintenanceRepository _repository;

  @override
  Future<Either<Failure, MaintenanceTaskEntity>> call(MaintenanceTaskEntity task) {
    return _repository.updateTask(task);
  }
}

/// Params cho CompleteTaskUseCase
class CompleteTaskParams {
  const CompleteTaskParams({
    required this.taskId,
    required this.completedDate,
    required this.cost,
    this.technicianName,
    this.technicianPhone,
    this.receiptImageUrl,
    this.notes,
  });

  final String taskId;
  final DateTime completedDate;
  final double cost;
  final String? technicianName;
  final String? technicianPhone;
  final String? receiptImageUrl;
  final String? notes;
}

/// Use Case: Hoàn thành lịch bảo trì
class CompleteTaskUseCase implements UseCase<Unit, CompleteTaskParams> {
  const CompleteTaskUseCase(this._repository);
  final MaintenanceRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CompleteTaskParams params) {
    return _repository.completeTask(
      taskId: params.taskId,
      completedDate: params.completedDate,
      cost: params.cost,
      technicianName: params.technicianName,
      technicianPhone: params.technicianPhone,
      receiptImageUrl: params.receiptImageUrl,
      notes: params.notes,
    );
  }
}

/// Use Case: Xóa lịch bảo trì
class DeleteTaskUseCase implements UseCase<Unit, String> {
  const DeleteTaskUseCase(this._repository);
  final MaintenanceRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return _repository.deleteTask(id);
  }
}

/// Use Case: Lấy danh mục thiết bị
class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  const GetCategoriesUseCase(this._repository);
  final MaintenanceRepository _repository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> call([NoParams params = const NoParams()]) {
    return _repository.getCategories();
  }
}

/// Use Case: Lấy gợi ý chu kỳ bảo trì theo danh mục (Smart Presets)
class GetPresetsByCategoryUseCase implements UseCase<List<MaintenancePresetEntity>, String> {
  const GetPresetsByCategoryUseCase(this._repository);
  final MaintenanceRepository _repository;

  @override
  Future<Either<Failure, List<MaintenancePresetEntity>>> call(String categoryId) {
    return _repository.getPresetsByCategory(categoryId);
  }
}

/// Params cho RescheduleTaskUseCase
class RescheduleTaskParams {
  const RescheduleTaskParams({
    required this.taskId,
    required this.newDueDate,
    this.reason,
  });

  final String taskId;
  final DateTime newDueDate;
  final String? reason;
}

/// Use Case: Dời lịch bảo trì sang ngày khác (Snooze / Reschedule)
class RescheduleTaskUseCase implements UseCase<Unit, RescheduleTaskParams> {
  const RescheduleTaskUseCase(this._repository);
  final MaintenanceRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(RescheduleTaskParams params) {
    return _repository.rescheduleTask(
      taskId: params.taskId,
      newDueDate: params.newDueDate,
      reason: params.reason,
    );
  }
}

class CancelTaskParams {
  const CancelTaskParams({
    required this.taskId,
    this.reason,
  });

  final String taskId;
  final String? reason;
}

/// Use Case: Bỏ qua / Hủy chu kỳ bảo dưỡng lần này và lưu vết 0₫ vào sổ cái
class CancelTaskUseCase implements UseCase<Unit, CancelTaskParams> {
  const CancelTaskUseCase(this._repository);
  final MaintenanceRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CancelTaskParams params) {
    return _repository.cancelTaskCycle(
      taskId: params.taskId,
      reason: params.reason,
    );
  }
}

