import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/services/calendar_service.dart';
import 'package:home_sync/core/utils/snackbar_utils.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';
import 'package:home_sync/features/maintenance/presentation/cubit/maintenance_cubit.dart';
import 'package:home_sync/features/maintenance/presentation/widgets/cancel_maintenance_dialog.dart';
import 'package:home_sync/features/maintenance/presentation/widgets/complete_maintenance_bottom_sheet.dart';
import 'package:home_sync/features/maintenance/presentation/widgets/reschedule_maintenance_dialog.dart';
import 'package:home_sync/features/service_logs/presentation/cubit/service_log_cubit.dart';
import 'package:home_sync/features/service_logs/presentation/widgets/service_log_card.dart';

/// Trang Chi Tiết Lịch Bảo Trì (Chuẩn Apple Design System)
class MaintenanceDetailPage extends StatelessWidget {
  const MaintenanceDetailPage({
    super.key,
    required this.taskId,
    this.initialTask,
  });

  final String taskId;
  final MaintenanceTaskEntity? initialTask;

  void _confirmDelete(BuildContext context, String taskTitle) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(LucideIcons.alertTriangle, color: AppColors.error, size: 22),
            SizedBox(width: 8),
            Text('Xóa Lịch Bảo Trì', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Bạn có chắc chắn muốn xóa lịch bảo trì "$taskTitle"?\n\nLịch sử các lần đã hoàn thành trước đây vẫn được bảo toàn nguyên vẹn.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MaintenanceCubit>().deleteTask(taskId);
              Navigator.pop(dialogCtx); // Đóng dialog
              context.pop(); // Đóng trang detail
              AppSnackBar.showSuccess(context, 'Đã xóa lịch bảo trì thành công.');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Xóa ngay'),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCalendar(BuildContext context, MaintenanceTaskEntity task) async {
    final success = await CalendarService.addMaintenanceEvent(
      title: task.title,
      description: 'Bảo trì thiết bị: ${task.itemName ?? ''}',
      dueDate: task.dueDate,
    );
    if (context.mounted && success) {
      AppSnackBar.showSuccess(context, 'Đã thêm sự kiện vào Lịch điện thoại! 📅');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

    return BlocBuilder<MaintenanceCubit, MaintenanceState>(
      builder: (context, state) {
        // Tìm task mới nhất trong state, nếu không có thì dùng initialTask
        MaintenanceTaskEntity? task;
        if (state is MaintenanceLoaded) {
          task = state.tasks.where((t) => t.id == taskId).firstOrNull;
        }
        task ??= initialTask;

        if (task == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chi Tiết Lịch Bảo Trì')),
            body: const Center(child: Text('Không tìm thấy thông tin lịch bảo trì.')),
          );
        }

        final now = DateTime.now();
        final isOverdue = task.dueDate.isBefore(now) && !task.isCompleted;
        final daysRemaining = task.dueDate.difference(now).inDays;
        final isDueSoon = daysRemaining <= 30 && daysRemaining >= 0 && !task.isCompleted;

        // Trích xuất lịch sử các lần hoàn thành / bỏ qua của riêng task này
        final serviceLogState = context.watch<ServiceLogCubit>().state;
        final taskLogs = serviceLogState is ServiceLogLoaded
            ? serviceLogState.logs.where((l) => l.taskId == task!.id).toList()
            : [];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Chi Tiết Lịch Bảo Trì', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(LucideIcons.moreVertical),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (action) {
                  if (action == 'edit') {
                    context.push(AppRoutes.maintenanceEditPath(task!.id), extra: task);
                  } else if (action == 'calendar') {
                    _addToCalendar(context, task!);
                  } else if (action == 'delete') {
                    _confirmDelete(context, task!.title);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(LucideIcons.pencil, color: AppColors.primary, size: 16),
                        SizedBox(width: 10),
                        Text('Chỉnh sửa'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'calendar',
                    child: Row(
                      children: [
                        Icon(LucideIcons.calendarPlus, color: AppColors.primary, size: 16),
                        SizedBox(width: 10),
                        Text('Thêm vào Lịch'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(LucideIcons.trash2, color: AppColors.error, size: 16),
                        SizedBox(width: 10),
                        Text('Xóa lịch này', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: _buildStickyBottomBar(context, task, isDark),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Card: Tên việc, tình trạng & Thiết bị liên quan
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isOverdue
                                  ? AppColors.error.withValues(alpha: 0.12)
                                  : (isDueSoon
                                      ? Colors.orange.withValues(alpha: 0.12)
                                      : AppColors.primary.withValues(alpha: 0.12)),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              LucideIcons.wrench,
                              size: 24,
                              color: isOverdue
                                  ? AppColors.error
                                  : (isDueSoon ? Colors.orange : AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isOverdue
                                        ? AppColors.error.withValues(alpha: 0.1)
                                        : (isDueSoon
                                            ? Colors.orange.withValues(alpha: 0.1)
                                            : AppColors.success.withValues(alpha: 0.1)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isOverdue
                                        ? '🔴 Đã quá hạn ${-daysRemaining} ngày'
                                        : (isDueSoon
                                            ? '🟡 Sắp đến hạn (Còn $daysRemaining ngày)'
                                            : '🟢 Còn $daysRemaining ngày'),
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: isOverdue
                                          ? AppColors.error
                                          : (isDueSoon ? Colors.orange : AppColors.success),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      // Thiết bị liên quan
                      InkWell(
                        onTap: () => context.push(AppRoutes.itemDetailPath(task!.itemId)),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF26262A) : const Color(0xFFF6F7FB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.box, size: 18, color: AppColors.primary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Thiết bị thực hiện', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                    Text(
                                      task.itemName ?? 'Thiết bị gia đình',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 2. Schedule Card: Chu kỳ & Mốc thời gian
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.calendarClock, size: 18, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text('Lịch Trình & Chu Kỳ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildDetailRow('Chu kỳ lặp lại', 'Mỗi ${task.frequencyMonths} tháng một lần'),
                      const Divider(height: 16),
                      _buildDetailRow(
                        'Ngày hẹn kế tiếp',
                        DateFormat('dd/MM/yyyy').format(task.dueDate),
                        highlight: isOverdue,
                      ),
                      const Divider(height: 16),
                      _buildDetailRow(
                        'Lần hoàn thành gần nhất',
                        task.lastCompletedAt != null
                            ? DateFormat('dd/MM/yyyy').format(task.lastCompletedAt!)
                            : 'Chưa từng thực hiện',
                      ),
                      const Divider(height: 16),
                      _buildDetailRow('Mức độ ưu tiên', task.priority == 'high' ? 'Cao' : (task.priority == 'low' ? 'Thấp' : 'Trung bình')),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 3. Finance Card: Chi phí dự toán & Thực tế
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.coins, size: 18, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text('Dự Toán & Ngân Sách', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildDetailRow(
                        'Chi phí dự kiến',
                        task.estimatedCost != null && task.estimatedCost! > 0
                            ? currencyFormatter.format(task.estimatedCost)
                            : 'Chưa có dự toán',
                      ),
                      if (task.cost != null && task.cost! > 0) ...[
                        const Divider(height: 16),
                        _buildDetailRow(
                          'Chi phí lần gần nhất',
                          currencyFormatter.format(task.cost),
                          isBold: true,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 4. Technician Card: Thợ & Đơn vị dịch vụ
                if (task.technicianName != null || task.technicianPhone != null) ...[
                  AppCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(LucideIcons.userCheck, size: 18, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text('Thợ & Đơn Vị Bảo Dưỡng', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildDetailRow('Tên thợ / Trạm', task.technicianName ?? 'Thợ sửa chữa gia đình'),
                        if (task.technicianPhone != null && task.technicianPhone!.isNotEmpty) ...[
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Số điện thoại liên hệ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  const SizedBox(height: 2),
                                  Text(task.technicianPhone!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () => launchUrl(Uri.parse('tel:${task!.technicianPhone}')),
                                icon: const Icon(LucideIcons.phone, size: 14),
                                label: const Text('Gọi ngay', style: TextStyle(fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // 5. Notes Card: Ghi chú & Hướng dẫn kỹ thuật
                if (task.notes != null && task.notes!.isNotEmpty) ...[
                  AppCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(LucideIcons.fileText, size: 18, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text('Ghi Chú & Hướng Dẫn', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          task.notes!,
                          style: const TextStyle(fontSize: 13, height: 1.45),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // 6. History Card: Lịch sử bảo dưỡng của riêng công việc này (Point-in-Time Audit)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.history, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      const Text('Lịch Sử Các Lần Bảo Dưỡng Trước', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text('${taskLogs.length} lần', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                if (taskLogs.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF222226) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                    ),
                    child: const Center(
                      child: Text(
                        'Chưa có lịch sử bảo dưỡng nào cho công việc này.\nKhi bạn bấm hoàn thành, hệ thống sẽ tự động lưu vết tại đây.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ),
                  )
                else
                  ...taskLogs.map((log) => ServiceLogCard(log: log)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool highlight = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold || highlight ? FontWeight.bold : FontWeight.w600,
            color: highlight ? AppColors.error : null,
          ),
        ),
      ],
    );
  }

  Widget _buildStickyBottomBar(BuildContext context, MaintenanceTaskEntity task, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E22) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Tạm hoãn
          Expanded(
            child: OutlinedButton(
              onPressed: () => RescheduleMaintenanceDialog.show(context, task),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: AppColors.primary.withValues(alpha: 0.06),
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.35)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Tạm hoãn', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ),
          ),
          const SizedBox(width: 8),

          // 2. Hủy kỳ này (Bỏ qua)
          Expanded(
            child: OutlinedButton(
              onPressed: () => CancelMaintenanceDialog.show(context, task),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.orange.withValues(alpha: 0.06),
                side: BorderSide(color: Colors.orange.withValues(alpha: 0.35)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Bỏ qua', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.orange)),
            ),
          ),
          const SizedBox(width: 8),

          // 3. Hoàn thành
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () => CompleteMaintenanceBottomSheet.show(context, task),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Hoàn thành', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
