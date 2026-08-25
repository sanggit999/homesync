import 'package:home_sync/features/maintenance/domain/entities/category_entity.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';

/// Dart 3 Sealed Class cho Maintenance State
sealed class MaintenanceState {
  const MaintenanceState();
}

final class MaintenanceInitial extends MaintenanceState {
  const MaintenanceInitial();
}

final class MaintenanceLoading extends MaintenanceState {
  const MaintenanceLoading();
}

final class MaintenanceLoaded extends MaintenanceState {
  const MaintenanceLoaded({
    required this.tasks,
    this.categories = const [],
    this.presets = const [],
  });

  final List<MaintenanceTaskEntity> tasks;
  final List<CategoryEntity> categories;
  final List<MaintenancePresetEntity> presets;

  MaintenanceLoaded copyWith({
    List<MaintenanceTaskEntity>? tasks,
    List<CategoryEntity>? categories,
    List<MaintenancePresetEntity>? presets,
  }) {
    return MaintenanceLoaded(
      tasks: tasks ?? this.tasks,
      categories: categories ?? this.categories,
      presets: presets ?? this.presets,
    );
  }
}

final class MaintenanceActionSuccess extends MaintenanceState {
  const MaintenanceActionSuccess(this.message);
  final String message;
}

final class MaintenanceError extends MaintenanceState {
  const MaintenanceError(this.message);
  final String message;
}
