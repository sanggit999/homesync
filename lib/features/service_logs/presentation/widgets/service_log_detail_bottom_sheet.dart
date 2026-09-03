import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/utils/snackbar_utils.dart';
import 'package:home_sync/features/service_logs/domain/entities/service_log_entity.dart';
import 'package:home_sync/features/service_logs/presentation/cubit/service_log_cubit.dart';

/// Modal BottomSheet chuẩn phong cách Apple hiển thị chi tiết hóa đơn & lịch sử sửa chữa
class ServiceLogDetailBottomSheet extends StatelessWidget {
  const ServiceLogDetailBottomSheet({
    super.key,
    required this.log,
  });

  final ServiceLogEntity log;

  static Future<void> show(BuildContext context, ServiceLogEntity log) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ServiceLogDetailBottomSheet(log: log),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(LucideIcons.alertTriangle, color: AppColors.error, size: 22),
            SizedBox(width: 8),
            Text('Xóa Bản Ghi Chi Phí', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Bạn có chắc chắn muốn xóa bản ghi chi phí "${log.title}" (${NumberFormat('#,###', 'vi_VN').format(log.cost)} ₫)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ServiceLogCubit>().deleteLog(log.id);
              Navigator.pop(dialogCtx); // Đóng dialog
              Navigator.pop(context); // Đóng bottom sheet
              AppSnackBar.showSuccess(context, 'Đã xóa bản ghi chi phí thành công.');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Xóa ngay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    final isMaintenance = log.serviceType == 'maintenance';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E22) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh kéo grabber chuẩn iOS
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

            // Tiêu đề & Loại dịch vụ
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMaintenance
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : Colors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isMaintenance ? LucideIcons.wrench : LucideIcons.alertTriangle,
                    color: isMaintenance ? AppColors.primary : Colors.orange,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isMaintenance
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isMaintenance ? 'Bảo dưỡng định kỳ' : 'Sửa chữa hỏng hóc',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isMaintenance ? AppColors.primary : Colors.orange,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('dd/MM/yyyy').format(log.serviceDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Khung số tiền nổi bật
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C30) : const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tổng chi phí thực tế', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormatter.format(log.cost),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Chi tiết thiết bị liên quan
            _buildInfoRow(
              icon: LucideIcons.box,
              label: 'Thiết bị liên quan',
              value: log.itemName ?? 'Thiết bị gia đình',
              trailing: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.itemDetailPath(log.itemId));
                },
                child: const Text('Xem máy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),

            // Thợ & Đơn vị bảo dưỡng
            if (log.technicianName != null || log.technicianPhone != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                icon: LucideIcons.userCheck,
                label: 'Thợ / Trạm dịch vụ',
                value: log.technicianName ?? 'Thợ sửa chữa',
                trailing: (log.technicianPhone != null && log.technicianPhone!.isNotEmpty)
                    ? ElevatedButton.icon(
                        onPressed: () => launchUrl(Uri.parse('tel:${log.technicianPhone}')),
                        icon: const Icon(LucideIcons.phone, size: 14),
                        label: Text(log.technicianPhone!, style: const TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      )
                    : null,
              ),
            ],

            // Ghi chú công việc
            if (log.notes != null && log.notes!.isNotEmpty) ...[
              const Divider(height: 24),
              _buildInfoRow(
                icon: LucideIcons.fileText,
                label: 'Ghi chú & Phụ tùng thay thế',
                value: log.notes!,
              ),
            ],

            // Ảnh hóa đơn / phiếu thu
            if (log.receiptImageUrl != null && log.receiptImageUrl!.isNotEmpty) ...[
              const Divider(height: 24),
              const Text('Hóa đơn / Phiếu bảo hành đính kèm', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => context.push(AppRoutes.receiptViewer, extra: log.receiptImageUrl),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                    image: DecorationImage(
                      image: NetworkImage(log.receiptImageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.maximize2, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text('Xem ảnh lớn', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 28),

            // Nút bấm hành động
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(LucideIcons.trash2, size: 16, color: AppColors.error),
                    label: const Text('Xóa bản ghi', style: TextStyle(color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Đóng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
