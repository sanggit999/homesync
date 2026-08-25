import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../entities/maintenance_task_entity.dart';
export '../entities/category_entity.dart';
export '../entities/maintenance_task_entity.dart';

/// Abstract Repository Contract cho Lịch Bảo Trì & Presets dùng fpdart Either
abstract class MaintenanceRepository {
  Future<Either<Failure, List<MaintenanceTaskEntity>>> getTasks({String? itemId, bool? isCompleted});
  Future<Either<Failure, MaintenanceTaskEntity>> addTask(MaintenanceTaskEntity task);
  Future<Either<Failure, MaintenanceTaskEntity>> updateTask(MaintenanceTaskEntity task);
  Future<Either<Failure, Unit>> completeTask({
    required String taskId,
    required DateTime completedDate,
    required double cost,
    String? technicianName,
    String? technicianPhone,
    String? receiptImageUrl,
    String? notes,
  });
  Future<Either<Failure, Unit>> deleteTask(String id);
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<MaintenancePresetEntity>>> getPresetsByCategory(String categoryId);
}
