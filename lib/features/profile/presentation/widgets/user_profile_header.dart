import 'package:flutter/material.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/auth/domain/entities/auth_user_entity.dart';

/// Widget Thẻ Header hiển thị Avatar và Tên Người dùng
class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({
    super.key,
    required this.user,
    required this.isAnonymous,
  });

  final AuthUserEntity? user;
  final bool isAnonymous;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fullName = user?.fullName ?? '';
    final email = user?.email ?? '';

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Text(
              (fullName.isNotEmpty ? fullName[0] : 'U').toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName.isNotEmpty ? fullName : 'Người dùng Khách',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 4),
                Text(
                  isAnonymous
                      ? 'Chế độ Khách (Chưa sao lưu)'
                      : (email.isNotEmpty ? email : 'Đã xác thực'),
                  style: TextStyle(
                    fontSize: 12,
                    color: isAnonymous
                        ? AppColors.warning
                        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                    fontWeight: isAnonymous ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
