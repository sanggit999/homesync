import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_sync/features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:home_sync/features/dashboard/presentation/cubit/dashboard_state.dart';

export 'dashboard_state.dart';

/// Cubit quản lý dữ liệu tổng quan trang chủ (Radar sức khỏe, chi tiêu, cảnh báo)
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required this.getDashboardSummaryUseCase})
      : super(const DashboardInitial());

  final GetDashboardSummaryUseCase getDashboardSummaryUseCase;

  /// Tải dữ liệu tổng quan trang chủ
  Future<void> loadDashboard() async {
    emit(const DashboardLoading());
    final result = await getDashboardSummaryUseCase();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (summary) => emit(DashboardLoaded(summary)),
    );
  }

  /// Pull-to-refresh làm mới dữ liệu
  Future<void> refreshDashboard() async {
    final result = await getDashboardSummaryUseCase();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (summary) => emit(DashboardLoaded(summary)),
    );
  }
}
