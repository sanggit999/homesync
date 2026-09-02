import 'package:flutter/material.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/core/widgets/shimmer_loading.dart';

/// Thẻ Skeleton mô phỏng chính xác cấu trúc của ItemCard khi đang tải danh sách thiết bị
class ItemCardSkeleton extends StatelessWidget {
  const ItemCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Icon / Avatar box skeleton
              const SkeletonBox(width: 46, height: 46, borderRadius: 12),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // 2. Title skeleton
                    SkeletonBox(width: 150, height: 16, borderRadius: 4),
                    SizedBox(height: 8),
                    // 3. Subtitle / Brand skeleton
                    SkeletonBox(width: 100, height: 12, borderRadius: 4),
                  ],
                ),
              ),
              // 4. Favorite star placeholder
              const SkeletonBox(width: 22, height: 22, borderRadius: 11),
            ],
          ),
          const SizedBox(height: 16),

          // 5. Warranty progress bar skeleton
          const SkeletonBox(width: double.infinity, height: 8, borderRadius: 4),
          const SizedBox(height: 12),

          // 6. Status badge & Expiry date row skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SkeletonBox(width: 90, height: 22, borderRadius: 6),
              SkeletonBox(width: 75, height: 14, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}

/// Danh sách 4 thẻ Skeleton cuộn mượt mà có hiệu ứng Shimmer toàn cục
class ItemListSkeletonView extends StatelessWidget {
  const ItemListSkeletonView({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
        itemCount: itemCount,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, _) => const ItemCardSkeleton(),
      ),
    );
  }
}
