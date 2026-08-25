import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:home_sync/features/service_logs/domain/repositories/service_log_repository.dart';

/// Params cho GetServiceLogsUseCase
class GetServiceLogsParams {
  const GetServiceLogsParams({this.itemId, this.fromDate, this.toDate});
  final String? itemId;
  final DateTime? fromDate;
  final DateTime? toDate;
}

/// Use Case: Lấy danh sách lịch sử sửa chữa & bảo dưỡng
class GetServiceLogsUseCase implements UseCase<List<ServiceLogEntity>, GetServiceLogsParams> {
  const GetServiceLogsUseCase(this._repository);
  final ServiceLogRepository _repository;

  @override
  Future<Either<Failure, List<ServiceLogEntity>>> call([GetServiceLogsParams params = const GetServiceLogsParams()]) {
    return _repository.getLogs(
      itemId: params.itemId,
      fromDate: params.fromDate,
      toDate: params.toDate,
    );
  }
}

/// Use Case: Ghi nhận sửa chữa / sự cố mới
class AddServiceLogUseCase implements UseCase<ServiceLogEntity, ServiceLogEntity> {
  const AddServiceLogUseCase(this._repository);
  final ServiceLogRepository _repository;

  @override
  Future<Either<Failure, ServiceLogEntity>> call(ServiceLogEntity log) {
    return _repository.addLog(log);
  }
}

/// Use Case: Xóa nhật ký sửa chữa
class DeleteServiceLogUseCase implements UseCase<Unit, String> {
  const DeleteServiceLogUseCase(this._repository);
  final ServiceLogRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return _repository.deleteLog(id);
  }
}

/// Params cho GetTotalCostUseCase
class GetTotalCostParams {
  const GetTotalCostParams({this.fromDate, this.toDate});
  final DateTime? fromDate;
  final DateTime? toDate;
}

/// Use Case: Thống kê tổng chi phí bảo trì & sửa chữa theo mốc thời gian
class GetTotalCostUseCase implements UseCase<double, GetTotalCostParams> {
  const GetTotalCostUseCase(this._repository);
  final ServiceLogRepository _repository;

  @override
  Future<Either<Failure, double>> call([GetTotalCostParams params = const GetTotalCostParams()]) {
    return _repository.getTotalCost(fromDate: params.fromDate, toDate: params.toDate);
  }
}
