import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';

/// Bộ chuyển đổi tab kiểu Apple Pill Segmented Control có gắn Badge số lượng công việc
class MaintenanceSegmentedTabs extends StatelessWidget implements PreferredSizeWidget {
  const MaintenanceSegmentedTabs({
    super.key,
    required this.tabController,
    this.tasksBadgeCount = 0,
    this.logsCount = 0,
  });

  final TabController tabController;
  final int tasksBadgeCount;
  final int logsCount;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 46,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C30) : const Color(0xFFF0F1F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: isDark ? Colors.white : AppColors.textPrimary,
        unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        indicator: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E22) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.calendarClock, size: 16),
                const SizedBox(width: 8),
                const Text('Lịch Bảo Trì'),
                if (tasksBadgeCount > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$tasksBadgeCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.receipt, size: 16),
                const SizedBox(width: 8),
                const Text('Nhật Ký Chi Phí'),
                if (logsCount > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$logsCount',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
