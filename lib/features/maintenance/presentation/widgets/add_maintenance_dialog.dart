import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_cubit.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';
import 'package:home_sync/features/maintenance/presentation/cubit/maintenance_cubit.dart';

/// Dialog thêm lịch bảo trì mới kèm presets gợi ý
class AddMaintenanceDialog extends StatefulWidget {
  const AddMaintenanceDialog({super.key, this.preselectedItemId, this.preselectedItemName});

  final String? preselectedItemId;
  final String? preselectedItemName;

  @override
  State<AddMaintenanceDialog> createState() => _AddMaintenanceDialogState();
}

class _AddMaintenanceDialogState extends State<AddMaintenanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _technicianPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedItemId;
  String? _selectedItemName;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  int _intervalMonths = 6;
  String _priority = 'medium';

  @override
  void initState() {
    super.initState();
    _selectedItemId = widget.preselectedItemId;
    _selectedItemName = widget.preselectedItemName;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _technicianPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsState = context.read<ItemListCubit>().state;
    final items = itemsState is ItemListLoaded ? itemsState.items : [];

    return AlertDialog(
      title: const Text('Thêm Lịch Bảo Trì', style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedItemId,
                hint: const Text('Chọn thiết bị *'),
                items: items
                    .map<DropdownMenuItem<String>>(
                      (i) => DropdownMenuItem<String>(
                        value: i.id,
                        child: Text(i.name, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedItemId = val;
                    _selectedItemName = items.where((i) => i.id == val).firstOrNull?.name;
                  });
                },
                decoration: const InputDecoration(labelText: 'Thiết bị liên quan'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Công việc cần làm *',
                  hintText: 'VD: Vệ sinh lưới lọc bụi, thay lõi lọc',
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập công việc' : null,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Hạn bảo dưỡng tiếp theo', style: TextStyle(fontSize: 13)),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy').format(_dueDate),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                trailing: const Icon(LucideIcons.calendar, size: 20),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null) {
                    setState(() => _dueDate = picked);
                  }
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Chu kỳ lặp:', style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  DropdownButton<int>(
                    value: _intervalMonths,
                    items: [1, 3, 6, 12, 24]
                        .map((m) => DropdownMenuItem(value: m, child: Text('$m tháng')))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _intervalMonths = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Mức ưu tiên:', style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  DropdownButton<String>(
                    value: _priority,
                    items: const [
                      DropdownMenuItem(value: 'low', child: Text('Thấp')),
                      DropdownMenuItem(value: 'medium', child: Text('Bình thường')),
                      DropdownMenuItem(value: 'high', child: Text('Cao')),
                      DropdownMenuItem(value: 'urgent', child: Text('Khẩn cấp')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _priority = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _technicianPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'SĐT Thợ / Trung tâm bảo hành',
                  hintText: 'Nhập số điện thoại để gọi nhanh',
                  prefixIcon: Icon(LucideIcons.phone, size: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: const Text('Lưu lịch'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final task = MaintenanceTaskEntity(
      id: '',
      itemId: _selectedItemId ?? '',
      itemName: _selectedItemName,
      taskName: _titleController.text.trim(),
      nextDueDate: _dueDate,
      frequencyMonths: _intervalMonths,
      priority: _priority,
      technicianPhone: _technicianPhoneController.text.trim().isNotEmpty
          ? _technicianPhoneController.text.trim()
          : null,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    context.read<MaintenanceCubit>().addTask(task);
    Navigator.pop(context);
  }
}
