import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:home_sync/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Màn hình Sinh mã QR & Mã Mời Chia Sẻ Nhà cho Thành Viên Gia Đình
class QrSharePage extends StatelessWidget {
  const QrSharePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : 'homesync-guest';

    final profileState = context.watch<ProfileCubit>().state;
    final homes = profileState is ProfileLoaded ? profileState.homes : [];
    final home = homes.firstOrNull;
    final homeId = home?.id ?? 'home-$userId';
    final homeName = home?.name ?? 'Ngôi nhà của tôi';

    final invitePayload = 'homesync://join-home?homeId=$homeId&inviterId=$userId';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mã QR Chia Sẻ Nhà'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.home, color: AppColors.primary, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  homeName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quét mã này để đồng bộ và cùng quản lý thiết bị',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // QR Code Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                  child: QrImageView(
                    data: invitePayload,
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Mã mời text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Mã mời: ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Expanded(
                        child: Text(
                          homeId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.copy, size: 16),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: homeId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã sao chép mã mời')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Lưu ý: Người thân quét mã QR này từ ứng dụng HomeSync sẽ được cấp quyền xem toàn bộ danh mục thiết bị và lịch bảo trì của nhà này.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
