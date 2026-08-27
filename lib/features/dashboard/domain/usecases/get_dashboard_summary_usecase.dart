import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:home_sync/features/dashboard/domain/entities/dashboard_summary_entity.dart';
import 'package:home_sync/features/dashboard/domain/repositories/dashboard_repository.dart';

export 'package:home_sync/features/dashboard/domain/entities/dashboard_summary_entity.dart';

/// Use Case: Lấy dữ liệu tổng quan trang chủ
class GetDashboardSummaryUseCase implements UseCase<DashboardSummaryEntity, NoParams> {
  const GetDashboardSummaryUseCase({
    required this.dashboardRepository,
  });

  final DashboardRepository dashboardRepository;

  @override
  Future<Either<Failure, DashboardSummaryEntity>> call([NoParams params = const NoParams()]) {
    return dashboardRepository.getDashboardSummary();
  }
}
