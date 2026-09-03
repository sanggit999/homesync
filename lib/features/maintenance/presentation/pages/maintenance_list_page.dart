import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/utils/snackbar_utils.dart';
import 'package:home_sync/core/widgets/app_card.dart';
import 'package:home_sync/core/widgets/empty_state_widget.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';
import 'package:home_sync/features/maintenance/presentation/cubit/maintenance_cubit.dart';
import 'package:home_sync/features/maintenance/presentation/widgets/cancel_maintenance_dialog.dart';
import 'package:home_sync/features/maintenance/presentation/widgets/complete_maintenance_bottom_sheet.dart';
import 'package:home_sync/features/maintenance/presentation/widgets/maintenance_segmented_tabs.dart';
import 'package:home_sync/features/maintenance/presentation/widgets/maintenance_task_card.dart';
import 'package:home_sync/features/maintenance/presentation/widgets/maintenance_task_skeleton.dart';
import 'package:home_sync/features/maintenance/presentation/widgets/reschedule_maintenance_dialog.dart';
import 'package:home_sync/features/service_logs/domain/entities/service_log_entity.dart';
import 'package:home_sync/features/service_logs/presentation/cubit/service_log_cubit.dart';
import 'package:home_sync/features/service_logs/presentation/widgets/service_log_card.dart';
import 'package:home_sync/features/service_logs/presentation/widgets/service_log_skeleton.dart';

/// Tab 3: Phân Hệ Quản Lý Bảo Trì & Sổ Cái Chi Phí Tự Động (Apple Style Refactored)
class MaintenanceListPage extends StatefulWidget {
  const MaintenanceListPage({super.key});

  @override
  State<MaintenanceListPage> createState() => _MaintenanceListPageState();
}

class _MaintenanceListPageState extends State<MaintenanceListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Search & Filter state cho Tab 1 (Lịch bảo trì)
  final _taskSearchController = TextEditingController();
  String _taskSearchQuery = '';
  String _taskStatusFilter = 'all'; // 'all', 'overdue', 'due_soon', 'good'

  // Search & Filter state cho Tab 2 (Nhật ký chi phí / Sổ cái)
  final _logSearchController = TextEditingController();
  String _logSearchQuery = '';
  String _logTypeFilter = 'all'; // 'all', 'maintenance', 'repair', 'receipt'
  String _selectedMonthYear = 'all'; // 'all' hoặc 'MM/yyyy'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    context.read<MaintenanceCubit>().loadMaintenanceData();
    context.read<ServiceLogCubit>().loadLogs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskSearchController.dispose();
    _logSearchController.dispose();
    super.dispose();
  }

  void _confirmDeleteTask(BuildContext context, String taskId, String title) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(LucideIcons.alertTriangle, color: AppColors.error, size: 22),
            SizedBox(width: 8),
            Text('Xóa Lịch Bảo Trì', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa lịch bảo trì "$title"?\n\nLưu ý: Lịch sử các lần hoàn thành và chi phí trong quá khứ ở Tab Nhật Ký vẫn được bảo toàn nguyên vẹn 100%.',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MaintenanceCubit>().deleteTask(taskId);
              Navigator.pop(dialogCtx);
              AppSnackBar.showSuccess(context, 'Đã xóa lịch bảo trì thành công.');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Xóa ngay'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteLog(BuildContext context, ServiceLogEntity log) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(LucideIcons.alertTriangle, color: AppColors.error, size: 22),
            SizedBox(width: 8),
            Text('Xóa Nhật Ký Chi Phí', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Bạn có chắc muốn xóa bản ghi "${log.title}" (${NumberFormat('#,###', 'vi_VN').format(log.cost)} ₫)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ServiceLogCubit>().deleteLog(log.id);
              Navigator.pop(dialogCtx);
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

    // Đếm số lượng việc cần chú ý cho Badge của TabBar
    final maintenanceState = context.watch<MaintenanceCubit>().state;
    final allTasks = maintenanceState is MaintenanceLoaded ? maintenanceState.tasks : <MaintenanceTaskEntity>[];
    final overdueCount = allTasks.where((t) => t.isOverdue).length;
    final dueSoonCount = allTasks.where((t) => t.isDueSoon && !t.isOverdue).length;
    final urgentTasksCount = overdueCount + dueSoonCount;

    final serviceLogState = context.watch<ServiceLogCubit>().state;
    final allLogs = serviceLogState is ServiceLogLoaded ? serviceLogState.logs : <ServiceLogEntity>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảo trì & Sửa chữa', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: MaintenanceSegmentedTabs(
          tabController: _tabController,
          tasksBadgeCount: urgentTasksCount,
          logsCount: allLogs.length,
        ),
      ),
      // Cố định FloatingActionButton: Single Source of Truth
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'maintenance_list_fab',
        onPressed: () => context.push(AppRoutes.maintenanceAdd),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Thêm lịch bảo trì'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ==========================================
          // 1. TAB LỊCH BẢO TRÌ ĐỊNH KỲ (Proactive)
          // ==========================================
          _buildMaintenanceTasksTab(isDark, allTasks, overdueCount, dueSoonCount),

          // ==========================================
          // 2. TAB NHẬT KÝ CHI PHÍ SỬA CHỮA (Audit Ledger)
          // ==========================================
          _buildServiceLogsTab(isDark, serviceLogState, allLogs),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 1 VIEW: LỊCH BẢO TRÌ ĐỊNH KỲ
  // -------------------------------------------------------------
  Widget _buildMaintenanceTasksTab(
    bool isDark,
    List<MaintenanceTaskEntity> allTasks,
    int overdueCount,
    int dueSoonCount,
  ) {
    // Lọc danh sách theo Search query & Status filter
    final filteredTasks = allTasks.where((t) {
      if (_taskSearchQuery.isNotEmpty) {
        final query = _taskSearchQuery.toLowerCase();
        final matchTitle = t.title.toLowerCase().contains(query);
        final matchItem = (t.itemName ?? '').toLowerCase().contains(query);
        if (!matchTitle && !matchItem) return false;
      }

      if (_taskStatusFilter == 'overdue') return t.isOverdue;
      if (_taskStatusFilter == 'due_soon') return t.isDueSoon && !t.isOverdue;
      if (_taskStatusFilter == 'good') return !t.isOverdue && !t.isDueSoon;

      return true;
    }).toList();

    final goodConditionCount = allTasks.length - overdueCount - dueSoonCount;

    return RefreshIndicator(
      onRefresh: () => context.read<MaintenanceCubit>().loadMaintenanceData(),
      child: Column(
        children: [
          // 1.1. Status Metric Chips (Quá hạn 🔴, Sắp đến 🟡, Chu kỳ tốt 🟢)
          if (allTasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              child: Row(
                children: [
                  _buildStatusFilterChip(
                    id: 'overdue',
                    label: 'Quá hạn',
                    count: overdueCount,
                    color: AppColors.error,
                    icon: LucideIcons.alertCircle,
                  ),
                  const SizedBox(width: 8),
                  _buildStatusFilterChip(
                    id: 'due_soon',
                    label: 'Sắp tới hạn',
                    count: dueSoonCount,
                    color: Colors.orange,
                    icon: LucideIcons.clock,
                  ),
                  const SizedBox(width: 8),
                  _buildStatusFilterChip(
                    id: 'good',
                    label: 'Còn hạn tốt',
                    count: goodConditionCount > 0 ? goodConditionCount : 0,
                    color: AppColors.success,
                    icon: LucideIcons.checkCircle2,
                  ),
                ],
              ),
            ),

          // 1.2. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
            child: TextField(
              controller: _taskSearchController,
              onChanged: (val) => setState(() => _taskSearchQuery = val.trim()),
              decoration: InputDecoration(
                hintText: 'Tìm công việc, thiết bị...',
                prefixIcon: const Icon(LucideIcons.search, size: 18),
                suffixIcon: _taskSearchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () {
                          _taskSearchController.clear();
                          setState(() => _taskSearchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : const Color(0xFFF2F3F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 1.3. Task List Content
          Expanded(
            child: BlocBuilder<MaintenanceCubit, MaintenanceState>(
              builder: (context, state) => switch (state) {
                MaintenanceInitial() || MaintenanceLoading() => const MaintenanceSkeletonView(),
                MaintenanceError(:final message) => Center(child: Text(message)),
                MaintenanceActionSuccess() => const MaintenanceSkeletonView(),
                MaintenanceLoaded() => filteredTasks.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 40),
                          EmptyStateWidget(
                            icon: LucideIcons.calendarCheck,
                            title: _taskSearchQuery.isNotEmpty || _taskStatusFilter != 'all'
                                ? 'Không tìm thấy lịch phù hợp'
                                : 'Chưa có lịch bảo trì nào',
                            subtitle: _taskSearchQuery.isNotEmpty || _taskStatusFilter != 'all'
                                ? 'Hãy thử tìm với từ khóa khác hoặc xóa bộ lọc trạng thái.'
                                : 'Tạo lịch nhắc nhở định kỳ vệ sinh máy lạnh, thay lõi lọc nước, bảo dưỡng xe.',
                            actionLabel: _taskSearchQuery.isNotEmpty || _taskStatusFilter != 'all'
                                ? 'Xem tất cả lịch'
                                : 'Thêm lịch bảo trì',
                            onAction: () {
                              if (_taskSearchQuery.isNotEmpty || _taskStatusFilter != 'all') {
                                _taskSearchController.clear();
                                setState(() {
                                  _taskSearchQuery = '';
                                  _taskStatusFilter = 'all';
                                });
                              } else {
                                context.push(AppRoutes.maintenanceAdd);
                              }
                            },
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return MaintenanceTaskCard(
                            task: task,
                            onComplete: () => CompleteMaintenanceBottomSheet.show(context, task),
                            onReschedule: () => RescheduleMaintenanceDialog.show(context, task),
                            onCancel: () => CancelMaintenanceDialog.show(context, task),
                            onDelete: () => _confirmDeleteTask(context, task.id, task.title),
                          );
                        },
                      ),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilterChip({
    required String id,
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    final isSelected = _taskStatusFilter == id;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _taskStatusFilter = isSelected ? 'all' : id;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : (isDark ? const Color(0xFF242428) : Colors.white),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06)),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 13, color: color),
                  const SizedBox(width: 4),
                  Text(
                    '$count',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? color : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 2 VIEW: NHẬT KÝ CHI PHÍ SỬA CHỮA (Audit Ledger & Point-in-Time)
  // -------------------------------------------------------------
  Widget _buildServiceLogsTab(
    bool isDark,
    ServiceLogState serviceLogState,
    List<ServiceLogEntity> allLogs,
  ) {
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

    // Trích xuất danh sách Tháng/Năm có dữ liệu để phục vụ bộ lọc Point-in-time
    final availableMonths = <String>{};
    for (final log in allLogs) {
      availableMonths.add(DateFormat('MM/yyyy').format(log.serviceDate));
    }
    final sortedMonths = availableMonths.toList()..sort((a, b) => b.compareTo(a));

    // Lọc danh sách Service Logs theo Search, Type và Month/Year
    final filteredLogs = allLogs.where((log) {
      if (_logSearchQuery.isNotEmpty) {
        final query = _logSearchQuery.toLowerCase();
        final matchTitle = log.title.toLowerCase().contains(query);
        final matchItem = (log.itemName ?? '').toLowerCase().contains(query);
        final matchTech = (log.technicianName ?? '').toLowerCase().contains(query);
        if (!matchTitle && !matchItem && !matchTech) return false;
      }

      if (_selectedMonthYear != 'all') {
        final logMonthYear = DateFormat('MM/yyyy').format(log.serviceDate);
        if (logMonthYear != _selectedMonthYear) return false;
      }

      if (_logTypeFilter == 'maintenance') return log.serviceType == 'maintenance';
      if (_logTypeFilter == 'repair') return log.serviceType == 'repair';
      if (_logTypeFilter == 'receipt') {
        return log.receiptImageUrl != null && log.receiptImageUrl!.isNotEmpty;
      }

      return true;
    }).toList();

    // Tính tổng chi phí cho tập dữ liệu đang được lọc
    final filteredTotalCost = filteredLogs.fold<double>(0.0, (sum, item) => sum + item.cost);

    return RefreshIndicator(
      onRefresh: () => context.read<ServiceLogCubit>().loadLogs(),
      child: BlocBuilder<ServiceLogCubit, ServiceLogState>(
        builder: (context, state) => switch (state) {
          ServiceLogInitial() || ServiceLogLoading() => const ServiceLogSkeletonView(),
          ServiceLogError(:final message) => Center(child: Text(message)),
          ServiceLogLoaded(:final totalCostThisMonth, :final totalCostAllTime) => Column(
              children: [
                // 2.1. Financial Overview Banner (Apple Card Style)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedMonthYear == 'all' ? 'Tháng này' : 'Kỳ $_selectedMonthYear',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currencyFormatter.format(_selectedMonthYear == 'all' ? totalCostThisMonth : filteredTotalCost),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 36, color: isDark ? Colors.white12 : AppColors.border),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tổng chi tiêu', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Text(
                                currencyFormatter.format(totalCostAllTime),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 36, color: isDark ? Colors.white12 : AppColors.border),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Số lần', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Text(
                              '${filteredLogs.length}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 2.2. Bộ lọc Tháng / Năm (Point-in-Time Snapshot)
                if (sortedMonths.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Toàn thời gian'),
                            selected: _selectedMonthYear == 'all',
                            onSelected: (_) => setState(() => _selectedMonthYear = 'all'),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              fontSize: 11.5,
                              fontWeight: _selectedMonthYear == 'all' ? FontWeight.bold : FontWeight.normal,
                              color: _selectedMonthYear == 'all' ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                          const SizedBox(width: 6),
                          ...sortedMonths.map((m) {
                            final isSelected = _selectedMonthYear == m;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: ChoiceChip(
                                label: Text('Tháng $m'),
                                selected: isSelected,
                                onSelected: (_) => setState(() => _selectedMonthYear = m),
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                // 2.3. Filter Chips theo Loại dịch vụ
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildLogTypeChip('all', 'Tất cả (${filteredLogs.length})'),
                        const SizedBox(width: 8),
                        _buildLogTypeChip('maintenance', 'Bảo dưỡng 🔧'),
                        const SizedBox(width: 8),
                        _buildLogTypeChip('repair', 'Sửa chữa ⚠️'),
                        const SizedBox(width: 8),
                        _buildLogTypeChip('receipt', 'Có hóa đơn 🧾'),
                      ],
                    ),
                  ),
                ),

                // 2.4. Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
                  child: TextField(
                    controller: _logSearchController,
                    onChanged: (val) => setState(() => _logSearchQuery = val.trim()),
                    decoration: InputDecoration(
                      hintText: 'Tìm nội dung sửa chữa, thợ, máy...',
                      prefixIcon: const Icon(LucideIcons.search, size: 18),
                      suffixIcon: _logSearchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () {
                                _logSearchController.clear();
                                setState(() => _logSearchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurface : const Color(0xFFF2F3F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 2.5. Logs List: Gom nhóm theo Tháng & Năm (Section Grouping)
                Expanded(
                  child: filteredLogs.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(height: 40),
                            EmptyStateWidget(
                              icon: LucideIcons.receipt,
                              title: _logSearchQuery.isNotEmpty || _logTypeFilter != 'all' || _selectedMonthYear != 'all'
                                  ? 'Không tìm thấy nhật ký phù hợp'
                                  : 'Chưa có lịch sử bảo dưỡng nào',
                              subtitle: _logSearchQuery.isNotEmpty || _logTypeFilter != 'all' || _selectedMonthYear != 'all'
                                  ? 'Hãy thử tìm với từ khóa khác hoặc chuyển sang mốc thời gian khác.'
                                  : 'Khi bạn hoàn thành các công việc ở tab Lịch bảo trì, chi phí và vết lịch sử thực tế sẽ tự động lưu vào đây.',
                              actionLabel: _logSearchQuery.isNotEmpty || _logTypeFilter != 'all' || _selectedMonthYear != 'all'
                                  ? 'Xem tất cả'
                                  : 'Xem việc cần làm',
                              onAction: () {
                                if (_logSearchQuery.isNotEmpty || _logTypeFilter != 'all' || _selectedMonthYear != 'all') {
                                  _logSearchController.clear();
                                  setState(() {
                                    _logSearchQuery = '';
                                    _logTypeFilter = 'all';
                                    _selectedMonthYear = 'all';
                                  });
                                } else {
                                  _tabController.animateTo(0);
                                }
                              },
                            ),
                          ],
                        )
                      : _buildGroupedLogsList(filteredLogs, isDark, currencyFormatter),
                ),
              ],
            ),
        },
      ),
    );
  }

  Widget _buildGroupedLogsList(
    List<ServiceLogEntity> logs,
    bool isDark,
    NumberFormat currencyFormatter,
  ) {
    // Gom nhóm bản ghi theo Tháng/Năm
    final grouped = <String, List<ServiceLogEntity>>{};
    for (final log in logs) {
      final key = DateFormat('MM/yyyy').format(log.serviceDate);
      grouped.putIfAbsent(key, () => []).add(log);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: sortedKeys.length,
      itemBuilder: (context, sectionIndex) {
        final monthKey = sortedKeys[sectionIndex];
        final sectionLogs = grouped[monthKey]!;
        final sectionTotal = sectionLogs.fold<double>(0.0, (sum, item) => sum + item.cost);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header: Tháng MM/yyyy • X lần • Tổng chi phí
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
              child: Row(
                children: [
                  const Icon(LucideIcons.calendar, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'THÁNG $monthKey',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${sectionLogs.length} lần • ${currencyFormatter.format(sectionTotal)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Các thẻ trong tháng
            ...sectionLogs.map(
              (log) => ServiceLogCard(
                log: log,
                onDelete: () => _confirmDeleteLog(context, log),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogTypeChip(String id, String label) {
    final isSelected = _logTypeFilter == id;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _logTypeFilter = id),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
      ),
    );
  }
}
