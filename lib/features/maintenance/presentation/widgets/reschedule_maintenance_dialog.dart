import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/utils/snackbar_utils.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';
import 'package:home_sync/features/maintenance/presentation/cubit/maintenance_cubit.dart';

/// Modal BottomSheet Dời Lịch Bảo Trì (Chuẩn Apple iOS Bottom Sheet)
class RescheduleMaintenanceDialog extends StatefulWidget {
  const RescheduleMaintenanceDialog({
    super.key,
    required this.task,
  });

  final MaintenanceTaskEntity task;

  /// Hiển thị dạng Modal BottomSheet vuốt từ cạnh dưới lên
  static Future<void> show(BuildContext context, MaintenanceTaskEntity task) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RescheduleMaintenanceDialog(task: task),
    );
  }

  @override
  State<RescheduleMaintenanceDialog> createState() => _RescheduleMaintenanceDialogState();
}

class _RescheduleMaintenanceDialogState extends State<RescheduleMaintenanceDialog> {
  late DateTime _selectedDueDate;
  int? _selectedDaysOffset;
  final _reasonController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _reasonPresets = [
    'Bận việc gia đình',
    'Chờ đặt mua linh kiện',
    'Chưa liên hệ được thợ',
    'Thiết bị vẫn dùng tốt',
  ];

  @override
  void initState() {
    super.initState();
    // Mặc định lùi 7 ngày
    _selectedDaysOffset = 7;
    final now = DateTime.now();
    final baseDate = widget.task.dueDate.isAfter(now) ? widget.task.dueDate : now;
    _selectedDueDate = baseDate.add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _chooseOffset(int days) {
    setState(() {
      _selectedDaysOffset = days;
      final now = DateTime.now();
      final baseDate = widget.task.dueDate.isAfter(now) ? widget.task.dueDate : now;
      _selectedDueDate = baseDate.add(Duration(days: days));
    });
  }

  Future<void> _pickCustomDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
      helpText: 'CHỌN NGÀY HẸN MỚI',
      cancelText: 'HỦY',
      confirmText: 'CHỌN',
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDueDate = picked;
        _selectedDaysOffset = null; // Chọn ngày tùy biến
      });
    }
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);

    final params = RescheduleTaskParams(
      taskId: widget.task.id,
      newDueDate: _selectedDueDate,
      reason: _reasonController.text.trim().isEmpty ? null : _reasonController.text.trim(),
    );

    await context.read<MaintenanceCubit>().rescheduleTask(params);

    if (mounted) {
      Navigator.of(context).pop();
      AppSnackBar.showSuccess(
        context,
        'Đã dời lịch bảo trì sang ngày ${DateFormat('dd/MM/yyyy').format(_selectedDueDate)}! 🗓️',
      );
    }
  }

  String _formatDateWithWeekday(DateTime date) {
    const weekdays = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];
    final weekday = weekdays[date.weekday - 1];
    return '$weekday, ${DateFormat('dd/MM/yyyy').format(date)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final now = DateTime.now();
    final baseDate = widget.task.dueDate.isAfter(now) ? widget.task.dueDate : now;

    return Material(
      color: isDark ? const Color(0xFF1E1E22) : Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Thanh kéo chuẩn iOS
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // 2. Tiêu đề & Tên task
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dời Hạn Bảo Trì',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.task.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        if (widget.task.itemName != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Thiết bị: ${widget.task.itemName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Thẻ hiển thị hạn hiện tại
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF26262A) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Hạn hiện tại: ${DateFormat('dd/MM/yyyy').format(widget.task.dueDate)}',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 3. Chọn nhanh thời gian lùi lịch (+7 ngày, +14 ngày, +1 tháng)
              const Text(
                'Chọn nhanh thời gian dời:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildQuickCard(
                    title: '+7 ngày',
                    subtitle: DateFormat('dd/MM').format(baseDate.add(const Duration(days: 7))),
                    isSelected: _selectedDaysOffset == 7,
                    onTap: () => _chooseOffset(7),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildQuickCard(
                    title: '+14 ngày',
                    subtitle: DateFormat('dd/MM').format(baseDate.add(const Duration(days: 14))),
                    isSelected: _selectedDaysOffset == 14,
                    onTap: () => _chooseOffset(14),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildQuickCard(
                    title: '+1 tháng',
                    subtitle: DateFormat('dd/MM').format(baseDate.add(const Duration(days: 30))),
                    isSelected: _selectedDaysOffset == 30,
                    onTap: () => _chooseOffset(30),
                    isDark: isDark,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 4. Khung tùy chọn ngày cụ thể
              InkWell(
                onTap: _pickCustomDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedDaysOffset == null
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : (isDark ? const Color(0xFF26262A) : const Color(0xFFF8FAFC)),
                    border: Border.all(
                      color: _selectedDaysOffset == null
                          ? AppColors.primary
                          : (isDark ? Colors.white10 : const Color(0xFFE5E7EB)),
                      width: _selectedDaysOffset == null ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ngày hẹn mới được chọn',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDateWithWeekday(_selectedDueDate),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Đổi ngày',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 5. Lý do dời lịch
              const Text(
                'Lý do dời lịch (tùy chọn):',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _reasonPresets.map((reason) {
                  final isSelected = _reasonController.text == reason;
                  return ChoiceChip(
                    label: Text(reason, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _reasonController.text = selected ? reason : '';
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Nhập lý do khác...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF26262A) : const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // 6. Nút xác nhận toàn chiều rộng (KHÔNG TIỀN TỐ ICON)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Hủy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Xác nhận dời lịch',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : (isDark ? const Color(0xFF26262A) : const Color(0xFFF9FAFB)),
            border: Border.all(
              color: isSelected ? AppColors.primary : (isDark ? Colors.white10 : const Color(0xFFE5E7EB)),
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primary : (isDark ? Colors.white : Colors.black87),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
