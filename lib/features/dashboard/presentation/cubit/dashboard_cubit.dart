import 'package:flutter/foundation.dart';
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
    debugPrint('[HOMESYNC DASHBOARD] Bắt đầu tải dữ liệu trang Tổng quan...');
    emit(const DashboardLoading());
    final result = await getDashboardSummaryUseCase();
    result.fold(
      (failure) {
        debugPrint('[HOMESYNC DASHBOARD] Tải dữ liệu THẤT BẠI: ${failure.message}');
        emit(DashboardError(failure.message));
      },
      (summary) {
        debugPrint('[HOMESYNC DASHBOARD] Tải dữ liệu THÀNH CÔNG:');
        debugPrint('  - Tổng số thiết bị: ${summary.totalAssetsCount}');
        debugPrint('  - Thiết bị còn hạn tốt: ${summary.goodCount}');
        debugPrint('  - Sắp hết hạn bảo hành: ${summary.warningCount}');
        debugPrint('  - Đã hết hạn bảo hành: ${summary.expiredCount}');
        debugPrint('  - Tổng chi tiêu tháng này: ${summary.totalSpentThisMonth} VNĐ');
        emit(DashboardLoaded(summary));
      },
    );
  }

  /// Pull-to-refresh làm mới dữ liệu
  Future<void> refreshDashboard() async {
    debugPrint('[HOMESYNC DASHBOARD] Đang làm mới dữ liệu Tổng quan (Pull-to-refresh)...');
    final result = await getDashboardSummaryUseCase();
    result.fold(
      (failure) {
        debugPrint('[HOMESYNC DASHBOARD] Làm mới THẤT BẠI: ${failure.message}');
        emit(DashboardError(failure.message));
      },
      (summary) {
        debugPrint('[HOMESYNC DASHBOARD] Làm mới dữ liệu THÀNH CÔNG (${summary.totalAssetsCount} thiết bị).');
        emit(DashboardLoaded(summary));
      },
    );
  }
}
