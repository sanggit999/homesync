import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/features/service_logs/domain/entities/service_log_entity.dart';
export '../entities/service_log_entity.dart';

/// Abstract Repository Contract cho Service Logs & Thống kê tài chính dùng fpdart Either
abstract class ServiceLogRepository {
  Future<Either<Failure, List<ServiceLogEntity>>> getLogs({String? itemId, DateTime? fromDate, DateTime? toDate});
  Future<Either<Failure, ServiceLogEntity>> addLog(ServiceLogEntity log);
  Future<Either<Failure, Unit>> deleteLog(String id);
  Future<Either<Failure, double>> getTotalCost({DateTime? fromDate, DateTime? toDate});
}
