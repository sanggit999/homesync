import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/core/widgets/empty_state_widget.dart';
import 'package:home_sync/core/widgets/smart_nudge_banner.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:home_sync/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:home_sync/features/dashboard/presentation/widgets/expiring_soon_carousel.dart';
import 'package:home_sync/features/dashboard/presentation/widgets/health_radar_card.dart';
import 'package:home_sync/features/dashboard/presentation/widgets/monthly_expense_card.dart';

/// Tab 1: Màn hình Tổng quan (Dashboard & Radar sức khỏe thiết bị)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final authState = context.watch<AuthCubit>().state;
    final isGuest = authState is Authenticated && authState.isAnonymous;
    final userName = authState is Authenticated
        ? (authState.user.fullName?.isNotEmpty == true ? authState.user.fullName! : 'Bạn')
        : 'Bạn';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào, $userName 👋',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Quản lý tài sản gia đình',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.fileSpreadsheet),
            tooltip: 'Báo cáo bảo hiểm PDF',
            onPressed: () => context.push(AppRoutes.pdfPreview),
          ),
          IconButton(
            icon: const Icon(LucideIcons.plusCircle),
            tooltip: 'Thêm thiết bị mới',
            onPressed: () => context.push(AppRoutes.itemsAdd),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<DashboardCubit>().refreshDashboard(),
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) => switch (state) {
            DashboardInitial() || DashboardLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            DashboardError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.alertTriangle, size: 48, color: AppColors.error),
                      const SizedBox(height: 12),
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<DashboardCubit>().loadDashboard(),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              ),
            DashboardLoaded(:final summary) => ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  // Smart Nudge Banner (Chỉ hiện khi Guest Mode)
                  if (isGuest)
                    SmartNudgeBanner(
                      onLinkPressed: () => context.read<AuthCubit>().linkWithGoogle(),
                    ),

                  // 1. Radar Sức Khỏe Thiết Bị
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: HealthRadarCard(summary: summary),
                  ),

                  // 2. Thống Kê Chi Tiêu Trong Tháng
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: MonthlyExpenseCard(totalSpentThisMonth: summary.totalSpentThisMonth),
                  ),

                  // 3. Danh Sách Thiết Bị Sắp Hết Hạn Bảo Hành
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cảnh Báo Sắp Hết Hạn ⚠️',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () => context.go('/items'),
                          child: const Text('Xem tất cả'),
                        ),
                      ],
                    ),
                  ),
                  ExpiringSoonCarousel(items: summary.expiringSoonItems),

                  // 4. Lịch Bảo Trì Sắp Tới
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lịch Bảo Trì Gần Nhất 🔧',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () => context.go('/maintenance'),
                          child: const Text('Xem lịch'),
                        ),
                      ],
                    ),
                  ),
                  if (summary.upcomingTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: EmptyStateWidget(
                        icon: LucideIcons.calendarCheck,
                        title: 'Chưa có lịch bảo trì',
                        subtitle: 'Tạo lịch nhắc nhở vệ sinh máy lạnh, thay lõi lọc nước định kỳ.',
                      ),
                    )
                  else
                    ...summary.upcomingTasks.take(3).map(
                          (task) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: AppCard(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(LucideIcons.wrench, size: 20, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.title,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        Text(
                                          task.itemName ?? 'Bảo trì định kỳ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd/MM').format(task.dueDate),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ],
              ),
          },
        ),
      ),
    );
  }
}
