import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';

/// Widget quản lý 3 ô đính kèm hình ảnh (Ảnh thiết bị, Hóa đơn, Phiếu bảo hành) phong cách Minimalist
class ItemPhotoPickerCard extends StatelessWidget {
  const ItemPhotoPickerCard({
    super.key,
    this.deviceImagePath,
    this.receiptImagePath,
    this.warrantyCardImagePath,
    required this.onDeviceImageChanged,
    required this.onReceiptImageChanged,
    required this.onWarrantyCardImageChanged,
  });

  final String? deviceImagePath;
  final String? receiptImagePath;
  final String? warrantyCardImagePath;

  final ValueChanged<String?> onDeviceImageChanged;
  final ValueChanged<String?> onReceiptImageChanged;
  final ValueChanged<String?> onWarrantyCardImageChanged;

  Future<void> _pickImage(BuildContext context, ValueChanged<String?> onChanged) async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(LucideIcons.camera, size: 20),
              title: const Text('Chụp ảnh mới', style: TextStyle(fontSize: 15)),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(LucideIcons.image, size: 20),
              title: const Text('Chọn từ thư viện ảnh', style: TextStyle(fontSize: 15)),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (source != null) {
      final picked = await picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        onChanged(picked.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hình ảnh & Chứng từ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSlot(
                context: context,
                label: 'Ảnh thiết bị',
                icon: LucideIcons.camera,
                imagePath: deviceImagePath,
                onTap: () => _pickImage(context, onDeviceImageChanged),
                onRemove: () => onDeviceImageChanged(null),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSlot(
                context: context,
                label: 'Hóa đơn',
                icon: LucideIcons.receipt,
                imagePath: receiptImagePath,
                onTap: () => _pickImage(context, onReceiptImageChanged),
                onRemove: () => onReceiptImageChanged(null),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSlot(
                context: context,
                label: 'Phiếu BH',
                icon: LucideIcons.fileText,
                imagePath: warrantyCardImagePath,
                onTap: () => _pickImage(context, onWarrantyCardImageChanged),
                onRemove: () => onWarrantyCardImageChanged(null),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlot({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String? imagePath,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = imagePath != null && imagePath.isNotEmpty;
    final isNetwork = hasImage && (imagePath.startsWith('http://') || imagePath.startsWith('https://'));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: hasImage
              ? null
              : (isDark ? Colors.grey.shade900 : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasImage
                ? AppColors.primary
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: hasImage ? 1.5 : 1.0,
          ),
        ),
        child: Stack(
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: isNetwork
                    ? Image.network(imagePath, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                    : Image.file(File(imagePath), fit: BoxFit.cover, width: double.infinity, height: double.infinity),
              )
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 22, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            if (hasImage)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
