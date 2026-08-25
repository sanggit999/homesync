import '../../domain/entities/service_log_entity.dart';

/// Dart 3 Sealed Class cho ServiceLog State
sealed class ServiceLogState {
  const ServiceLogState();
}

final class ServiceLogInitial extends ServiceLogState {
  const ServiceLogInitial();
}

final class ServiceLogLoading extends ServiceLogState {
  const ServiceLogLoading();
}

final class ServiceLogLoaded extends ServiceLogState {
  const ServiceLogLoaded({
    required this.logs,
    required this.totalCostThisMonth,
    required this.totalCostAllTime,
  });

  final List<ServiceLogEntity> logs;
  final double totalCostThisMonth;
  final double totalCostAllTime;
}

final class ServiceLogError extends ServiceLogState {
  const ServiceLogError(this.message);
  final String message;
}
