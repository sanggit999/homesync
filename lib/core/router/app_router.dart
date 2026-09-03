import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:home_sync/core/router/app_routes.dart';
export 'app_routes.dart';

// Pages
import 'package:home_sync/features/auth/presentation/pages/splash_page.dart';
import 'package:home_sync/features/auth/presentation/pages/auth_welcome_page.dart';
import 'package:home_sync/features/dashboard/presentation/pages/app_shell_page.dart';
import 'package:home_sync/features/dashboard/presentation/pages/home_page.dart';
import 'package:home_sync/features/dashboard/presentation/pages/pdf_preview_page.dart';
import 'package:home_sync/features/items/domain/entities/item_entity.dart';
import 'package:home_sync/features/items/presentation/pages/add_edit_item_page.dart';
import 'package:home_sync/features/items/presentation/pages/item_detail_page.dart';
import 'package:home_sync/features/items/presentation/pages/item_list_page.dart';
import 'package:home_sync/features/items/presentation/pages/receipt_viewer_page.dart';
import 'package:home_sync/features/maintenance/domain/entities/maintenance_task_entity.dart';
import 'package:home_sync/features/maintenance/presentation/pages/add_edit_maintenance_page.dart';
import 'package:home_sync/features/maintenance/presentation/pages/maintenance_detail_page.dart';
import 'package:home_sync/features/maintenance/presentation/pages/maintenance_list_page.dart';
import 'package:home_sync/features/profile/presentation/pages/family_members_page.dart';
import 'package:home_sync/features/profile/presentation/pages/profile_page.dart';
import 'package:home_sync/features/profile/presentation/pages/qr_share_page.dart';
import 'package:home_sync/features/service_logs/presentation/pages/add_service_log_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Cấu hình Điều Hướng Chuẩn Declarative Routing (GoRouter 4 Tabs StatefulShellRoute)
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    // 0. Splash Screen
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),

    // 1. Auth Welcome Page (Guest + Google Sign-In)
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const AuthWelcomePage(),
    ),

    // 2. Main 4-Tab Stateful Shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShellPage(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Tổng quan (Dashboard)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),

        // Tab 2: Thiết bị (Assets & Warranties)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.items,
              builder: (context, state) => const ItemListPage(),
            ),
          ],
        ),

        // Tab 3: Bảo trì (Maintenance)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.maintenance,
              builder: (context, state) => const MaintenanceListPage(),
            ),
          ],
        ),

        // Tab 4: Cá nhân (Profile)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),

    // 3. Sub-pages & Modal Routes (Root Navigator Stack)
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.pdfPreview,
      builder: (context, state) => const PdfPreviewPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.itemsAdd,
      builder: (context, state) => const AddEditItemPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.itemsEdit,
      builder: (context, state) {
        final item = state.extra as ItemEntity?;
        return AddEditItemPage(itemToEdit: item);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.itemDetail,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ItemDetailPage(itemId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.receiptViewer,
      builder: (context, state) {
        final url = state.extra as String? ?? '';
        return ReceiptViewerPage(imageUrl: url);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.maintenanceAdd,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return AddEditMaintenancePage(
          preselectedItemId: extra?['itemId'] as String?,
          preselectedItemName: extra?['itemName'] as String?,
          taskToEdit: extra?['task'] as MaintenanceTaskEntity?,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.maintenanceAddLog,
      builder: (context, state) => const AddServiceLogPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.maintenanceDetail,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final task = state.extra as MaintenanceTaskEntity?;
        return MaintenanceDetailPage(taskId: id, initialTask: task);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.maintenanceEdit,
      builder: (context, state) {
        final task = state.extra as MaintenanceTaskEntity?;
        return AddEditMaintenancePage(
          taskToEdit: task,
          preselectedItemId: task?.itemId,
          preselectedItemName: task?.itemName,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.familyMembers,
      builder: (context, state) => const FamilyMembersPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.qrShare,
      builder: (context, state) => const QrSharePage(),
    ),
  ],
);
