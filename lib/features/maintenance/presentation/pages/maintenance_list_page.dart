import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/core/widgets/empty_state_widget.dart';
import 'package:home_sync/features/service_logs/presentation/cubit/service_log_cubit.dart';
import 'package:home_sync/features/maintenance/presentation/cubit/maintenance_cubit.dart';
import 'package:home_sync/core/utils/dialog_utils.dart';
import 'package:home_sync/features/maintenance/presentation/widgets/add_maintenance_dialog.dart';
import 'package:home_sync/features/maintenance/presentation/widgets/maintenance_task_card.dart';

/// Tab 3: Lịch bảo trì & Nhật ký chi phí sửa chữa
class MaintenanceListPage extends StatefulWidget {
  const MaintenanceListPage({super.key});

  @override
  State<MaintenanceListPage> createState() => _MaintenanceListPageState();
}

class _MaintenanceListPageState extends State<MaintenanceListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<MaintenanceCubit>().loadMaintenanceData();
    context.read<ServiceLogCubit>().loadLogs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảo trì & Sửa chữa'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Lịch bảo trì định kỳ', icon: Icon(LucideIcons.calendar, size: 18)),
            Tab(text: 'Nhật ký chi phí', icon: Icon(LucideIcons.receipt, size: 18)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'maintenance_list_fab',
        onPressed: () {
          if (_tabController.index == 0) {
            showAppDialog(
              context: context,
              builder: (ctx) => const AddMaintenanceDialog(),
            );
          } else {
            context.push(AppRoutes.maintenanceAddLog);
          }
        },
        icon: const Icon(LucideIcons.plus),
        label: Text(_tabController.index == 0 ? 'Thêm lịch bảo trì' : 'Thêm chi phí'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. TAB LỊCH BẢO TRÌ ĐỊNH KỲ
          RefreshIndicator(
            onRefresh: () => context.read<MaintenanceCubit>().loadMaintenanceData(),
            child: BlocBuilder<MaintenanceCubit, MaintenanceState>(
              builder: (context, state) => switch (state) {
                MaintenanceInitial() || MaintenanceLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                MaintenanceError(:final message) => Center(child: Text(message)),
                MaintenanceActionSuccess() => const Center(child: CircularProgressIndicator()),
                MaintenanceLoaded(:final tasks) => tasks.isEmpty
                    ? EmptyStateWidget(
                        icon: LucideIcons.calendarCheck,
                        title: 'Chưa có lịch bảo trì nào',
                        subtitle: 'Tạo lịch nhắc nhở vệ sinh máy lạnh, thay lõi lọc nước, bảo dưỡng xe.',
                        actionLabel: 'Thêm lịch bảo trì',
                        onAction: () => showAppDialog(
                          context: context,
                          builder: (ctx) => const AddMaintenanceDialog(),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return MaintenanceTaskCard(
                            task: task,
                            onComplete: () => _confirmCompleteTask(context, task.id, task.title),
                          );
                        },
                      ),
              },
            ),
          ),

          // 2. TAB NHẬT KÝ CHI PHÍ SỬA CHỮA
          RefreshIndicator(
            onRefresh: () => context.read<ServiceLogCubit>().loadLogs(),
            child: BlocBuilder<ServiceLogCubit, ServiceLogState>(
              builder: (context, state) => switch (state) {
                ServiceLogInitial() || ServiceLogLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ServiceLogError(:final message) => Center(child: Text(message)),
                ServiceLogLoaded(:final logs, :final totalCostThisMonth, :final totalCostAllTime) => logs.isEmpty
                    ? EmptyStateWidget(
                        icon: LucideIcons.receipt,
                        title: 'Chưa có nhật ký chi phí',
                        subtitle: 'Ghi nhận chi phí sửa chữa, thay linh kiện máy móc để theo dõi ngân sách.',
                        actionLabel: 'Ghi nhận chi phí',
                        onAction: () => context.push(AppRoutes.maintenanceAddLog),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                        children: [
                          AppCard(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Tháng này', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                      Text(
                                        currencyFormatter.format(totalCostThisMonth),
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(width: 1, height: 36, color: AppColors.border),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Tổng chi tiêu', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                      Text(
                                        currencyFormatter.format(totalCostAllTime),
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...logs.map(
                            (log) => AppCard(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(LucideIcons.wrench, size: 20, color: Colors.blueGrey),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(log.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        Text(
                                          '${log.itemName ?? 'Thiết bị'} • ${DateFormat('dd/MM/yyyy').format(log.serviceDate)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    currencyFormatter.format(log.cost),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCompleteTask(BuildContext context, String taskId, String title) {
    final costController = TextEditingController();

    showAppDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Hoàn Thành Bảo Trì'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn đã hoàn thành công việc: "$title"?'),
            const SizedBox(height: 12),
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Chi phí phát sinh (nếu có)',
                prefixText: '₫ ',
                hintText: '0',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final cost = double.tryParse(costController.text.replaceAll(',', '').replaceAll('.', '')) ?? 0.0;
              context.read<MaintenanceCubit>().completeTask(
                    CompleteTaskParams(
                      taskId: taskId,
                      completedDate: DateTime.now(),
                      cost: cost,
                    ),
                  );
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã cập nhật hoàn thành & lưu nhật ký chi phí!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
            child: const Text('Xác nhận xong'),
          ),
        ],
      ),
    );
  }
}
