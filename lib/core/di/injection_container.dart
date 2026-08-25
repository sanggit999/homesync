import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Features: Auth
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';

// Features: Items
import '../../features/items/data/repositories/item_repository_impl.dart';
import '../../features/items/domain/repositories/item_repository.dart';
import '../../features/items/domain/usecases/item_usecases.dart';

// Features: Maintenance
import '../../features/maintenance/data/repositories/maintenance_repository_impl.dart';
import '../../features/maintenance/domain/repositories/maintenance_repository.dart';
import '../../features/maintenance/domain/usecases/maintenance_usecases.dart';

// Features: Service Logs
import '../../features/service_logs/data/repositories/service_log_repository_impl.dart';
import '../../features/service_logs/domain/repositories/service_log_repository.dart';
import '../../features/service_logs/domain/usecases/service_log_usecases.dart';

// Features: Profile
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/profile_usecases.dart';

// Features: Dashboard
import '../../features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart';

final sl = GetIt.instance;

/// Khởi tạo và đăng ký toàn bộ Dependency Injection qua GetIt
Future<void> initDependencies() async {
  // ==========================================
  // 1. EXTERNAL SERVICES
  // ==========================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // ==========================================
  // 2. DATA SOURCES
  // ==========================================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(
      client: sl<SupabaseClient>(),
      googleSignIn: sl<GoogleSignIn>(),
    ),
  );

  sl.registerLazySingleton<ItemsRemoteDataSource>(
    () => ItemsRemoteDataSource(client: sl<SupabaseClient>()),
  );

  sl.registerLazySingleton<MaintenanceRemoteDataSource>(
    () => MaintenanceRemoteDataSource(client: sl<SupabaseClient>()),
  );

  sl.registerLazySingleton<ServiceLogsRemoteDataSource>(
    () => ServiceLogsRemoteDataSource(client: sl<SupabaseClient>()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(client: sl<SupabaseClient>()),
  );

  // ==========================================
  // 3. REPOSITORIES
  // ==========================================
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton<ItemRepository>(
    () => ItemRepositoryImpl(remoteDataSource: sl<ItemsRemoteDataSource>()),
  );

  sl.registerLazySingleton<MaintenanceRepository>(
    () => MaintenanceRepositoryImpl(
      remoteDataSource: sl<MaintenanceRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ServiceLogRepository>(
    () => ServiceLogRepositoryImpl(
      remoteDataSource: sl<ServiceLogsRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl<ProfileRemoteDataSource>()),
  );

  // ==========================================
  // 4. USE CASES
  // ==========================================
  // Auth Use Cases
  sl.registerLazySingleton(() => SignInAnonymouslyUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LinkWithGoogleUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => AuthStateChangesUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdatePlayerIdUseCase(sl<AuthRepository>()));

  // Items Use Cases
  sl.registerLazySingleton(() => GetItemsUseCase(sl<ItemRepository>()));
  sl.registerLazySingleton(() => GetItemByIdUseCase(sl<ItemRepository>()));
  sl.registerLazySingleton(() => AddItemUseCase(sl<ItemRepository>()));
  sl.registerLazySingleton(() => UpdateItemUseCase(sl<ItemRepository>()));
  sl.registerLazySingleton(() => DeleteItemUseCase(sl<ItemRepository>()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl<ItemRepository>()));
  sl.registerLazySingleton(() => GetItemDocumentsUseCase(sl<ItemRepository>()));
  sl.registerLazySingleton(() => AddItemDocumentUseCase(sl<ItemRepository>()));
  sl.registerLazySingleton(() => DeleteItemDocumentUseCase(sl<ItemRepository>()));

  // Maintenance Use Cases
  sl.registerLazySingleton(() => GetTasksUseCase(sl<MaintenanceRepository>()));
  sl.registerLazySingleton(() => AddTaskUseCase(sl<MaintenanceRepository>()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl<MaintenanceRepository>()));
  sl.registerLazySingleton(() => CompleteTaskUseCase(sl<MaintenanceRepository>()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl<MaintenanceRepository>()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl<MaintenanceRepository>()));
  sl.registerLazySingleton(() => GetPresetsByCategoryUseCase(sl<MaintenanceRepository>()));

  // Service Logs Use Cases
  sl.registerLazySingleton(() => GetServiceLogsUseCase(sl<ServiceLogRepository>()));
  sl.registerLazySingleton(() => AddServiceLogUseCase(sl<ServiceLogRepository>()));
  sl.registerLazySingleton(() => DeleteServiceLogUseCase(sl<ServiceLogRepository>()));
  sl.registerLazySingleton(() => GetTotalCostUseCase(sl<ServiceLogRepository>()));

  // Profile Use Cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => GetHomesUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => CreateHomeUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => GetHomeMembersUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => AddHomeMemberUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => RemoveHomeMemberUseCase(sl<ProfileRepository>()));

  // Dashboard Use Case
  sl.registerLazySingleton(
    () => GetDashboardSummaryUseCase(
      itemRepository: sl<ItemRepository>(),
      maintenanceRepository: sl<MaintenanceRepository>(),
      serviceLogRepository: sl<ServiceLogRepository>(),
    ),
  );
}
