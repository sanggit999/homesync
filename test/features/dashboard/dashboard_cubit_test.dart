import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:home_sync/features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:home_sync/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDashboardSummaryUseCase extends Mock implements GetDashboardSummaryUseCase {}

void main() {
  late MockGetDashboardSummaryUseCase mockGetDashboardSummary;
  late DashboardCubit dashboardCubit;

  const tSummary = DashboardSummaryEntity(
    totalAssetsCount: 5,
    totalAssetValue: 45000000.0,
    goodCount: 3,
    warningCount: 1,
    expiredCount: 1,
    expiringSoonItems: [],
    upcomingTasks: [],
    totalSpentThisMonth: 1200000.0,
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockGetDashboardSummary = MockGetDashboardSummaryUseCase();
    dashboardCubit = DashboardCubit(
      getDashboardSummaryUseCase: mockGetDashboardSummary,
    );
  });

  tearDown(() {
    dashboardCubit.close();
  });

  group('DashboardCubit State Machine Tests', () {
    test('initial state should be DashboardInitial', () {
      expect(dashboardCubit.state, isA<DashboardInitial>());
    });

    blocTest<DashboardCubit, DashboardState>(
      'emits [DashboardLoading, DashboardLoaded] when loadDashboard succeeds',
      build: () {
        when(() => mockGetDashboardSummary(any())).thenAnswer((_) async => const Right(tSummary));
        return dashboardCubit;
      },
      act: (cubit) => cubit.loadDashboard(),
      expect: () => [
        isA<DashboardLoading>(),
        isA<DashboardLoaded>()
            .having((s) => s.summary.totalAssetsCount, 'total assets', 5)
            .having((s) => s.summary.totalSpentThisMonth, 'total spent', 1200000.0),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'emits [DashboardLoading, DashboardError] when loadDashboard fails',
      build: () {
        when(() => mockGetDashboardSummary(any())).thenAnswer((_) async => const Left(ServerFailure('Lỗi tải dữ liệu')));
        return dashboardCubit;
      },
      act: (cubit) => cubit.loadDashboard(),
      expect: () => [
        isA<DashboardLoading>(),
        isA<DashboardError>().having((s) => s.message, 'error message', 'Lỗi tải dữ liệu'),
      ],
    );
  });
}
