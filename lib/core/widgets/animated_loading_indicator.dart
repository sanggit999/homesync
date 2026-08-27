import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';

/// Widget Hiển Thị Trạng Thái Đang Tải Dữ Liệu kèm Icon Hộp Thiết Bị Thở Nhẹ (Pulse Icon Animation)
class AnimatedLoadingIndicator extends StatefulWidget {
  const AnimatedLoadingIndicator({
    super.key,
    this.message = 'Đang tải dữ liệu...',
    this.icon,
  });

  final String message;
  final IconData? icon;

  @override
  State<AnimatedLoadingIndicator> createState() => _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textColor = isDark ? Colors.grey.shade300 : Colors.grey.shade700;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Icon Hộp Thiết Bị với hiệu ứng Thở Nhẹ (Pulse Scale Animation)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scale = 1.0 + 0.08 * math.sin(_controller.value * 2 * math.pi);
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Icon(
                widget.icon ?? LucideIcons.packageSearch,
                size: 32,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Dòng thông điệp tĩnh thanh lịch
          Text(
            widget.message,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
