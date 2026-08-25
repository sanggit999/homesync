import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/utils/warranty_calculator.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/core/widgets/status_badge.dart';
import 'package:home_sync/core/widgets/warranty_progress_bar.dart';
import 'package:home_sync/features/items/domain/entities/item_entity.dart';

/// Widget Thẻ hiển thị một thiết bị trong danh sách
class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final ItemEntity item;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.package, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.brand ?? 'Chưa rõ hãng'} • ${item.location ?? 'Chưa gắn phòng'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  item.isFavorite ? Icons.star : Icons.star_border,
                  color: item.isFavorite ? Colors.amber : Colors.grey,
                  size: 22,
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
          const SizedBox(height: 14),
          WarrantyProgressBar(
            progress: item.warrantyProgress,
            status: item.warrantyStatus,
            showLabels: true,
            remainingDaysText: item.remainingDays > 0
                ? 'Còn ${item.remainingDays} ngày'
                : 'Đã hết hạn',
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusBadge.fromWarrantyStatus(
                item.warrantyStatus,
                item.warrantyStatus == WarrantyStatus.good
                    ? 'Bảo hành an toàn'
                    : item.warrantyStatus == WarrantyStatus.expiringSoon
                        ? 'Sắp hết hạn'
                        : 'Hết hạn bảo hành',
              ),
              Text(
                'Hạn: ${DateFormat('dd/MM/yyyy').format(item.warrantyExpiryDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
