import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/core/widgets/barcode_scanner_modal.dart';
import 'package:home_sync/features/maintenance/domain/entities/category_entity.dart';

/// Widget Khối Thông Tin Thiết Bị: Tên, Danh mục BottomSheet, Hãng + Chips, Model/Serial + Scan, Vị trí + Chips
class ItemDeviceInfoCard extends StatelessWidget {
  const ItemDeviceInfoCard({
    super.key,
    required this.nameController,
    required this.brandController,
    required this.modelController,
    required this.serialController,
    required this.locationController,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.onScanBarcodePressed,
  });

  final TextEditingController nameController;
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController serialController;
  final TextEditingController locationController;
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback? onScanBarcodePressed;

  static const List<String> _quickBrands = [
    'Panasonic',
    'Samsung',
    'LG',
    'Daikin',
    'Sony',
    'Apple',
    'Philips',
    'Xiaomi',
    'Honda',
  ];

  static const List<String> _quickLocations = [
    'Phòng khách',
    'Phòng bếp',
    'Phòng ngủ',
    'Phòng làm việc',
    'Ban công',
    'Ga-ra',
    'Kho',
  ];

  void _showCategoryBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Thanh kéo handle bar
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chọn danh mục thiết bị',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 20),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = selectedCategoryId == cat.id;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        title: Text(
                          cat.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.primary : null,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(LucideIcons.check, color: AppColors.primary, size: 20)
                            : null,
                        onTap: () {
                          onCategorySelected(cat.id);
                          Navigator.of(ctx).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _buildDecoration({
    required BuildContext context,
    required String labelText,
    String? hintText,
    Widget? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final fillColor = isDark ? Colors.grey.shade900 : Colors.grey.shade50;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      suffixIcon: suffixIcon,
      counterText: '', // Ẩn bộ đếm ký tự để giữ form sạch sẽ
      isDense: true,
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategoryName = (selectedCategoryId != null && categories.any((c) => c.id == selectedCategoryId))
        ? categories.firstWhere((c) => c.id == selectedCategoryId).name
        : (categories.isNotEmpty ? categories.first.name : 'Chọn danh mục thiết bị');

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thông tin thiết bị', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),

          // 1. Tên thiết bị
          TextFormField(
            controller: nameController,
            maxLength: 100,
            decoration: _buildDecoration(
              context: context,
              labelText: 'Tên thiết bị *',
              hintText: 'VD: Tủ lạnh Inverter 550L',
            ),
            validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập tên thiết bị' : null,
          ),
          const SizedBox(height: 12),

          // 2. Ô chọn Danh mục thiết bị mở BottomSheet cao cấp
          InkWell(
            onTap: () => _showCategoryBottomSheet(context),
            borderRadius: BorderRadius.circular(10),
            child: IgnorePointer(
              child: TextFormField(
                key: ValueKey(selectedCategoryId ?? selectedCategoryName),
                initialValue: selectedCategoryName,
                decoration: _buildDecoration(
                  context: context,
                  labelText: 'Danh mục thiết bị *',
                  hintText: 'Chọn danh mục thiết bị',
                  suffixIcon: const Icon(LucideIcons.chevronDown, size: 18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 3. Hãng sản xuất & Quick Brand Chips
          TextFormField(
            controller: brandController,
            maxLength: 50,
            decoration: _buildDecoration(
              context: context,
              labelText: 'Hãng sản xuất',
              hintText: 'VD: Panasonic, Daikin, Apple...',
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              scrollCacheExtent: const ScrollCacheExtent.pixels(200),
              itemCount: _quickBrands.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final brand = _quickBrands[index];
                return ActionChip(
                  label: Text(brand, style: const TextStyle(fontSize: 12)),
                  padding: EdgeInsets.zero,
                  onPressed: () => brandController.text = brand,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // 4. Model No (Mã kiểu máy)
          TextFormField(
            controller: modelController,
            maxLength: 50,
            decoration: _buildDecoration(
              context: context,
              labelText: 'Model No (Mã kiểu máy)',
              hintText: 'VD: NR-CW530XMMV',
            ),
          ),
          const SizedBox(height: 12),

          // 5. Số Serial kèm nút Quét Barcode
          TextFormField(
            controller: serialController,
            maxLength: 50,
            decoration: _buildDecoration(
              context: context,
              labelText: 'Số Serial',
              hintText: 'Nhập hoặc bấm quét mã vạch',
              suffixIcon: IconButton(
                icon: const Icon(LucideIcons.scanLine, size: 20),
                tooltip: 'Quét mã vạch Serial',
                onPressed: onScanBarcodePressed ??
                    () async {
                      final code = await BarcodeScannerModal.show(context);
                      if (code != null && code.isNotEmpty) {
                        serialController.text = code;
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã nhận diện số Serial: $code'),
                              backgroundColor: AppColors.success,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 5. Vị trí đặt máy & Quick Location Chips
          TextFormField(
            controller: locationController,
            maxLength: 50,
            decoration: _buildDecoration(
              context: context,
              labelText: 'Vị trí đặt máy',
              hintText: 'VD: Phòng khách, Bếp tầng 1...',
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              scrollCacheExtent: const ScrollCacheExtent.pixels(200),
              itemCount: _quickLocations.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final loc = _quickLocations[index];
                return ActionChip(
                  label: Text(loc, style: const TextStyle(fontSize: 12)),
                  padding: EdgeInsets.zero,
                  onPressed: () => locationController.text = loc,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
