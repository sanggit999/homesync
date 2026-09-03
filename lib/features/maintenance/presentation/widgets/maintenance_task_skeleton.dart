import 'package:flutter/material.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/core/widgets/shimmer_loading.dart';

/// Thẻ Skeleton mô phỏng cấu trúc của MaintenanceTaskCard khi đang tải danh sách
class MaintenanceTaskCardSkeleton extends StatelessWidget {
  const MaintenanceTaskCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Checkbox placeholder
              const SkeletonBox(width: 24, height: 24, borderRadius: 12),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // Task title
                    SkeletonBox(width: 160, height: 16, borderRadius: 4),
                    SizedBox(height: 6),
                    // Item name / Room
                    SkeletonBox(width: 110, height: 12, borderRadius: 4),
                  ],
                ),
              ),
              // Due date badge placeholder
              const SkeletonBox(width: 85, height: 24, borderRadius: 8),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: const [
              // Button 1 (Add to calendar)
              SkeletonBox(width: 100, height: 28, borderRadius: 8),
              Spacer(),
              // Button 2 (Call technician / Reschedule)
              SkeletonBox(width: 80, height: 28, borderRadius: 8),
            ],
          ),
        ],
      ),
    );
  }
}

/// Danh sách Shimmer Skeleton cuộn cho tab Lịch bảo trì định kỳ
class MaintenanceSkeletonView extends StatelessWidget {
  const MaintenanceSkeletonView({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: itemCount,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, _) => const MaintenanceTaskCardSkeleton(),
      ),
    );
  }
}
