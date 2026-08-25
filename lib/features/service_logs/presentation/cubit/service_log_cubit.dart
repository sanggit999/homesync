import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/service_log_entity.dart';
import '../../domain/usecases/service_log_usecases.dart';
import 'service_log_state.dart';

export 'service_log_state.dart';

/// Cubit quản lý lịch sử sửa chữa, chi phí phát sinh và thống kê tài chính
class ServiceLogCubit extends Cubit<ServiceLogState> {
  ServiceLogCubit({
    required this.getServiceLogsUseCase,
    required this.addServiceLogUseCase,
    required this.deleteServiceLogUseCase,
    required this.getTotalCostUseCase,
  }) : super(const ServiceLogInitial());

  final GetServiceLogsUseCase getServiceLogsUseCase;
  final AddServiceLogUseCase addServiceLogUseCase;
  final DeleteServiceLogUseCase deleteServiceLogUseCase;
  final GetTotalCostUseCase getTotalCostUseCase;

  /// Tải toàn bộ lịch sử sửa chữa và tính toán tổng chi tiêu
  Future<void> loadLogs({String? itemId, DateTime? fromDate, DateTime? toDate}) async {
    emit(const ServiceLogLoading());
    final logsResult = await getServiceLogsUseCase(GetServiceLogsParams(itemId: itemId, fromDate: fromDate, toDate: toDate));
    
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final monthCostResult = await getTotalCostUseCase(GetTotalCostParams(fromDate: startOfMonth));
    final allTimeCostResult = await getTotalCostUseCase(const GetTotalCostParams());

    logsResult.fold(
      (failure) => emit(ServiceLogError(failure.message)),
      (logs) {
        final monthCost = monthCostResult.getOrElse((_) => 0.0);
        final allTimeCost = allTimeCostResult.getOrElse((_) => 0.0);
        emit(ServiceLogLoaded(
          logs: logs,
          totalCostThisMonth: monthCost,
          totalCostAllTime: allTimeCost,
        ));
      },
    );
  }

  /// Thêm bản ghi sửa chữa / chi phí phát sinh mới
  Future<void> addLog(ServiceLogEntity log) async {
    final result = await addServiceLogUseCase(log);
    result.fold(
      (failure) => emit(ServiceLogError(failure.message)),
      (_) => loadLogs(itemId: log.itemId),
    );
  }

  /// Xóa bản ghi lịch sử sửa chữa
  Future<void> deleteLog(String id, {String? itemId}) async {
    final result = await deleteServiceLogUseCase(id);
    result.fold(
      (failure) => emit(ServiceLogError(failure.message)),
      (_) => loadLogs(itemId: itemId),
    );
  }
}
