import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/features/dashboard/domain/entities/dashboard_summary_entity.dart';
import 'package:home_sync/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:home_sync/features/items/domain/repositories/item_repository.dart';
import 'package:home_sync/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:home_sync/features/service_logs/domain/repositories/service_log_repository.dart';

/// Implementation của DashboardRepository tổng hợp dữ liệu từ các sub-repositories
class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({
    required this.itemRepository,
    required this.maintenanceRepository,
    required this.serviceLogRepository,
  });

  final ItemRepository itemRepository;
  final MaintenanceRepository maintenanceRepository;
  final ServiceLogRepository serviceLogRepository;

  @override
  Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    // Chạy song song 3 truy vấn
    final results = await Future.wait([
      itemRepository.getItems(),
      maintenanceRepository.getTasks(isCompleted: false),
      serviceLogRepository.getTotalCost(fromDate: startOfMonth),
    ]);

    final itemsEither = results[0] as Either<Failure, List<ItemEntity>>;
    final tasksEither = results[1] as Either<Failure, List<MaintenanceTaskEntity>>;
    final costEither = results[2] as Either<Failure, double>;

    // 1. Bảng `items` là bắt buộc cho Radar và Danh sách thiết bị
    if (itemsEither.isLeft()) {
      final failure = itemsEither.getLeft().toNullable()!;
      debugPrint('[HOMESYNC DASHBOARD REPO] ❌ Lỗi bảng `items`: ${failure.message}');
      return Left(failure);
    }

    // 2. Bảng `maintenance_tasks`: Fallback danh sách rỗng nếu có sự cố
    final List<MaintenanceTaskEntity> tasks;
    if (tasksEither.isLeft()) {
      final failure = tasksEither.getLeft().toNullable()!;
      debugPrint('[HOMESYNC DASHBOARD REPO] ⚠️ Cảnh báo bảng `maintenance_tasks` (${failure.message}) -> Tạm thời hiển thị rỗng.');
      tasks = [];
    } else {
      tasks = tasksEither.getOrElse((_) => []);
    }

    // 3. Bảng `service_logs`: Fallback 0 VNĐ nếu có sự cố
    final double totalSpentThisMonth;
    if (costEither.isLeft()) {
      final failure = costEither.getLeft().toNullable()!;
      debugPrint('[HOMESYNC DASHBOARD REPO] ⚠️ Cảnh báo bảng `service_logs` (${failure.message}) -> Tạm thời hiển thị 0 VNĐ.');
      totalSpentThisMonth = 0.0;
    } else {
      totalSpentThisMonth = costEither.getOrElse((_) => 0.0);
    }

    final items = itemsEither.getOrElse((_) => []);

    int goodCount = 0;
    int warningCount = 0;
    int expiredCount = 0;
    double totalValue = 0.0;
    final List<ItemEntity> expiringSoon = [];

    for (final item in items) {
      if (item.price != null) totalValue += item.price!;
      if (item.isExpired) {
        expiredCount++;
      } else if (item.isWarning) {
        warningCount++;
        expiringSoon.add(item);
      } else {
        goodCount++;
      }
    }

    return Right(DashboardSummaryEntity(
      totalAssetsCount: items.length,
      totalAssetValue: totalValue,
      goodCount: goodCount,
      warningCount: warningCount,
      expiredCount: expiredCount,
      expiringSoonItems: expiringSoon,
      upcomingTasks: tasks.take(5).toList(),
      totalSpentThisMonth: totalSpentThisMonth,
    ));
  }
}
