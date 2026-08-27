import 'package:home_sync/features/items/domain/entities/item_entity.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';

/// Entity tóm tắt dữ liệu Dashboard trang chủ (Health Radar, Cảnh báo, Chi tiêu)
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
