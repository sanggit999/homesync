import 'package:flutter/material.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/utils/warranty_calculator.dart';

/// Thanh tiến độ thời gian bảo hành chuyển màu thông minh theo trạng thái
class WarrantyProgressBar extends StatelessWidget {
  const WarrantyProgressBar({
    super.key,
    required this.progress,
    required this.status,
    this.height = 6,
    this.showLabels = false,
    this.remainingDaysText,
  });

  final double progress;
  final WarrantyStatus status;
  final double height;
  final bool showLabels;
  final String? remainingDaysText;

  Color get _statusColor => switch (status) {
        WarrantyStatus.good => AppColors.success,
        WarrantyStatus.expiringSoon => AppColors.warning,
        WarrantyStatus.expired => AppColors.error,
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark ? AppColors.darkBorder : AppColors.border.withValues(alpha: 0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabels && remainingDaysText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thời hạn bảo hành',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        fontSize: 12,
                      ),
                ),
                Text(
                  remainingDaysText!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Container(
            height: height,
            width: double.infinity,
            color: trackColor,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: _statusColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
