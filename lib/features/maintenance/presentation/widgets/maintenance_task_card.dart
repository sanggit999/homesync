import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:home_sync/core/services/calendar_service.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';

/// Widget Thẻ hiển thị một nhiệm vụ bảo dưỡng định kỳ
class MaintenanceTaskCard extends StatelessWidget {
  const MaintenanceTaskCard({
    super.key,
    required this.task,
    required this.onComplete,
  });

  final MaintenanceTaskEntity task;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOverdue = task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: task.isCompleted ? AppColors.success : AppColors.primary,
                  size: 26,
                ),
                onPressed: onComplete,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Text(
                      task.itemName ?? 'Bảo trì gia đình',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOverdue
                      ? AppColors.error.withValues(alpha: 0.12)
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  DateFormat('dd/MM/yyyy').format(task.dueDate),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isOverdue ? AppColors.error : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final success = await CalendarService.addMaintenanceEvent(
                    title: task.title,
                    description: 'Bảo trì thiết bị: ${task.itemName ?? ''}',
                    dueDate: task.dueDate,
                  );
                  if (context.mounted && success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã thêm sự kiện vào Lịch điện thoại! 📅'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                icon: const Icon(LucideIcons.calendarPlus, size: 14),
                label: const Text('Thêm vào Lịch', style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                ),
              ),
              const Spacer(),
              if (task.technicianPhone != null && task.technicianPhone!.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () => launchUrl(Uri.parse('tel:${task.technicianPhone}')),
                  icon: const Icon(LucideIcons.phone, size: 14),
                  label: const Text('Gọi thợ', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
