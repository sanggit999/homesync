import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/di/injection_container.dart';
import 'package:home_sync/core/services/storage_service.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:home_sync/features/items/domain/entities/item_entity.dart';
import 'package:home_sync/features/items/presentation/cubit/item_form_cubit.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_cubit.dart';
import 'package:home_sync/features/items/presentation/widgets/item_device_info_card.dart';
import 'package:home_sync/features/items/presentation/widgets/item_notes_card.dart';
import 'package:home_sync/features/items/presentation/widgets/item_photo_picker_card.dart';
import 'package:home_sync/features/items/presentation/widgets/item_warranty_purchase_card.dart';
import 'package:home_sync/features/maintenance/domain/entities/category_entity.dart';
import 'package:home_sync/features/maintenance/domain/usecases/maintenance_usecases.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// Màn hình Thêm / Chỉnh sửa Thiết bị (Clean Architecture, Modular Components)
class AddEditItemPage extends StatefulWidget {
  const AddEditItemPage({super.key, this.itemToEdit});

  final ItemEntity? itemToEdit;

  @override
  State<AddEditItemPage> createState() => _AddEditItemPageState();
}

class _AddEditItemPageState extends State<AddEditItemPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _serialController;
  late final TextEditingController _locationController;
  late final TextEditingController _storeController;
  late final TextEditingController _priceController;
  late final TextEditingController _supportPhoneController;
  late final TextEditingController _notesController;

  String? _selectedCategoryId;
  String? _selectedCategoryName;
  List<CategoryEntity> _categories = [];
  late DateTime _purchaseDate;
  late DateTime _warrantyExpiryDate;
  int _warrantyMonths = 12;

  late final String _clientGeneratedId;
  String? _deviceImagePath;
  String? _receiptImagePath;
  String? _warrantyCardImagePath;

  @override
  void initState() {
    super.initState();
    final item = widget.itemToEdit;
    _clientGeneratedId = (item != null && item.id.isNotEmpty) ? item.id : const Uuid().v4();
    _nameController = TextEditingController(text: item?.name ?? '');
    _brandController = TextEditingController(text: item?.brand ?? '');
    _modelController = TextEditingController(text: item?.modelNumber ?? '');
    _serialController = TextEditingController(text: item?.serialNumber ?? '');
    _locationController = TextEditingController(text: item?.location ?? 'Phòng khách');
    _storeController = TextEditingController(text: item?.storeName ?? '');
    
    // Format giá ban đầu có dấu chấm phân cách
    final initialPrice = item?.price;
    _priceController = TextEditingController(
      text: initialPrice != null && initialPrice > 0
          ? NumberFormat('#,###', 'vi_VN').format(initialPrice).replaceAll(',', '.')
          : '',
    );
    _supportPhoneController = TextEditingController(text: item?.supportPhone ?? '');
    _notesController = TextEditingController(text: item?.notes ?? '');

    _selectedCategoryId = item?.categoryId;
    _selectedCategoryName = item?.categoryName;

    _purchaseDate = item?.purchaseDate ?? DateTime.now();
    _warrantyExpiryDate = item?.warrantyExpiryDate ?? DateTime.now().add(const Duration(days: 365));
    _warrantyMonths = item?.warrantyPeriodMonths ?? 12;

    _deviceImagePath = item?.deviceImageUrl;
    _receiptImagePath = item?.receiptImageUrl;
    _warrantyCardImagePath = item?.warrantyCardImageUrl;

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final getCategoriesUseCase = sl<GetCategoriesUseCase>();
    final result = await getCategoriesUseCase();
    result.fold(
      (_) {},
      (cats) {
        if (!mounted || cats.isEmpty) return;
        setState(() {
          _categories = cats;
          if (_selectedCategoryId == null && _selectedCategoryName == null) {
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

  void _onCategorySelected(String catId) {
    setState(() {
      _selectedCategoryId = catId;
      final found = _categories.where((c) => c.id == catId);
      _selectedCategoryName = found.isNotEmpty ? found.first.name : null;
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

  bool _isUploading = false;

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
        final isSubmitting = state is ItemFormSubmitting || _isUploading;

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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              children: [
                // 1. Khối Đính Kèm Ảnh
                AppCard(
                  padding: const EdgeInsets.all(14),
                  child: ItemPhotoPickerCard(
                    deviceImagePath: _deviceImagePath,
                    receiptImagePath: _receiptImagePath,
                    warrantyCardImagePath: _warrantyCardImagePath,
                    onDeviceImageChanged: (path) => setState(() => _deviceImagePath = path),
                    onReceiptImageChanged: (path) => setState(() => _receiptImagePath = path),
                    onWarrantyCardImageChanged: (path) => setState(() => _warrantyCardImagePath = path),
                  ),
                ),
                const SizedBox(height: 14),

                // 2. Khối Thông Tin Thiết Bị
                ItemDeviceInfoCard(
                  nameController: _nameController,
                  brandController: _brandController,
                  modelController: _modelController,
                  serialController: _serialController,
                  locationController: _locationController,
                  categories: _categories,
                  selectedCategoryId: _selectedCategoryId,
                  onCategorySelected: _onCategorySelected,
                ),
                const SizedBox(height: 14),

                // 3. Khối Bảo Hành & Mua Hàng
                ItemWarrantyPurchaseCard(
                  purchaseDate: _purchaseDate,
                  warrantyExpiryDate: _warrantyExpiryDate,
                  warrantyMonths: _warrantyMonths,
                  priceController: _priceController,
                  storeController: _storeController,
                  supportPhoneController: _supportPhoneController,
                  onPurchaseDateChanged: (d) {
                    setState(() {
                      _purchaseDate = d;
                      _updateExpiryDate();
                    });
                  },
                  onWarrantyExpiryDateChanged: (d) => setState(() => _warrantyExpiryDate = d),
                  onWarrantyMonthsChanged: (m) {
                    setState(() {
                      _warrantyMonths = m;
                      _updateExpiryDate();
                    });
                  },
                ),
                const SizedBox(height: 14),

                // 4. Khối Ghi Chú
                ItemNotesCard(notesController: _notesController),
                const SizedBox(height: 24),

                // 5. Nút Lưu Thiết Bị
                ElevatedButton(
                  onPressed: isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : 'guest-local';

    final isEditing = widget.itemToEdit != null;
    final cleanPrice = _priceController.text.replaceAll('.', '').replaceAll(',', '').trim();
    final price = double.tryParse(cleanPrice);

    setState(() => _isUploading = true);

    String? uploadedDeviceUrl = _deviceImagePath;
    String? uploadedReceiptUrl = _receiptImagePath;
    String? uploadedWarrantyUrl = _warrantyCardImagePath;

    try {
      final storageService = sl<StorageService>();

      // 1. Upload ảnh thiết bị nếu là local file
      if (_deviceImagePath != null && !_deviceImagePath!.startsWith('http')) {
        final file = File(_deviceImagePath!);
        if (await file.exists()) {
          final ext = _deviceImagePath!.split('.').last;
          final storagePath = '$userId/${DateTime.now().millisecondsSinceEpoch}_device.$ext';
          uploadedDeviceUrl = await storageService.uploadFile(
            path: storagePath,
            fileSource: file,
          );
        }
      }

      // 2. Upload hóa đơn nếu là local file
      if (_receiptImagePath != null && !_receiptImagePath!.startsWith('http')) {
        final file = File(_receiptImagePath!);
        if (await file.exists()) {
          final ext = _receiptImagePath!.split('.').last;
          final storagePath = '$userId/${DateTime.now().millisecondsSinceEpoch}_receipt.$ext';
          uploadedReceiptUrl = await storageService.uploadFile(
            path: storagePath,
            fileSource: file,
          );
        }
      }

      // 3. Upload phiếu bảo hành nếu là local file
      if (_warrantyCardImagePath != null && !_warrantyCardImagePath!.startsWith('http')) {
        final file = File(_warrantyCardImagePath!);
        if (await file.exists()) {
          final ext = _warrantyCardImagePath!.split('.').last;
          final storagePath = '$userId/${DateTime.now().millisecondsSinceEpoch}_warranty.$ext';
          uploadedWarrantyUrl = await storageService.uploadFile(
            path: storagePath,
            fileSource: file,
          );
        }
      }
    } catch (e) {
      debugPrint('[HOMESYNC STORAGE ERROR] Lỗi tải ảnh lên Supabase Storage: $e');
      if (mounted) {
        setState(() => _isUploading = false);
        final errStr = e.toString().toLowerCase();
        final friendlyMsg = (errStr.contains('socket') || errStr.contains('network') || errStr.contains('failed host lookup') || errStr.contains('clientexception'))
            ? 'Không có kết nối mạng. Vui lòng kiểm tra Wi-Fi/4G để tải ảnh lên.'
            : (errStr.contains('timeout') || errStr.contains('timed out'))
                ? 'Quá thời gian tải ảnh lên máy chủ (15s). Vui lòng thử lại.'
                : 'Lỗi tải ảnh lên đám mây: $e';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(friendlyMsg),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    if (!mounted) return;
    setState(() => _isUploading = false);

    final item = ItemEntity(
      id: _clientGeneratedId,
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
      deviceImageUrl: uploadedDeviceUrl,
      receiptImageUrl: uploadedReceiptUrl,
      warrantyCardImageUrl: uploadedWarrantyUrl,
    );

    if (isEditing) {
      context.read<ItemFormCubit>().submitUpdateItem(item);
    } else {
      context.read<ItemFormCubit>().submitCreateItem(item);
    }
  }
}
