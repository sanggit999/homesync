import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:home_sync/features/maintenance/domain/entities/category_entity.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';
import 'package:home_sync/features/maintenance/presentation/cubit/maintenance_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTasksUseCase extends Mock implements GetTasksUseCase {}
class MockAddTaskUseCase extends Mock implements AddTaskUseCase {}
class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}
class MockCompleteTaskUseCase extends Mock implements CompleteTaskUseCase {}
class MockRescheduleTaskUseCase extends Mock implements RescheduleTaskUseCase {}
class MockCancelTaskUseCase extends Mock implements CancelTaskUseCase {}
class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}
class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}
class MockGetPresetsByCategoryUseCase extends Mock implements GetPresetsByCategoryUseCase {}

void main() {
  late MockGetTasksUseCase mockGetTasks;
  late MockAddTaskUseCase mockAddTask;
  late MockUpdateTaskUseCase mockUpdateTask;
  late MockCompleteTaskUseCase mockCompleteTask;
  late MockRescheduleTaskUseCase mockRescheduleTask;
  late MockCancelTaskUseCase mockCancelTask;
  late MockDeleteTaskUseCase mockDeleteTask;
  late MockGetCategoriesUseCase mockGetCategories;
  late MockGetPresetsByCategoryUseCase mockGetPresets;
  late MaintenanceCubit maintenanceCubit;

  final tTask = MaintenanceTaskEntity(
    id: 'task-1',
    itemId: 'item-1',
    taskName: 'Vệ sinh máy lạnh',
    frequencyMonths: 6,
    nextDueDate: DateTime(2026, 9, 15),
    itemName: 'Máy lạnh Daikin',
  );

  final tCategory = const CategoryEntity(id: 'cat-1', name: 'Điện lạnh', iconName: 'snowflake');

  setUpAll(() {
    registerFallbackValue(const GetTasksParams());
    registerFallbackValue(const NoParams());
    registerFallbackValue(MaintenanceTaskEntity(
      id: 'fallback',
      itemId: 'fallback',
      taskName: 'fallback',
      frequencyMonths: 1,
      nextDueDate: DateTime.now(),
    ));
    registerFallbackValue(CompleteTaskParams(
      taskId: 'fallback',
      completedDate: DateTime.now(),
      cost: 0,
    ));
    registerFallbackValue(RescheduleTaskParams(
      taskId: 'fallback',
      newDueDate: DateTime.now(),
    ));
    registerFallbackValue(const CancelTaskParams(
      taskId: 'fallback',
    ));
  });

  setUp(() {
    mockGetTasks = MockGetTasksUseCase();
    mockAddTask = MockAddTaskUseCase();
    mockUpdateTask = MockUpdateTaskUseCase();
    mockCompleteTask = MockCompleteTaskUseCase();
    mockRescheduleTask = MockRescheduleTaskUseCase();
    mockCancelTask = MockCancelTaskUseCase();
    mockDeleteTask = MockDeleteTaskUseCase();
    mockGetCategories = MockGetCategoriesUseCase();
    mockGetPresets = MockGetPresetsByCategoryUseCase();

    maintenanceCubit = MaintenanceCubit(
      getTasksUseCase: mockGetTasks,
      addTaskUseCase: mockAddTask,
      updateTaskUseCase: mockUpdateTask,
      completeTaskUseCase: mockCompleteTask,
      rescheduleTaskUseCase: mockRescheduleTask,
      cancelTaskUseCase: mockCancelTask,
      deleteTaskUseCase: mockDeleteTask,
      getCategoriesUseCase: mockGetCategories,
      getPresetsByCategoryUseCase: mockGetPresets,
    );
  });

  tearDown(() {
    maintenanceCubit.close();
  });

  group('MaintenanceCubit State Machine Tests', () {
    test('initial state should be MaintenanceInitial', () {
      expect(maintenanceCubit.state, const MaintenanceInitial());
    });

    blocTest<MaintenanceCubit, MaintenanceState>(
      'emits [MaintenanceLoading, MaintenanceLoaded] when loadMaintenanceData succeeds',
      build: () {
        when(() => mockGetTasks(any())).thenAnswer((_) async => Right([tTask]));
        when(() => mockGetCategories(any())).thenAnswer((_) async => Right([tCategory]));
        return maintenanceCubit;
      },
      act: (cubit) => cubit.loadMaintenanceData(),
      expect: () => [
        isA<MaintenanceLoading>(),
        isA<MaintenanceLoaded>().having((s) => s.tasks.length, 'tasks count', 1),
      ],
    );

    blocTest<MaintenanceCubit, MaintenanceState>(
      'emits [MaintenanceLoading, MaintenanceError] when loadMaintenanceData fails',
      build: () {
        when(() => mockGetTasks(any())).thenAnswer((_) async => const Left(ServerFailure('Lỗi tải')));
        when(() => mockGetCategories(any())).thenAnswer((_) async => Right([tCategory]));
        return maintenanceCubit;
      },
      act: (cubit) => cubit.loadMaintenanceData(),
      expect: () => [
        isA<MaintenanceLoading>(),
        isA<MaintenanceError>().having((s) => s.message, 'error message', 'Lỗi tải'),
      ],
    );

    blocTest<MaintenanceCubit, MaintenanceState>(
      'reloads data when completeTask succeeds',
      build: () {
        when(() => mockCompleteTask(any())).thenAnswer((_) async => const Right(unit));
        when(() => mockGetTasks(any())).thenAnswer((_) async => Right([tTask]));
        when(() => mockGetCategories(any())).thenAnswer((_) async => Right([tCategory]));
        return maintenanceCubit;
      },
      act: (cubit) => cubit.completeTask(CompleteTaskParams(
        taskId: 'task-1',
        completedDate: DateTime.now(),
        cost: 250000,
      )),
      expect: () => [
        isA<MaintenanceLoading>(),
        isA<MaintenanceLoaded>(),
      ],
      verify: (_) {
        verify(() => mockCompleteTask(any())).called(1);
      },
    );

    blocTest<MaintenanceCubit, MaintenanceState>(
      'reloads data when rescheduleTask succeeds',
      build: () {
        when(() => mockRescheduleTask(any())).thenAnswer((_) async => const Right(unit));
        when(() => mockGetTasks(any())).thenAnswer((_) async => Right([tTask]));
        when(() => mockGetCategories(any())).thenAnswer((_) async => Right([tCategory]));
        return maintenanceCubit;
      },
      act: (cubit) => cubit.rescheduleTask(RescheduleTaskParams(
        taskId: 'task-1',
        newDueDate: DateTime(2026, 10, 1),
      )),
      expect: () => [
        isA<MaintenanceLoading>(),
        isA<MaintenanceLoaded>(),
      ],
      verify: (_) {
        verify(() => mockRescheduleTask(any())).called(1);
      },
    );

    blocTest<MaintenanceCubit, MaintenanceState>(
      'reloads data when cancelTask succeeds',
      build: () {
        when(() => mockCancelTask(any())).thenAnswer((_) async => const Right(unit));
        when(() => mockGetTasks(any())).thenAnswer((_) async => Right([tTask]));
        when(() => mockGetCategories(any())).thenAnswer((_) async => Right([tCategory]));
        return maintenanceCubit;
      },
      act: (cubit) => cubit.cancelTask(const CancelTaskParams(
        taskId: 'task-1',
        reason: 'Mùa đông ít dùng',
      )),
      expect: () => [
        isA<MaintenanceLoading>(),
        isA<MaintenanceLoaded>(),
      ],
      verify: (_) {
        verify(() => mockCancelTask(any())).called(1);
      },
    );

    blocTest<MaintenanceCubit, MaintenanceState>(
      'reloads data when deleteTask succeeds',
      build: () {
        when(() => mockDeleteTask(any())).thenAnswer((_) async => const Right(unit));
        when(() => mockGetTasks(any())).thenAnswer((_) async => const Right([]));
        when(() => mockGetCategories(any())).thenAnswer((_) async => const Right([]));
        return maintenanceCubit;
      },
      act: (cubit) => cubit.deleteTask('task-1'),
      expect: () => [
        isA<MaintenanceLoading>(),
        isA<MaintenanceLoaded>().having((s) => s.tasks.isEmpty, 'empty tasks', true),
      ],
      verify: (_) {
        verify(() => mockDeleteTask('task-1')).called(1);
      },
    );
  });
}
