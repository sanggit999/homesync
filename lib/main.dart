import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/core/config/app_config.dart';
import 'package:home_sync/core/di/injection_container.dart';
import 'package:home_sync/core/router/app_router.dart';
import 'package:home_sync/core/theme/app_theme.dart';
import 'package:home_sync/core/utils/snackbar_utils.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:home_sync/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:home_sync/features/items/presentation/cubit/item_form_cubit.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_cubit.dart';
import 'package:home_sync/features/maintenance/presentation/cubit/maintenance_cubit.dart';
import 'package:home_sync/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:home_sync/core/services/in_memory_local_storage.dart';
import 'package:home_sync/features/service_logs/presentation/cubit/service_log_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo ngôn ngữ ngày tháng tiếng Việt cho thư viện intl
  try {
    await initializeDateFormatting('vi_VN', null);
  } catch (e) {
    debugPrint('DateFormatting init notice: $e');
  }

  // Khởi tạo Supabase client với cơ chế Bảo Mật RAM-ONLY (Không ghi Token xuống Disk)
  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabaseAnonKey,
      authOptions: FlutterAuthClientOptions(
        localStorage: InMemoryLocalStorage(),
      ),
    );
  } catch (e) {
    debugPrint('Supabase init notice: $e');
  }

  // Khởi tạo Dependency Injection (GetIt Service Locator)
  try {
    await initDependencies();
  } catch (e) {
    debugPrint('Dependency Injection init notice: $e');
  }

  runApp(const HomeSyncApp());
}

class HomeSyncApp extends StatelessWidget {
  const HomeSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider<DashboardCubit>(
          create: (_) => sl<DashboardCubit>(),
        ),
        BlocProvider<ItemListCubit>(
          create: (_) => sl<ItemListCubit>(),
        ),
        BlocProvider<ItemFormCubit>(
          create: (_) => sl<ItemFormCubit>(),
        ),
        BlocProvider<MaintenanceCubit>(
          create: (_) => sl<MaintenanceCubit>(),
        ),
        BlocProvider<ServiceLogCubit>(
          create: (_) => sl<ServiceLogCubit>(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => sl<ProfileCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: AppConfig.appName,
        scaffoldMessengerKey: AppSnackBar.messengerKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
