import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_cubit.dart';
import 'package:home_sync/features/service_logs/domain/entities/service_log_entity.dart';
import 'package:home_sync/features/service_logs/presentation/cubit/service_log_cubit.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Màn hình Ghi nhận Chi phí Sửa chữa / Thay thế linh kiện đột xuất
class AddServiceLogPage extends StatefulWidget {
  const AddServiceLogPage({super.key, this.preselectedItemId});

  final String? preselectedItemId;

  @override
  State<AddServiceLogPage> createState() => _AddServiceLogPageState();
}

class _AddServiceLogPageState extends State<AddServiceLogPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _costController = TextEditingController();
  final _technicianNameController = TextEditingController();
  final _technicianPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedItemId;
  String? _selectedItemName;
  DateTime _serviceDate = DateTime.now();
  String _serviceType = 'repair';

  @override
  void initState() {
    super.initState();
    _selectedItemId = widget.preselectedItemId;
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

  @override
  Widget build(BuildContext context) {
    final itemsState = context.read<ItemListCubit>().state;
    final items = itemsState is ItemListLoaded ? itemsState.items : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi Nhận Chi Phí'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
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
                    decoration: const InputDecoration(labelText: 'Thiết bị sửa chữa *'),
                    validator: (v) => v == null ? 'Vui lòng chọn thiết bị' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nội dung sửa chữa *',
                      hintText: 'VD: Thay block máy lạnh, thay lõi lọc số 1-2-3',
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập nội dung' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _costController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Chi phí (VNĐ) *',
                      prefixText: '₫ ',
                      hintText: '350000',
                    ),
                    validator: (v) => v == null || double.tryParse(v) == null ? 'Nhập số tiền hợp lệ' : null,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Ngày thực hiện', style: TextStyle(fontSize: 14)),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(_serviceDate),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    ),
                    trailing: const Icon(LucideIcons.calendar, size: 20),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _serviceDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _serviceDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _serviceType,
                    items: const [
                      DropdownMenuItem<String>(value: 'maintenance', child: Text('Bảo dưỡng định kỳ')),
                      DropdownMenuItem<String>(value: 'repair', child: Text('Sửa chữa hư hỏng')),
                      DropdownMenuItem<String>(value: 'replacement', child: Text('Thay thế linh kiện')),
                      DropdownMenuItem<String>(value: 'other', child: Text('Chi phí khác')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _serviceType = val);
                    },
                    decoration: const InputDecoration(labelText: 'Phân loại chi phí'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _technicianNameController,
                          decoration: const InputDecoration(labelText: 'Tên thợ / Cửa hàng'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _technicianPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(labelText: 'SĐT liên hệ'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Ghi chú thêm',
                      hintText: 'Bảo hành linh kiện 6 tháng...',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Lưu Chi Phí', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : 'guest-local';
    final cost = double.tryParse(_costController.text.replaceAll(',', '').replaceAll('.', '')) ?? 0.0;

    final log = ServiceLogEntity(
      id: '',
      userId: userId,
      itemId: _selectedItemId!,
      itemName: _selectedItemName,
      serviceType: _serviceType,
      title: _titleController.text.trim(),
      serviceDate: _serviceDate,
      cost: cost,
      technicianName: _technicianNameController.text.trim().isNotEmpty
          ? _technicianNameController.text.trim()
          : null,
      technicianPhone: _technicianPhoneController.text.trim().isNotEmpty
          ? _technicianPhoneController.text.trim()
          : null,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    context.read<ServiceLogCubit>().addLog(log);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu nhật ký chi phí!'), backgroundColor: AppColors.success),
    );
    context.pop();
  }
}
