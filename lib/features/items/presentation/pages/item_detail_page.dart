import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/utils/warranty_calculator.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/core/widgets/status_badge.dart';
import 'package:home_sync/core/widgets/warranty_progress_bar.dart';
import 'package:home_sync/features/items/presentation/cubit/item_form_cubit.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_cubit.dart';

/// Màn hình Chi Tiết Thiết Bị (Hotline, Serial No, Lịch sử bảo trì, Ảnh hóa đơn)
class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

    return BlocBuilder<ItemListCubit, ItemListState>(
      builder: (context, state) {
        if (state is! ItemListLoaded) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final item = state.items.where((i) => i.id == itemId).firstOrNull;
        if (item == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chi tiết thiết bị')),
            body: const Center(child: Text('Không tìm thấy thiết bị này')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(item.name),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.edit),
                tooltip: 'Chỉnh sửa',
                onPressed: () => context.push(AppRoutes.itemEditPath(itemId), extra: item),
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2, color: AppColors.error),
                tooltip: 'Xóa thiết bị',
                onPressed: () => _confirmDelete(context, item.name),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Warranty Status Hero Card
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusBadge.fromWarrantyStatus(
                          item.warrantyStatus,
                          item.warrantyStatus == WarrantyStatus.good
                              ? 'Còn bảo hành'
                              : item.warrantyStatus == WarrantyStatus.expiringSoon
                                  ? 'Sắp hết hạn bảo hành'
                                  : 'Đã hết hạn bảo hành',
                        ),
                        Text(
                          '${item.remainingDays > 0 ? item.remainingDays : 0} ngày còn lại',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    WarrantyProgressBar(
                      progress: item.warrantyProgress,
                      status: item.warrantyStatus,
                      height: 8,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ngày mua: ${DateFormat('dd/MM/yyyy').format(item.purchaseDate)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'Hết hạn: ${DateFormat('dd/MM/yyyy').format(item.warrantyExpiryDate)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Thông tin kỹ thuật & Hotline hãng
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin chi tiết',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(context, 'Hãng sản xuất', item.brand ?? '—'),
                    _buildInfoRow(context, 'Model', item.modelNumber ?? '—'),
                    _buildInfoRow(
                      context,
                      'Số Serial',
                      item.serialNumber ?? '—',
                      trailing: item.serialNumber != null
                          ? IconButton(
                              icon: const Icon(LucideIcons.copy, size: 16),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: item.serialNumber!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Đã sao chép số Serial')),
                                );
                              },
                            )
                          : null,
                    ),
                    _buildInfoRow(context, 'Vị trí / Phòng', item.location ?? '—'),
                    _buildInfoRow(context, 'Nơi mua hàng', item.storeName ?? '—'),
                    if (item.price != null)
                      _buildInfoRow(context, 'Giá tiền', currencyFormatter.format(item.price)),
                    if (item.supportPhone != null && item.supportPhone!.isNotEmpty)
                      _buildInfoRow(
                        context,
                        'Hotline bảo hành',
                        item.supportPhone!,
                        trailing: ElevatedButton.icon(
                          onPressed: () => launchUrl(Uri.parse('tel:${item.supportPhone}')),
                          icon: const Icon(LucideIcons.phoneCall, size: 14),
                          label: const Text('Gọi ngay', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Ảnh Hóa Đơn & Phiếu Bảo Hành (Zoom/Pan Viewer)
              if (item.receiptImageUrl != null || item.warrantyCardImageUrl != null)
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chứng từ & Hóa đơn đính kèm',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (item.receiptImageUrl != null)
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context.push(
                                  AppRoutes.receiptViewer,
                                  extra: item.receiptImageUrl,
                                ),
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                    image: DecorationImage(
                                      image: NetworkImage(item.receiptImageUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    color: Colors.black54,
                                    child: const Text(
                                      'Hóa đơn mua hàng',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (item.receiptImageUrl != null && item.warrantyCardImageUrl != null)
                            const SizedBox(width: 12),
                          if (item.warrantyCardImageUrl != null)
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context.push(
                                  AppRoutes.receiptViewer,
                                  extra: item.warrantyCardImageUrl,
                                ),
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                    image: DecorationImage(
                                      image: NetworkImage(item.warrantyCardImageUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    color: Colors.black54,
                                    child: const Text(
                                      'Phiếu bảo hành',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

              if (item.notes != null && item.notes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ghi chú',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.notes!,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {Widget? trailing}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String itemName) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa thiết bị "$itemName" khỏi hệ thống?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await context.read<ItemFormCubit>().deleteItem(itemId);
              if (context.mounted) {
                context.read<ItemListCubit>().loadItems();
                context.pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Xóa vĩnh viễn', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
