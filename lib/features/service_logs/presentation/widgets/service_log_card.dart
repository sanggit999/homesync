import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/service_logs/domain/entities/service_log_entity.dart';
import 'package:home_sync/features/service_logs/presentation/widgets/service_log_detail_bottom_sheet.dart';

/// Thẻ hiển thị một bản ghi chi phí sửa chữa / bảo dưỡng (Đồng bộ phong cách ItemCard)
class ServiceLogCard extends StatelessWidget {
  const ServiceLogCard({
    super.key,
    required this.log,
    this.onDelete,
  });

  final ServiceLogEntity log;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    final isMaintenance = log.serviceType == 'maintenance';
    final isCancelled = log.serviceType == 'cancelled';
    final hasReceipt = log.receiptImageUrl != null && log.receiptImageUrl!.isNotEmpty;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: InkWell(
        onTap: () => ServiceLogDetailBottomSheet.show(context, log),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon phân loại dịch vụ
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isCancelled
                        ? Colors.grey.withValues(alpha: 0.15)
                        : (isMaintenance
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : Colors.orange.withValues(alpha: 0.12)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCancelled
                        ? LucideIcons.calendarOff
                        : (isMaintenance ? LucideIcons.wrench : LucideIcons.alertTriangle),
                    size: 20,
                    color: isCancelled
                        ? Colors.grey
                        : (isMaintenance ? AppColors.primary : Colors.orange),
                  ),
                ),
                const SizedBox(width: 12),

                // Nội dung chính
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          decoration: isCancelled ? TextDecoration.lineThrough : null,
                          color: isCancelled ? (isDark ? Colors.white60 : Colors.black54) : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${log.itemName ?? 'Thiết bị gia đình'} • ${DateFormat('dd/MM/yyyy').format(log.serviceDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Dải Tag: Loại dịch vụ & Hóa đơn đính kèm
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: isCancelled
                                  ? Colors.grey.withValues(alpha: 0.12)
                                  : (isMaintenance
                                      ? AppColors.primary.withValues(alpha: 0.08)
                                      : Colors.orange.withValues(alpha: 0.08)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isCancelled
                                  ? 'Đã bỏ qua'
                                  : (isMaintenance ? 'Bảo dưỡng' : 'Sửa chữa'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isCancelled
                                    ? Colors.grey
                                    : (isMaintenance ? AppColors.primary : Colors.orange),
                              ),
                            ),
                          ),
                          if (hasReceipt) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LucideIcons.receipt, size: 11, color: AppColors.success),
                                  SizedBox(width: 3),
                                  Text(
                                    'Có hóa đơn',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Giá tiền nổi bật
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isCancelled ? '0 ₫' : currencyFormatter.format(log.cost),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isCancelled ? Colors.grey : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PopupMenuButton<String>(
                      icon: const Icon(LucideIcons.moreHorizontal, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onSelected: (action) {
                        if (action == 'detail') {
                          ServiceLogDetailBottomSheet.show(context, log);
                        } else if (action == 'call' && log.technicianPhone != null) {
                          launchUrl(Uri.parse('tel:${log.technicianPhone}'));
                        } else if (action == 'delete') {
                          onDelete?.call();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'detail',
                          child: Row(
                            children: [
                              Icon(LucideIcons.eye, size: 16, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text('Xem chi tiết', style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                        if (log.technicianPhone != null && log.technicianPhone!.isNotEmpty)
                          PopupMenuItem(
                            value: 'call',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.phone, size: 16, color: AppColors.success),
                                const SizedBox(width: 8),
                                Text('Gọi ${log.technicianPhone}', style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(LucideIcons.trash2, size: 16, color: AppColors.error),
                              SizedBox(width: 8),
                              Text('Xóa bản ghi', style: TextStyle(fontSize: 13, color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
