import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/utils/snackbar_utils.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_cubit.dart';
import 'package:home_sync/features/items/domain/entities/item_entity.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';
import 'package:home_sync/features/maintenance/presentation/cubit/maintenance_cubit.dart';

/// Trang Thêm / Chỉnh Sửa Lịch Bảo Trì (Dedicated Full Page Chuẩn Phong Cách Apple)
class AddEditMaintenancePage extends StatefulWidget {
  const AddEditMaintenancePage({
    super.key,
    this.preselectedItemId,
    this.preselectedItemName,
    this.taskToEdit,
  });

  final String? preselectedItemId;
  final String? preselectedItemName;
  final MaintenanceTaskEntity? taskToEdit;

  @override
  State<AddEditMaintenancePage> createState() => _AddEditMaintenancePageState();
}

class _AddEditMaintenancePageState extends State<AddEditMaintenancePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _costController;
  late final TextEditingController _technicianNameController;
  late final TextEditingController _technicianPhoneController;
  late final TextEditingController _notesController;

  String? _selectedItemId;
  String? _selectedItemName;
  late DateTime _nextDueDate;
  int _frequencyMonths = 6;
  String _priority = 'medium';
  bool _isSubmitting = false;

  // Danh sách các Smart Presets gợi ý nhanh
  static const _smartPresets = [
    {
      'title': 'Vệ sinh máy lạnh định kỳ',
      'frequency': 6,
      'cost': '250000',
      'techName': 'Anh Dũng - Điện Lạnh Bách Khoa',
      'techPhone': '0988123456',
      'notes': 'Rửa lưới lọc bụi, xịt dàn nóng & dàn lạnh, đo áp suất gas R32.',
    },
    {
      'title': 'Thay lõi lọc nước (Lõi 1, 2, 3)',
      'frequency': 3,
      'cost': '180000',
      'techName': 'Trạm Dịch Vụ Kangaroo / Karofi',
      'techPhone': '19006418',
      'notes': 'Thay bộ 3 lõi lọc thô PP 5 micron, Than hoạt tính OCB, PP 1 micron.',
    },
    {
      'title': 'Thay nhớt & bảo dưỡng xe máy',
      'frequency': 3,
      'cost': '120000',
      'techName': 'HEAD Honda Phát Tiến',
      'techPhone': '0909112233',
      'notes': 'Thay nhớt máy Castrol Power 1, kiểm tra phanh và áp suất lốp.',
    },
    {
      'title': 'Vệ sinh lồng giặt máy giặt',
      'frequency': 6,
      'cost': '300000',
      'techName': 'Trung Tâm Bảo Hành Điện Máy',
      'techPhone': '0912345678',
      'notes': 'Tháo mâm giặt tẩy cặn canxi, vệ sinh bơm xả và ống thoát nước.',
    },
  ];

  @override
  void initState() {
    super.initState();
    final task = widget.taskToEdit;
    _selectedItemId = task?.itemId ?? widget.preselectedItemId;
    _selectedItemName = task?.itemName ?? widget.preselectedItemName;

    _titleController = TextEditingController(text: task?.title ?? '');
    final initialCost = task?.cost ?? task?.estimatedCost;
    _costController = TextEditingController(
      text: initialCost != null && initialCost > 0 ? initialCost.toInt().toString() : '',
    );
    _technicianNameController = TextEditingController(text: task?.technicianName ?? '');
    _technicianPhoneController = TextEditingController(text: task?.technicianPhone ?? '');
    _notesController = TextEditingController(text: task?.notes ?? '');

    _nextDueDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 30));
    _frequencyMonths = task?.frequencyMonths ?? 6;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    _technicianNameController.dispose();
    _technicianPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Nạp mẫu dữ liệu kiểm thử nhanh (Quick Mock Data / Presets)
  void _applyPreset(Map<String, dynamic> preset, {String? matchedItemId, String? matchedItemName}) {
    setState(() {
      _titleController.text = preset['title'] as String;
      _frequencyMonths = preset['frequency'] as int;
      _costController.text = preset['cost'] as String;
      _technicianNameController.text = preset['techName'] as String;
      _technicianPhoneController.text = preset['techPhone'] as String;
      _notesController.text = preset['notes'] as String;
      _nextDueDate = DateTime.now().add(Duration(days: _frequencyMonths * 30));

      if (matchedItemId != null) {
        _selectedItemId = matchedItemId;
        _selectedItemName = matchedItemName;
      }
    });

    AppSnackBar.showSuccess(context, 'Đã áp dụng mẫu "${preset['title']}"! ⚡');
  }

  void _showQuickMockDataModal(List<ItemEntity> items) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Material(
          color: isDark ? const Color(0xFF1E1E22) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(LucideIcons.zap, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nạp Dữ Liệu Mẫu Nhanh', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        Text('Chọn 1 mẫu để tự động điền toàn bộ thông tin kiểm thử', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._smartPresets.map((preset) {
                // Tự động tìm thiết bị tương ứng trong kho nếu có
                final titleLower = (preset['title'] as String).toLowerCase();
                ItemEntity? matchedItem;
                if (titleLower.contains('máy lạnh')) {
                  matchedItem = items.where((i) => i.name.toLowerCase().contains('lạnh') || i.name.toLowerCase().contains('điều hòa')).firstOrNull;
                } else if (titleLower.contains('lọc nước')) {
                  matchedItem = items.where((i) => i.name.toLowerCase().contains('lọc')).firstOrNull;
                } else if (titleLower.contains('xe')) {
                  matchedItem = items.where((i) => i.name.toLowerCase().contains('xe')).firstOrNull;
                }
                matchedItem ??= items.firstOrNull;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(LucideIcons.check, color: AppColors.primary, size: 18),
                  ),
                  title: Text(preset['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text(
                    'Chu kỳ ${preset['frequency']} tháng • Dự toán: ${NumberFormat('#,###', 'vi_VN').format(int.parse(preset['cost'] as String))} ₫',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _applyPreset(
                      preset,
                      matchedItemId: matchedItem?.id,
                      matchedItemName: matchedItem?.name,
                    );
                  },
                );
              }),
            ],
          ),
        ),
      );
    },
    );
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      helpText: 'Chọn hạn bảo dưỡng tiếp theo',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
    );
    if (picked != null && mounted) {
      setState(() => _nextDueDate = picked);
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedItemId == null || _selectedItemId!.isEmpty) {
      AppSnackBar.showError(context, 'Vui lòng chọn thiết bị cần bảo trì.');
      return;
    }

    setState(() => _isSubmitting = true);

    final cleanCost = _costController.text.trim().replaceAll('.', '').replaceAll(',', '');
    final cost = double.tryParse(cleanCost);

    final task = MaintenanceTaskEntity(
      id: widget.taskToEdit?.id ?? const Uuid().v4(),
      itemId: _selectedItemId!,
      taskName: _titleController.text.trim(),
      frequencyMonths: _frequencyMonths,
      nextDueDate: _nextDueDate,
      estimatedCost: cost,
      cost: cost,
      technicianName: _technicianNameController.text.trim().isEmpty ? null : _technicianNameController.text.trim(),
      technicianPhone: _technicianPhoneController.text.trim().isEmpty ? null : _technicianPhoneController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      priority: _priority,
      itemName: _selectedItemName,
    );

    if (widget.taskToEdit != null) {
      await context.read<MaintenanceCubit>().updateTask(task);
    } else {
      await context.read<MaintenanceCubit>().addTask(task);
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
      AppSnackBar.showSuccess(
        context,
        widget.taskToEdit != null
            ? 'Đã cập nhật lịch bảo trì "${task.title}" thành công! 🎉'
            : 'Đã lên lịch bảo trì "${task.title}" thành công! 🎉',
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemsState = context.watch<ItemListCubit>().state;
    final items = itemsState is ItemListLoaded ? itemsState.items : <ItemEntity>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.taskToEdit != null ? 'Chỉnh Sửa Lịch Bảo Trì' : 'Thêm Lịch Bảo Trì',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            key: const Key('btn_quick_mock_data'),
            onPressed: () => _showQuickMockDataModal(items),
            icon: const Icon(LucideIcons.zap, size: 16, color: AppColors.primary),
            label: const Text(
              'Nạp mẫu',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            // Gợi ý nhanh (Quick Presets Horizontal Chips)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ActionChip(
                    avatar: const Icon(LucideIcons.wind, size: 14, color: AppColors.primary),
                    label: const Text('Máy lạnh (6T)'),
                    onPressed: () => _applyPreset(_smartPresets[0]),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    avatar: const Icon(LucideIcons.droplets, size: 14, color: AppColors.primary),
                    label: const Text('Lõi lọc nước (3T)'),
                    onPressed: () => _applyPreset(_smartPresets[1]),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    avatar: const Icon(LucideIcons.bike, size: 14, color: AppColors.primary),
                    label: const Text('Nhớt xe máy (3T)'),
                    onPressed: () => _applyPreset(_smartPresets[2]),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    avatar: const Icon(LucideIcons.sparkles, size: 14, color: AppColors.primary),
                    label: const Text('Lồng giặt (6T)'),
                    onPressed: () => _applyPreset(_smartPresets[3]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // CARD 1: Thiết Bị & Hạng Mục Bảo Dưỡng
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(LucideIcons.wrench, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Thiết Bị & Công Việc',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dropdown chọn thiết bị
                  DropdownButtonFormField<String>(
                    key: ValueKey('dropdown_select_item_$_selectedItemId'),
                    initialValue: _selectedItemId,
                    hint: const Text('Chọn thiết bị từ kho *'),
                    isExpanded: true,
                    items: items
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.id,
                            child: Text(
                              '${item.name} (${item.location ?? 'Gia đình'})',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedItemId = val;
                        _selectedItemName = items.where((i) => i.id == val).firstOrNull?.name;
                      });
                    },
                    validator: (val) => val == null || val.isEmpty ? 'Vui lòng chọn thiết bị' : null,
                    decoration: InputDecoration(
                      labelText: 'Thiết bị liên quan *',
                      prefixIcon: const Icon(LucideIcons.box, size: 18),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tên công việc
                  TextFormField(
                    key: const Key('input_task_title'),
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Tên công việc bảo dưỡng *',
                      hintText: 'Ví dụ: Vệ sinh lưới lọc bụi, nạp gas...',
                      prefixIcon: const Icon(LucideIcons.checkSquare, size: 18),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Vui lòng nhập tên công việc' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // CARD 2: Thời Gian & Chu Kỳ Định Kỳ
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(LucideIcons.calendarDays, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Thời Gian & Chu Kỳ Lặp',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Chọn ngày hẹn tiếp theo
                  const Text('Hạn bảo dưỡng tiếp theo', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  InkWell(
                    key: const Key('btn_pick_due_date'),
                    onTap: _pickDueDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 18, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('dd/MM/yyyy').format(_nextDueDate),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const Spacer(),
                          const Text(
                            'Đổi ngày',
                            style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chu kỳ định kỳ
                  const Text('Chu kỳ định kỳ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [1, 3, 6, 12, 24].map((months) {
                      final isSelected = _frequencyMonths == months;
                      return ChoiceChip(
                        label: Text('$months tháng'),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _frequencyMonths = months;
                              _nextDueDate = DateTime.now().add(Duration(days: months * 30));
                            });
                          }
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Mức độ ưu tiên
                  const Text('Mức độ ưu tiên', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildPriorityChip('low', 'Thấp', Colors.blue),
                      const SizedBox(width: 8),
                      _buildPriorityChip('medium', 'Bình thường', Colors.orange),
                      const SizedBox(width: 8),
                      _buildPriorityChip('high', 'Cao / Khẩn cấp', Colors.red),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // CARD 3: Chi Phí Dự Toán & Thợ Bảo Dưỡng
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(LucideIcons.userCheck, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Chi Phí Dự Toán & Thợ Dịch Vụ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Chi phí ước tính
                  TextFormField(
                    key: const Key('input_task_cost'),
                    controller: _costController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Chi phí dự toán (VNĐ)',
                      hintText: 'Ví dụ: 250000',
                      prefixIcon: const Icon(LucideIcons.banknote, size: 18),
                      suffixText: '₫',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) {
                      if (val != null && val.isNotEmpty) {
                        final clean = val.replaceAll('.', '').replaceAll(',', '');
                        if (double.tryParse(clean) == null) {
                          return 'Chi phí phải là số hợp lệ';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Tên thợ & Số điện thoại
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: const Key('input_technician_name'),
                          controller: _technicianNameController,
                          decoration: InputDecoration(
                            labelText: 'Tên thợ / trạm',
                            hintText: 'Anh Dũng',
                            prefixIcon: const Icon(LucideIcons.user, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          key: const Key('input_technician_phone'),
                          controller: _technicianPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Số điện thoại',
                            hintText: '0988xxxxxx',
                            prefixIcon: const Icon(LucideIcons.phone, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Ghi chú công việc
                  TextFormField(
                    key: const Key('input_task_notes'),
                    controller: _notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Ghi chú công việc / Phụ tùng thay thế',
                      hintText: 'Nhắc nhở chuẩn bị đồ hoặc số điện thoại bảo hành bổ sung...',
                      prefixIcon: const Icon(LucideIcons.fileText, size: 18),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E22) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              key: const Key('btn_save_maintenance_task'),
              onPressed: _isSubmitting ? null : _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 2,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Text(
                      widget.taskToEdit != null ? 'Cập Nhật Lịch Bảo Trì' : 'Lưu Lịch Bảo Trì',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String value, String label, Color color) {
    final isSelected = _priority == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _priority = value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
            border: Border.all(
              color: isSelected ? color : (Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.black12),
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? color : null,
            ),
          ),
        ),
      ),
    );
  }
}
