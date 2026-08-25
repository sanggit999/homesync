import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart';

/// Widget Thẻ Radar Sức Khỏe Thiết Bị & Tổng giá trị tài sản
class HealthRadarCard extends StatelessWidget {
  const HealthRadarCard({super.key, required this.summary});

  final DashboardSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Radar Sức Khỏe Thiết Bị',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${summary.totalAssetsCount} thiết bị',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMetricItem(
                context,
                label: 'Còn tốt',
                count: summary.goodCount,
                color: AppColors.success,
                icon: LucideIcons.shieldCheck,
              ),
              _buildMetricItem(
                context,
                label: 'Sắp hết hạn',
                count: summary.warningCount,
                color: AppColors.warning,
                icon: LucideIcons.alertCircle,
              ),
              _buildMetricItem(
                context,
                label: 'Đã hết hạn',
                count: summary.expiredCount,
                color: AppColors.error,
                icon: LucideIcons.alertOctagon,
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng giá trị tài sản',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              Text(
                currencyFormatter.format(summary.totalAssetValue),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
