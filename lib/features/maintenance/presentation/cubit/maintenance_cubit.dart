import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/maintenance_task_entity.dart';
import '../../domain/usecases/maintenance_usecases.dart';
import 'maintenance_state.dart';

export 'maintenance_state.dart';

/// Cubit quản lý lịch bảo trì, Smart Presets và hoàn thành công việc
class MaintenanceCubit extends Cubit<MaintenanceState> {
  MaintenanceCubit({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.completeTaskUseCase,
    required this.deleteTaskUseCase,
    required this.getCategoriesUseCase,
    required this.getPresetsByCategoryUseCase,
  }) : super(const MaintenanceInitial());

  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final CompleteTaskUseCase completeTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetPresetsByCategoryUseCase getPresetsByCategoryUseCase;

  /// Tải danh sách lịch bảo trì và danh mục
  Future<void> loadMaintenanceData({String? itemId, bool? isCompleted}) async {
    emit(const MaintenanceLoading());
    final tasksResult = await getTasksUseCase(GetTasksParams(itemId: itemId, isCompleted: isCompleted));
    final categoriesResult = await getCategoriesUseCase();

    tasksResult.fold(
      (failure) => emit(MaintenanceError(failure.message)),
      (tasks) {
        final categories = categoriesResult.getOrElse((_) => []);
        emit(MaintenanceLoaded(tasks: tasks, categories: categories));
      },
    );
  }

  /// Lấy Smart Presets chu kỳ bảo dưỡng gợi ý theo Danh mục thiết bị
  Future<void> loadPresetsForCategory(String categoryId) async {
    if (state is MaintenanceLoaded) {
      final current = state as MaintenanceLoaded;
      final result = await getPresetsByCategoryUseCase(categoryId);
      result.fold(
        (failure) => emit(MaintenanceError(failure.message)),
        (presets) => emit(current.copyWith(presets: presets)),
      );
    }
  }

  /// Thêm lịch bảo trì mới
  Future<void> addTask(MaintenanceTaskEntity task) async {
    final result = await addTaskUseCase(task);
    result.fold(
      (failure) => emit(MaintenanceError(failure.message)),
      (_) => loadMaintenanceData(),
    );
  }

  /// Cập nhật lịch bảo trì
  Future<void> updateTask(MaintenanceTaskEntity task) async {
    final result = await updateTaskUseCase(task);
    result.fold(
      (failure) => emit(MaintenanceError(failure.message)),
      (_) => loadMaintenanceData(),
    );
  }

  /// Hoàn thành lịch bảo trì (tự động tính chu kỳ tiếp theo & lưu vào nhật ký chi phí)
  Future<void> completeTask(CompleteTaskParams params) async {
    final result = await completeTaskUseCase(params);
    result.fold(
      (failure) => emit(MaintenanceError(failure.message)),
      (_) => loadMaintenanceData(),
    );
  }

  /// Xóa lịch bảo trì
  Future<void> deleteTask(String id) async {
    final result = await deleteTaskUseCase(id);
    result.fold(
      (failure) => emit(MaintenanceError(failure.message)),
      (_) => loadMaintenanceData(),
    );
  }
}
