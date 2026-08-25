import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/core/widgets/empty_state_widget.dart';
import 'package:home_sync/core/widgets/status_badge.dart';
import 'package:home_sync/core/widgets/warranty_progress_bar.dart';
import 'package:home_sync/features/items/domain/entities/item_entity.dart';

/// Widget Thẻ Cuộn Ngang Danh Sách Thiết Bị Sắp Hết Hạn Bảo Hành
class ExpiringSoonCarousel extends StatelessWidget {
  const ExpiringSoonCarousel({super.key, required this.items});

  final List<ItemEntity> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: EmptyStateWidget(
          icon: LucideIcons.checkCircle2,
          title: 'Tất cả thiết bị đều an toàn',
          subtitle: 'Không có thiết bị nào sắp hết hạn bảo hành trong 30 ngày tới.',
        ),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 260,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: AppCard(
              onTap: () => context.push(AppRoutes.itemDetailPath(item.id)),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      StatusBadge.fromWarrantyStatus(
                        item.warrantyStatus,
                        '${item.remainingDays} ngày',
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.brand ?? item.location ?? 'Chưa gắn phòng',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  WarrantyProgressBar(
                    progress: item.warrantyProgress,
                    status: item.warrantyStatus,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Hết hạn: ${DateFormat('dd/MM/yyyy').format(item.warrantyExpiryDate)}',
                    style: const TextStyle(fontSize: 11, color: AppColors.warning),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
