import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/utils/snackbar_utils.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';
import 'package:home_sync/features/maintenance/presentation/cubit/maintenance_cubit.dart';
import 'package:home_sync/features/service_logs/presentation/cubit/service_log_cubit.dart';

/// Modal BottomSheet Bỏ Qua Kỳ Này (Chuẩn Apple iOS Bottom Sheet)
class CancelMaintenanceDialog extends StatefulWidget {
  const CancelMaintenanceDialog({super.key, required this.task});

  final MaintenanceTaskEntity task;

  /// Hiển thị dạng Modal BottomSheet vuốt từ cạnh dưới lên
  static Future<void> show(BuildContext context, MaintenanceTaskEntity task) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CancelMaintenanceDialog(task: task),
    );
  }

  @override
  State<CancelMaintenanceDialog> createState() => _CancelMaintenanceDialogState();
}

class _CancelMaintenanceDialogState extends State<CancelMaintenanceDialog> {
  final _reasonController = TextEditingController();
  String _selectedPreset = 'Mùa này ít sử dụng';
  bool _isSubmitting = false;

  final List<String> _presets = [
    'Mùa này ít sử dụng',
    'Thợ kiểm tra máy còn tốt',
    'Tự kiểm tra hoạt động bình thường',
    'Bận việc / Vắng nhà',
  ];

  @override
  void initState() {
    super.initState();
    _reasonController.text = _selectedPreset;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    final reason = _reasonController.text.trim();

    await context.read<MaintenanceCubit>().cancelTask(
      CancelTaskParams(
        taskId: widget.task.id,
        reason: reason.isNotEmpty ? reason : _selectedPreset,
      ),
    );

    if (mounted) {
      // Đồng bộ lập tức sang Tab 2 (Nhật ký chi phí)
      context.read<ServiceLogCubit>().loadLogs();
      Navigator.pop(context);
      AppSnackBar.showSuccess(context, 'Đã ghi nhận bỏ qua đợt này và chuyển sang chu kỳ tiếp theo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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

              // 2. Tiêu đề & Thông tin task
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bỏ Qua Đợt Bảo Trì Này',
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
                            color: Colors.orange,
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

              const SizedBox(height: 14),

              // 3. Thông báo giải thích cơ chế chuyển chu kỳ (Apple Callout)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.25)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.info, size: 18, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Hạn công việc sẽ tự động lùi sang chu kỳ tiếp theo (+${widget.task.frequencyMonths} tháng) để không bị báo quá hạn. Đồng thời hệ thống tự động ghi nhận bản ghi 0 ₫ vào sổ cái lịch sử.',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: isDark ? Colors.white70 : const Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4. Lý do bỏ qua (Preset Chips)
              const Text(
                'Lý do bỏ qua đợt này:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _presets.map((preset) {
                  final isSelected = _selectedPreset == preset;
                  return ChoiceChip(
                    label: Text(preset, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPreset = preset;
                          _reasonController.text = preset;
                        });
                      }
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              // Ô nhập tùy chọn lý do
              TextField(
                controller: _reasonController,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Nhập lý do khác...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF26262A) : const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // 5. Hàng nút xác nhận (KHÔNG TIỀN TỐ ICON)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Quay lại', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
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
                              'Xác nhận bỏ qua',
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
}
