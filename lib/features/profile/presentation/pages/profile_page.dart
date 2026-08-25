import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:home_sync/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:home_sync/core/utils/dialog_utils.dart';
import 'package:home_sync/features/profile/presentation/widgets/user_profile_header.dart';

/// Tab 4: Màn hình Cá nhân & Cài đặt
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isAnonymous = authState is Authenticated && authState.isAnonymous;
    final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cá nhân & Cài đặt'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. User Profile Header
          UserProfileHeader(user: user, isAnonymous: isAnonymous),

          // 2. Nút "Liên kết với Google để lưu Cloud" (khi ở Guest Mode)
          if (isAnonymous) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => context.read<AuthCubit>().linkWithGoogle(),
              icon: const Icon(LucideIcons.uploadCloud, size: 20),
              label: const Text('Liên kết Google để lưu trữ vĩnh viễn'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // 3. Nhóm Tính Năng Gia Đình & Báo Cáo
          const Text('Tiện ích & Gia đình', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(LucideIcons.fileSpreadsheet, color: AppColors.primary),
                  title: const Text('Xuất Báo Cáo PDF Bảo Hiểm'),
                  subtitle: const Text('Tạo file hồ sơ tài sản & hóa đơn chuẩn bảo hiểm'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.pdfPreview),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(LucideIcons.users, color: AppColors.primary),
                  title: const Text('Thành Viên Gia Đình'),
                  subtitle: const Text('Quản lý phân quyền vợ/chồng cùng xem thiết bị'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.familyMembers),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(LucideIcons.qrCode, color: AppColors.primary),
                  title: const Text('Mã QR Chia Sẻ Nhà'),
                  subtitle: const Text('Quét mã nhanh để tham gia quản lý nhà'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.qrShare),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4. Cài Đặt Thông Báo & Ứng Dụng
          const Text('Cài đặt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(LucideIcons.bell, color: AppColors.primary),
                  title: const Text('Thông báo bảo hành & bảo trì'),
                  subtitle: const Text('Nhắc trước hạn 7, 14, 30 ngày qua OneSignal'),
                  trailing: Switch(
                    value: true,
                    onChanged: (val) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã cập nhật cài đặt thông báo')),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(LucideIcons.info, color: AppColors.primary),
                  title: const Text('Phiên bản ứng dụng'),
                  trailing: const Text('v1.0.0 (Clean Architecture)', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 5. Nút Đăng Xuất / Xóa dữ liệu dùng thử
          OutlinedButton.icon(
            onPressed: () => _confirmSignOut(context, isAnonymous),
            icon: Icon(
              isAnonymous ? LucideIcons.trash2 : LucideIcons.logOut,
              size: 18,
              color: AppColors.error,
            ),
            label: Text(
              isAnonymous ? 'Xóa dữ liệu dùng thử' : 'Đăng xuất',
              style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: AppColors.error, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context, bool isAnonymous) {
    showAppDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isAnonymous ? LucideIcons.alertTriangle : LucideIcons.logOut,
              color: AppColors.error,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isAnonymous ? 'CẢNH BÁO MẤT DỮ LIỆU' : 'Xác nhận đăng xuất',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          isAnonymous
              ? 'Bạn đang sử dụng chế độ Khách (Guest Mode).\n\nNếu đăng xuất, toàn bộ thiết bị và hóa đơn bảo hành đã tạo sẽ BỊ XÓA VĨNH VIỄN khỏi máy này và không thể khôi phục.\n\nHãy liên kết tài khoản Google để bảo lưu dữ liệu.'
              : 'Bạn có chắc chắn muốn đăng xuất khỏi HomeSync?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          if (isAnonymous)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<AuthCubit>().linkWithGoogle();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Liên kết Google ngay'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().signOut();
              context.go(AppRoutes.welcome);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isAnonymous ? Colors.grey : AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(isAnonymous ? 'Vẫn đăng xuất (Xóa hết)' : 'Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
