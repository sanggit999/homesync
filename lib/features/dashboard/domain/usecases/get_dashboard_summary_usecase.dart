import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:home_sync/features/items/domain/repositories/item_repository.dart';
import 'package:home_sync/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:home_sync/features/service_logs/domain/repositories/service_log_repository.dart';

/// Entity tóm tắt dữ liệu Dashboard trang chủ
class DashboardSummaryEntity {
  const DashboardSummaryEntity({
    required this.totalAssetsCount,
    required this.totalAssetValue,
    required this.goodCount,
    required this.warningCount,
    required this.expiredCount,
    required this.expiringSoonItems,
    required this.upcomingTasks,
    required this.totalSpentThisMonth,
  });

  final int totalAssetsCount;
  final double totalAssetValue;
  final int goodCount;
  final int warningCount;
  final int expiredCount;
  final List<ItemEntity> expiringSoonItems;
  final List<MaintenanceTaskEntity> upcomingTasks;
  final double totalSpentThisMonth;
}

/// Use Case: Lấy tổng hợp dữ liệu trang chủ (Health Radar, Cảnh báo, Chi tiêu)
class GetDashboardSummaryUseCase implements UseCase<DashboardSummaryEntity, NoParams> {
  const GetDashboardSummaryUseCase({
    required this.itemRepository,
    required this.maintenanceRepository,
    required this.serviceLogRepository,
  });

  final ItemRepository itemRepository;
  final MaintenanceRepository maintenanceRepository;
  final ServiceLogRepository serviceLogRepository;

  @override
  Future<Either<Failure, DashboardSummaryEntity>> call([NoParams params = const NoParams()]) async {
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

    // Kiểm tra lỗi nếu có
    if (itemsEither.isLeft()) return Left(itemsEither.getLeft().toNullable()!);
    if (tasksEither.isLeft()) return Left(tasksEither.getLeft().toNullable()!);
    if (costEither.isLeft()) return Left(costEither.getLeft().toNullable()!);

    final items = itemsEither.getOrElse((_) => []);
    final tasks = tasksEither.getOrElse((_) => []);
    final totalSpentThisMonth = costEither.getOrElse((_) => 0.0);

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
