import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/services/calendar_service.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';

/// Thẻ công việc bảo trì chuẩn Apple Reminders & iOS Design System:
/// Tinh gọn, thoáng đãng, loại bỏ các nút cồng kềnh dưới chân.
/// - Nút tròn Checkmark 1-chạm để hoàn thành nhanh.
/// - Chạm vào thân thẻ mở Trang Chi Tiết (chứa đầy đủ bộ 3 hành động).
class MaintenanceTaskCard extends StatelessWidget {
  const MaintenanceTaskCard({
    super.key,
    required this.task,
    required this.onComplete,
    this.onReschedule,
    this.onCancel,
    this.onDelete,
  });

  final MaintenanceTaskEntity task;
  final VoidCallback onComplete;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat('#,###', 'vi_VN');

    // Phân loại trạng thái hạn chính xác
    final isOverdue = task.isOverdue;
    final isDueToday = task.isDueToday;
    final isDueSoon = task.isDueSoon;
    final remainingDays = task.remainingDays;

    // Màu sắc chủ đạo theo trạng thái
    final Color statusColor = isOverdue || isDueToday
        ? AppColors.error
        : (isDueSoon ? Colors.orange.shade700 : AppColors.primary);

    final Color statusBg = isOverdue || isDueToday
        ? AppColors.error.withValues(alpha: 0.12)
        : (isDueSoon ? Colors.orange.withValues(alpha: 0.12) : AppColors.primary.withValues(alpha: 0.1));

    // Chuỗi văn bản trạng thái
    final String statusText;
    final IconData statusIcon;
    if (isOverdue) {
      statusText = 'Quá hạn ${-remainingDays} ngày';
      statusIcon = LucideIcons.alertCircle;
    } else if (isDueToday) {
      statusText = 'Đến hạn hôm nay';
      statusIcon = LucideIcons.alertTriangle;
    } else if (isDueSoon) {
      statusText = 'Còn $remainingDays ngày';
      statusIcon = LucideIcons.clock;
    } else {
      statusText = 'Còn $remainingDays ngày';
      statusIcon = LucideIcons.calendarCheck2;
    }

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      onTap: () => context.push(AppRoutes.maintenanceDetailPath(task.id), extra: task),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── 1. HEADER: NÚT CHECKMARK 1-CHẠM + TIÊU ĐỀ + MENU ───
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nút tròn checkmark 1-chạm chuẩn Apple Reminders
              InkWell(
                onTap: onComplete,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.6),
                      width: 2,
                    ),
                    color: AppColors.success.withValues(alpha: 0.08),
                  ),
                  child: const Icon(
                    LucideIcons.check,
                    size: 18,
                    color: AppColors.success,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Tiêu đề & Thông tin thiết bị
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.box,
                          size: 13,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            task.itemName != null && task.itemName!.isNotEmpty
                                ? (task.itemLocation != null && task.itemLocation!.isNotEmpty
                                    ? '${task.itemName} • ${task.itemLocation}'
                                    : task.itemName!)
                                : 'Thiết bị gia đình',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Menu 3 chấm thao tác
              PopupMenuButton<String>(
                icon: Icon(
                  LucideIcons.moreVertical,
                  size: 20,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (action) {
                  if (action == 'detail') {
                    context.push(AppRoutes.maintenanceDetailPath(task.id), extra: task);
                  } else if (action == 'edit') {
                    context.push(AppRoutes.maintenanceEditPath(task.id), extra: task);
                  } else if (action == 'reschedule') {
                    onReschedule?.call();
                  } else if (action == 'cancel') {
                    onCancel?.call();
                  } else if (action == 'calendar') {
                    _addToCalendar(context);
                  } else if (action == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'detail',
                    child: Row(
                      children: [
                        Icon(LucideIcons.externalLink, size: 16, color: AppColors.primary),
                        SizedBox(width: 10),
                        Text('Xem chi tiết', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(LucideIcons.pencil, size: 16, color: AppColors.primary),
                        SizedBox(width: 10),
                        Text('Chỉnh sửa', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'reschedule',
                    child: Row(
                      children: [
                        Icon(LucideIcons.clock, size: 16, color: AppColors.primary),
                        SizedBox(width: 10),
                        Text('Tạm hoãn', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Row(
                      children: [
                        Icon(LucideIcons.calendarOff, size: 16, color: Colors.orange),
                        SizedBox(width: 10),
                        Text('Bỏ qua kỳ này', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'calendar',
                    child: Row(
                      children: [
                        Icon(LucideIcons.calendarPlus, size: 16, color: AppColors.primary),
                        SizedBox(width: 10),
                        Text('Thêm vào Lịch', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(LucideIcons.trash2, size: 16, color: AppColors.error),
                        SizedBox(width: 10),
                        Text('Xóa lịch này', style: TextStyle(fontSize: 13, color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ─── 2. KHỐI THÔNG TIN CHỈ SỐ & THỜI HẠN (APPLE INSET TILE) ───
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF26262A) : const Color(0xFFF6F8FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Dòng 1: Huy hiệu trạng thái + Dự toán chi phí
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status Badge rõ ràng
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 13, color: statusColor),
                          const SizedBox(width: 5),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Dự toán (nếu có)
                    if (task.estimatedCost != null && task.estimatedCost! > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.coins, size: 13, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            '${currencyFormat.format(task.estimatedCost)} ₫',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'Định kỳ ${task.frequencyMonths} tháng',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // Dòng 2: Ngày đến hạn cụ thể + Chu kỳ + Mũi tên xem chi tiết
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hạn đến: ${DateFormat('dd/MM/yyyy').format(task.dueDate)}',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : const Color(0xFF374151),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Chi tiết',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          LucideIcons.chevronRight,
                          size: 14,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCalendar(BuildContext context) async {
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
  }
}
