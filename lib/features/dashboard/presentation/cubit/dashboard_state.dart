import 'package:home_sync/features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart';

/// Dart 3 Sealed Class cho Dashboard State
sealed class DashboardState {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.summary);
  final DashboardSummaryEntity summary;
}

final class DashboardError extends DashboardState {
  const DashboardError(this.message);
  final String message;
}
