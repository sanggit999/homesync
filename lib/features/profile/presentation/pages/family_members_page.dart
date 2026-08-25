import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/widgets/empty_state_widget.dart';
import 'package:home_sync/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:home_sync/features/profile/presentation/widgets/family_member_tile.dart';

/// Màn hình Quản lý Thành viên Gia Đình & Phân quyền
class FamilyMembersPage extends StatelessWidget {
  const FamilyMembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thành Viên Gia Đình'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.qrCode),
            tooltip: 'Mã QR chia sẻ',
            onPressed: () => context.push(AppRoutes.qrShare),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final members = state is ProfileLoaded ? state.members : [];

          if (members.isEmpty) {
            return EmptyStateWidget(
              icon: LucideIcons.users,
              title: 'Chưa có thành viên nào khác',
              subtitle: 'Chia sẻ mã QR để vợ/chồng hoặc người thân cùng quản lý thiết bị gia đình.',
              actionLabel: 'Mở mã QR chia sẻ',
              onAction: () => context.push(AppRoutes.qrShare),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return FamilyMemberTile(
                member: member,
                onRemove: () {
                  context.read<ProfileCubit>().removeMember(
                        homeId: member.homeId,
                        userId: member.userId,
                      );
                },
              );
            },
          );
        },
      ),
    );
  }
}
