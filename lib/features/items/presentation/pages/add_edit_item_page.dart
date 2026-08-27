import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:home_sync/features/items/domain/entities/item_entity.dart';
import 'package:home_sync/features/items/presentation/cubit/item_form_cubit.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_cubit.dart';

import 'package:home_sync/core/di/injection_container.dart';
import 'package:home_sync/features/maintenance/domain/entities/category_entity.dart';
import 'package:home_sync/features/maintenance/domain/usecases/maintenance_usecases.dart';

/// Màn hình Thêm / Chỉnh sửa Thiết bị (Kèm gợi ý Smart Maintenance Presets)
class AddEditItemPage extends StatefulWidget {
  const AddEditItemPage({super.key, this.itemToEdit});

  final ItemEntity? itemToEdit;

  @override
  State<AddEditItemPage> createState() => _AddEditItemPageState();
}

class _AddEditItemPageState extends State<AddEditItemPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _serialController;
  late TextEditingController _locationController;
  late TextEditingController _storeController;
  late TextEditingController _priceController;
  late TextEditingController _supportPhoneController;
  late TextEditingController _notesController;

  String? _selectedCategoryId;
  String? _selectedCategoryName;
  List<CategoryEntity> _categories = [];
  late DateTime _purchaseDate;
  late DateTime _warrantyExpiryDate;
  int _warrantyMonths = 12;

  final Map<String, String> _smartPresetSuggestions = {
    'Điện lạnh': '💡 Gợi ý: Vệ sinh lưới lọc bụi & bảo dưỡng gas mỗi 6 tháng.',
    'Gia dụng': '💡 Gợi ý: Thay lõi lọc nước mỗi 6-12 tháng tùy lưu lượng.',
    'Xe cộ': '💡 Gợi ý: Thay dầu máy động cơ mỗi 3.000 - 5.000 km hoặc 6 tháng.',
    'Thiết bị bếp': '💡 Gợi ý: Khử cặn máy rửa bát & vệ sinh lưới hút mùi định kỳ 3 tháng.',
  };

  @override
  void initState() {
    super.initState();
    final item = widget.itemToEdit;
    _nameController = TextEditingController(text: item?.name ?? '');
    _brandController = TextEditingController(text: item?.brand ?? '');
    _modelController = TextEditingController(text: item?.modelNumber ?? '');
    _serialController = TextEditingController(text: item?.serialNumber ?? '');
    _locationController = TextEditingController(text: item?.location ?? 'Phòng khách');
    _storeController = TextEditingController(text: item?.storeName ?? '');
    _priceController = TextEditingController(text: item?.price != null ? item!.price!.toStringAsFixed(0) : '');
    _supportPhoneController = TextEditingController(text: item?.supportPhone ?? '');
    _notesController = TextEditingController(text: item?.notes ?? '');

    _selectedCategoryId = item?.categoryId;
    _selectedCategoryName = item?.categoryName;
    _purchaseDate = item?.purchaseDate ?? DateTime.now();
    _warrantyExpiryDate = item?.warrantyExpiryDate ?? DateTime.now().add(const Duration(days: 365));
    _warrantyMonths = item?.warrantyPeriodMonths ?? 12;

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final getCategoriesUseCase = sl<GetCategoriesUseCase>();
    final result = await getCategoriesUseCase();
    result.fold(
      (_) {},
      (cats) {
        if (!mounted) return;
        setState(() {
          _categories = cats;
          if (_selectedCategoryId == null && _selectedCategoryName == null && _categories.isNotEmpty) {
            _selectedCategoryId = _categories.first.id;
            _selectedCategoryName = _categories.first.name;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _serialController.dispose();
    _locationController.dispose();
    _storeController.dispose();
    _priceController.dispose();
    _supportPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String? catId) {
    setState(() {
      _selectedCategoryId = catId;
      final found = _categories.where((c) => c.id == catId);
      _selectedCategoryName = found.isNotEmpty ? found.first.name : null;
      if (_selectedCategoryName == 'Điện lạnh' && _supportPhoneController.text.isEmpty) {
        _supportPhoneController.text = '1800-1593';
      }
    });
  }

  void _updateExpiryDate() {
    setState(() {
      _warrantyExpiryDate = DateTime(
        _purchaseDate.year,
        _purchaseDate.month + _warrantyMonths,
        _purchaseDate.day,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.itemToEdit != null;

    return BlocConsumer<ItemFormCubit, ItemFormState>(
      listener: (context, state) {
        if (state is ItemFormSuccess) {
          context.read<ItemListCubit>().loadItems();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditing ? 'Đã cập nhật thiết bị!' : 'Đã thêm thiết bị mới thành công!'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else if (state is ItemFormFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state is ItemFormSubmitting;

        return Scaffold(
          appBar: AppBar(
            title: Text(isEditing ? 'Sửa thiết bị' : 'Thêm thiết bị mới'),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : _submitForm,
                child: isSubmitting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_selectedCategoryName != null && _smartPresetSuggestions.containsKey(_selectedCategoryName))
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      _smartPresetSuggestions[_selectedCategoryName]!,
                      style: const TextStyle(fontSize: 12, color: AppColors.primary),
                    ),
                  ),

                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Thông tin cơ bản', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Tên thiết bị *',
                          hintText: 'VD: Điều hòa Daikin Inverter',
                          prefixIcon: Icon(LucideIcons.package, size: 18),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập tên thiết bị' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategoryId,
                        items: _categories
                            .map((c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name),
                                ))
                            .toList(),
                        onChanged: _onCategorySelected,
                        decoration: const InputDecoration(
                          labelText: 'Danh mục',
                          prefixIcon: Icon(LucideIcons.tag, size: 18),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _brandController,
                              decoration: const InputDecoration(labelText: 'Hãng (VD: Sony, Daikin)'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _modelController,
                              decoration: const InputDecoration(labelText: 'Model No'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _serialController,
                        decoration: const InputDecoration(
                          labelText: 'Số Serial',
                          hintText: 'Nhập hoặc quét mã vạch',
                          prefixIcon: Icon(LucideIcons.scan, size: 18),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Vị trí / Phòng',
                          hintText: 'VD: Phòng khách, Bếp tầng 1',
                          prefixIcon: Icon(LucideIcons.mapPin, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bảo hành & Mua hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 14),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Ngày mua hàng', style: TextStyle(fontSize: 14)),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy').format(_purchaseDate),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        trailing: const Icon(LucideIcons.calendar, size: 20),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _purchaseDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() {
                              _purchaseDate = picked;
                              _updateExpiryDate();
                            });
                          }
                        },
                      ),
                      const Divider(height: 12),
                      Row(
                        children: [
                          const Text('Thời hạn bảo hành:', style: TextStyle(fontSize: 14)),
                          const Spacer(),
                          DropdownButton<int>(
                            value: _warrantyMonths,
                            items: [6, 12, 18, 24, 36, 60]
                                .map((m) => DropdownMenuItem(value: m, child: Text('$m tháng')))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _warrantyMonths = val;
                                  _updateExpiryDate();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Ngày hết hạn bảo hành', style: TextStyle(fontSize: 14)),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy').format(_warrantyExpiryDate),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning),
                        ),
                        trailing: const Icon(LucideIcons.calendarOff, size: 20),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _warrantyExpiryDate,
                            firstDate: _purchaseDate,
                            lastDate: DateTime(2050),
                          );
                          if (picked != null) {
                            setState(() => _warrantyExpiryDate = picked);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Giá mua (VNĐ)', prefixText: '₫ '),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _storeController,
                              decoration: const InputDecoration(labelText: 'Nơi mua (Điện máy Xanh...)'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _supportPhoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Hotline bảo hành hãng',
                          hintText: '1800-xxxx',
                          prefixIcon: Icon(LucideIcons.phone, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Ghi chú thêm',
                      hintText: 'Ví dụ: Cục nóng lắp ở ban công tầng 3...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    isEditing ? 'Cập nhật thiết bị' : 'Lưu thiết bị',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : 'guest-local';

    final isEditing = widget.itemToEdit != null;
    final price = double.tryParse(_priceController.text.replaceAll(',', '').replaceAll('.', ''));

    final item = ItemEntity(
      id: isEditing ? widget.itemToEdit!.id : '',
      userId: userId,
      name: _nameController.text.trim(),
      categoryId: _selectedCategoryId,
      categoryName: _selectedCategoryName,
      brand: _brandController.text.trim().isNotEmpty ? _brandController.text.trim() : null,
      modelNumber: _modelController.text.trim().isNotEmpty ? _modelController.text.trim() : null,
      serialNumber: _serialController.text.trim().isNotEmpty ? _serialController.text.trim() : null,
      location: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : null,
      storeName: _storeController.text.trim().isNotEmpty ? _storeController.text.trim() : null,
      price: price,
      purchaseDate: _purchaseDate,
      warrantyPeriodMonths: _warrantyMonths,
      warrantyExpiryDate: _warrantyExpiryDate,
      supportPhone: _supportPhoneController.text.trim().isNotEmpty ? _supportPhoneController.text.trim() : null,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      isFavorite: widget.itemToEdit?.isFavorite ?? false,
      status: widget.itemToEdit?.status ?? 'active',
      deviceImageUrl: widget.itemToEdit?.deviceImageUrl,
      receiptImageUrl: widget.itemToEdit?.receiptImageUrl,
      warrantyCardImageUrl: widget.itemToEdit?.warrantyCardImageUrl,
    );

    if (isEditing) {
      context.read<ItemFormCubit>().submitUpdateItem(item);
    } else {
      context.read<ItemFormCubit>().submitCreateItem(item);
    }
  }
}
