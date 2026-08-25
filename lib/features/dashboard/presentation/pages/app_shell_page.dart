import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';

/// Khung điều hướng chính (4 Tabs Bottom Navigation Bar)
class AppShellPage extends StatelessWidget {
  const AppShellPage({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.15),
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(LucideIcons.home),
              selectedIcon: Icon(LucideIcons.home, color: AppColors.primary),
              label: 'Tổng quan',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.layers),
              selectedIcon: Icon(LucideIcons.layers, color: AppColors.primary),
              label: 'Thiết bị',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.wrench),
              selectedIcon: Icon(LucideIcons.wrench, color: AppColors.primary),
              label: 'Bảo trì',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.user),
              selectedIcon: Icon(LucideIcons.user, color: AppColors.primary),
              label: 'Cá nhân',
            ),
          ],
        ),
      ),
    );
  }
}
