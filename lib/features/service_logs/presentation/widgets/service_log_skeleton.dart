import 'package:flutter/material.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/core/widgets/shimmer_loading.dart';

/// Thẻ Skeleton mô phỏng 1 bản ghi chi phí khi đang tải dữ liệu
class ServiceLogCardSkeleton extends StatelessWidget {
  const ServiceLogCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon placeholder
          const SkeletonBox(width: 42, height: 42, borderRadius: 12),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(width: 160, height: 16, borderRadius: 4),
                SizedBox(height: 6),
                SkeletonBox(width: 120, height: 12, borderRadius: 4),
                SizedBox(height: 8),
                SkeletonBox(width: 90, height: 12, borderRadius: 4),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Price placeholder
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              SkeletonBox(width: 80, height: 16, borderRadius: 4),
              SizedBox(height: 8),
              SkeletonBox(width: 50, height: 20, borderRadius: 6),
            ],
          ),
        ],
      ),
    );
  }
}

/// Danh sách Shimmer Skeleton cuộn cho Tab Nhật ký chi phí
class ServiceLogSkeletonView extends StatelessWidget {
  const ServiceLogSkeletonView({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Financial Summary Card Skeleton
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 70, height: 12, borderRadius: 4),
                      SizedBox(height: 8),
                      SkeletonBox(width: 100, height: 20, borderRadius: 4),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 80, height: 12, borderRadius: 4),
                      SizedBox(height: 8),
                      SkeletonBox(width: 110, height: 20, borderRadius: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips skeleton
          Row(
            children: const [
              SkeletonBox(width: 70, height: 32, borderRadius: 16),
              SizedBox(width: 8),
              SkeletonBox(width: 90, height: 32, borderRadius: 16),
              SizedBox(width: 8),
              SkeletonBox(width: 100, height: 32, borderRadius: 16),
            ],
          ),
          const SizedBox(height: 16),
          // List of card skeletons
          ...List.generate(itemCount, (_) => const ServiceLogCardSkeleton()),
        ],
      ),
    );
  }
}
