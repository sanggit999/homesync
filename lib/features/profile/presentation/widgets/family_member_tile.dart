import 'package:flutter/material.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/features/profile/domain/entities/home_member_entity.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Widget Thẻ hiển thị một thành viên gia đình trong nhà
class FamilyMemberTile extends StatelessWidget {
  const FamilyMemberTile({
    super.key,
    required this.member,
    required this.onRemove,
  });

  final HomeMemberEntity member;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: Text(
            (member.userFullName?.isNotEmpty == true
                    ? member.userFullName![0]
                    : 'U')
                .toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        title: Text(member.userFullName ?? 'Thành viên', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'Vai trò: ${member.role == 'owner' ? 'Chủ nhà' : member.role == 'editor' ? 'Chỉnh sửa' : 'Chỉ xem'}',
        ),
        trailing: member.role != 'owner'
            ? IconButton(
                icon: const Icon(LucideIcons.trash2, color: AppColors.error, size: 18),
                onPressed: onRemove,
              )
            : const Chip(label: Text('Chủ hộ', style: TextStyle(fontSize: 11))),
      ),
    );
  }
}
