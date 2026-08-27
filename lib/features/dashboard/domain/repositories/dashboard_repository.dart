import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/features/dashboard/domain/entities/dashboard_summary_entity.dart';

/// Contract Repository cho module Dashboard theo Clean Architecture
abstract class DashboardRepository {
  Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary();
}
