import 'package:flutter/material.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/utils/warranty_calculator.dart';

/// Huy hiệu trạng thái nhỏ gọn, thẩm mỹ cao
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  factory StatusBadge.fromWarrantyStatus(WarrantyStatus status, String label) {
    final color = switch (status) {
      WarrantyStatus.good => AppColors.success,
      WarrantyStatus.expiringSoon => AppColors.warning,
      WarrantyStatus.expired => AppColors.error,
    };
    return StatusBadge(label: label, color: color);
  }

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
