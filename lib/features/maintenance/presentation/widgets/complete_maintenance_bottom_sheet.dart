import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/utils/currency_input_formatter.dart';
import 'package:home_sync/core/utils/snackbar_utils.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';
import 'package:home_sync/features/maintenance/presentation/cubit/maintenance_cubit.dart';
import 'package:home_sync/features/service_logs/presentation/cubit/service_log_cubit.dart';

/// Modal BottomSheet Hoàn Thành Lịch Bảo Trì (Đập đi xây lại chuẩn Apple HIG)
/// - Khung nhập chi phí lớn phong cách Apple Wallet / Apple Pay.
/// - Chip chọn mức tiền nhanh 1-chạm.
/// - Tile chọn ngày thực hiện với thứ tiếng Việt chuẩn xác.
/// - Nhóm trường thông tin thợ & phụ tùng kiểu iOS Grouped Inset.
/// - Nút bấm lớn toàn chiều rộng thuần Text (không tiền tố icon).
class CompleteMaintenanceBottomSheet extends StatefulWidget {
  const CompleteMaintenanceBottomSheet({
    super.key,
    required this.task,
  });

  final MaintenanceTaskEntity task;

  /// Mở Modal BottomSheet vuốt từ cạnh dưới lên
  static Future<void> show(BuildContext context, MaintenanceTaskEntity task) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CompleteMaintenanceBottomSheet(task: task),
    );
  }

  @override
  State<CompleteMaintenanceBottomSheet> createState() => _CompleteMaintenanceBottomSheetState();
}

class _CompleteMaintenanceBottomSheetState extends State<CompleteMaintenanceBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final NumberFormat _formatter = NumberFormat('#,###', 'vi_VN');

  late DateTime _completedDate;
  late final TextEditingController _costController;
  late final TextEditingController _technicianNameController;
  late final TextEditingController _technicianPhoneController;
  late final TextEditingController _notesController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _completedDate = DateTime.now();

    // Điền sẵn chi phí dự toán nếu có
    final initialCost = widget.task.cost ?? widget.task.estimatedCost;
    if (initialCost != null && initialCost > 0) {
      _costController = TextEditingController(
        text: _formatter.format(initialCost.toInt()).replaceAll(',', '.'),
      );
    } else {
      _costController = TextEditingController();
    }

    _technicianNameController = TextEditingController(text: widget.task.technicianName ?? '');
    _technicianPhoneController = TextEditingController(text: widget.task.technicianPhone ?? '');
    _notesController = TextEditingController(text: widget.task.notes ?? '');
  }

  @override
  void dispose() {
    _costController.dispose();
    _technicianNameController.dispose();
    _technicianPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDateWithWeekday(DateTime date) {
    const weekdays = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];
    final weekday = weekdays[date.weekday - 1];
    return '$weekday, ${DateFormat('dd/MM/yyyy').format(date)}';
  }

  void _setCostPreset(int amount) {
    setState(() {
      if (amount == 0) {
        _costController.text = '0';
      } else {
        _costController.text = _formatter.format(amount).replaceAll(',', '.');
      }
    });
  }

  Future<void> _pickCompletedDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _completedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'CHỌN NGÀY HOÀN THÀNH',
      cancelText: 'HỦY',
      confirmText: 'CHỌN',
    );
    if (picked != null && mounted) {
      setState(() => _completedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final costText = _costController.text.trim().replaceAll(',', '').replaceAll('.', '');
    final cost = double.tryParse(costText) ?? 0.0;

    setState(() => _isSubmitting = true);

    final params = CompleteTaskParams(
      taskId: widget.task.id,
      completedDate: _completedDate,
      cost: cost,
      technicianName: _technicianNameController.text.trim().isEmpty
          ? null
          : _technicianNameController.text.trim(),
      technicianPhone: _technicianPhoneController.text.trim().isEmpty
          ? null
          : _technicianPhoneController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await context.read<MaintenanceCubit>().completeTask(params);

    if (mounted) {
      // Làm mới tức thì sổ cái lịch sử (Tab 2)
      context.read<ServiceLogCubit>().loadLogs();
      Navigator.of(context).pop();
      AppSnackBar.showSuccess(
        context,
        'Đã ghi nhận bảo trì & cập nhật chu kỳ tiếp theo cho "${widget.task.title}"! 🎉',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final estimatedCost = widget.task.cost ?? widget.task.estimatedCost;

    return Material(
      color: isDark ? const Color(0xFF1E1E22) : Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── 1. THANH KÉO APPLE GRABBER BAR ───
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

                // ─── 2. HEADER: AVATAR ICON + TIÊU ĐỀ + NÚT ĐÓNG ───
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar icon khối bo góc
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        LucideIcons.checkCheck,
                        color: AppColors.success,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Tiêu đề & Thông tin task
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xác Nhận Hoàn Thành',
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.task.itemName != null && widget.task.itemName!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Thiết bị: ${widget.task.itemName}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Nút đóng X
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ─── 3. KHỐI NHẬP CHI PHÍ THỰC TẾ (APPLE WALLET STYLE) ───
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF26262A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CHI PHÍ BẢO DƯỠNG THỰC TẾ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Ô nhập số tiền to, xanh lá cây nổi bật
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _costController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                ThousandsSeparatorInputFormatter(),
                              ],
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                                letterSpacing: 0.5,
                              ),
                              decoration: InputDecoration(
                                hintText: '0',
                                hintStyle: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success.withValues(alpha: 0.3),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          const Text(
                            '₫',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 10),

                      // Dải chip gợi ý tiền tệ 1-chạm
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (estimatedCost != null && estimatedCost > 0)
                            ActionChip(
                              label: Text(
                                'Dự toán: ${_formatter.format(estimatedCost.toInt())} ₫',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              onPressed: () => _setCostPreset(estimatedCost.toInt()),
                            ),
                          _buildQuickCostChip('100.000 ₫', 100000, isDark),
                          _buildQuickCostChip('150.000 ₫', 150000, isDark),
                          _buildQuickCostChip('200.000 ₫', 200000, isDark),
                          _buildQuickCostChip('500.000 ₫', 500000, isDark),
                          _buildQuickCostChip('Miễn phí (0 ₫)', 0, isDark),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ─── 4. NGÀY THỰC HIỆN BẢO DƯỠNG (INSET TILE) ───
                InkWell(
                  onTap: _pickCompletedDate,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF26262A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(LucideIcons.calendar, size: 18, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ngày thực hiện bảo dưỡng',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(_completedDate) ==
                                          DateFormat('dd/MM/yyyy').format(DateTime.now())
                                      ? 'Hôm nay (${DateFormat('dd/MM/yyyy').format(_completedDate)})'
                                      : _formatDateWithWeekday(_completedDate),
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                  ),
                                ),
                              ],
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

                const SizedBox(height: 14),

                // ─── 5. THÔNG TIN THỢ & PHỤ TÙNG (APPLE GROUPED INSET) ───
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF26262A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Tên thợ
                      TextFormField(
                        controller: _technicianNameController,
                        style: const TextStyle(fontSize: 13.5),
                        decoration: InputDecoration(
                          labelText: 'Tên thợ / Đơn vị thực hiện',
                          hintText: 'VD: Anh Hùng điện lạnh, Daikin Service...',
                          prefixIcon: const Icon(LucideIcons.userCheck, size: 17),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E1E22) : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Số điện thoại thợ
                      TextFormField(
                        controller: _technicianPhoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 13.5),
                        decoration: InputDecoration(
                          labelText: 'Số điện thoại liên hệ',
                          hintText: 'VD: 0988 123 456',
                          prefixIcon: const Icon(LucideIcons.phone, size: 17),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E1E22) : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Ghi chú & Phụ tùng
                      TextFormField(
                        controller: _notesController,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 13.5),
                        decoration: InputDecoration(
                          labelText: 'Ghi chú kỹ thuật & Phụ tùng thay thế',
                          hintText: 'VD: Thay lõi lọc 1 & 2, bơm gas bổ sung...',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Icon(LucideIcons.fileText, size: 17),
                          ),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E1E22) : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ─── 6. APPLE HIGHLIGHT CALLOUT: CHUYỂN CHU KỲ TỰ ĐỘNG ───
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.refreshCw, size: 16, color: AppColors.success),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Hạn công việc sẽ tự động lùi sang chu kỳ tiếp theo (+${widget.task.frequencyMonths} tháng) và lưu vết vào Sổ cái chi phí.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : const Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ─── 7. NÚT XÁC NHẬN TOÀN CHIỀU RỘNG (KHÔNG TIỀN TỐ ICON) ───
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Xác Nhận Hoàn Thành',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickCostChip(String label, int amount, bool isDark) {
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : const Color(0xFF374151),
        ),
      ),
      backgroundColor: isDark ? const Color(0xFF1E1E22) : Colors.white,
      side: BorderSide(
        color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      onPressed: () => _setCostPreset(amount),
    );
  }
}
