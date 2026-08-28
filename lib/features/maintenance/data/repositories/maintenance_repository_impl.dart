import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/utils/warranty_calculator.dart';
import 'package:home_sync/features/maintenance/data/mappers/category_mapper.dart';
import 'package:home_sync/features/maintenance/data/mappers/maintenance_task_mapper.dart';
import 'package:home_sync/features/maintenance/data/models/category_model.dart';
import 'package:home_sync/features/maintenance/data/models/maintenance_preset_model.dart';
import 'package:home_sync/features/maintenance/data/models/maintenance_task_model.dart';
import 'package:home_sync/features/maintenance/domain/repositories/maintenance_repository.dart';

/// Remote Data Source cho Maintenance Tasks & Categories
class MaintenanceRemoteDataSource {
  MaintenanceRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<MaintenanceTaskModel>> getTasks({String? itemId, bool? isCompleted}) async {
    var query = _client.from('maintenance_tasks').select('*, items(name)');
    if (itemId != null) {
      query = query.eq('item_id', itemId);
    }
    if (isCompleted != null) {
      query = query.eq('is_completed', isCompleted);
    }
    final response = await query.order('next_due_date');
    final list = response as List<dynamic>;
    return list.map((json) {
      final map = Map<String, dynamic>.from(json as Map);
      if (map['items'] != null && map['items'] is Map) {
        map['item_name'] = map['items']['name'];
      }
      return MaintenanceTaskModel.fromJson(map);
    }).toList();
  }

  Future<MaintenanceTaskModel> addTask(MaintenanceTaskModel task) async {
    final response = await _client.from('maintenance_tasks').insert(task.toJson()).select('*, items(name)').single();
    final map = Map<String, dynamic>.from(response);
    if (map['items'] != null && map['items'] is Map) {
      map['item_name'] = map['items']['name'];
    }
    return MaintenanceTaskModel.fromJson(map);
  }

  Future<MaintenanceTaskModel> updateTask(MaintenanceTaskModel task) async {
    final response = await _client.from('maintenance_tasks').update(task.toJson()).eq('id', task.id).select('*, items(name)').single();
    final map = Map<String, dynamic>.from(response);
    if (map['items'] != null && map['items'] is Map) {
      map['item_name'] = map['items']['name'];
    }
    return MaintenanceTaskModel.fromJson(map);
  }

  Future<void> completeTask({
    required String taskId,
    required DateTime completedDate,
    required double cost,
    String? technicianName,
    String? technicianPhone,
    String? receiptImageUrl,
    String? notes,
  }) async {
    // 1. Lấy thông tin task hiện tại
    final taskData = await _client.from('maintenance_tasks').select('*, items(user_id, name)').eq('id', taskId).single();
    final task = MaintenanceTaskModel.fromJson(taskData);
    final userId = taskData['items']['user_id'] as String;

    // 2. Tính ngày đến hạn kế tiếp
    final nextDueDate = WarrantyCalculator.calculateNextDueDate(
      lastDate: completedDate,
      frequencyMonths: task.frequencyMonths,
    );

    // 3. Cập nhật task với ngày hoàn thành và ngày kế tiếp
    await _client.from('maintenance_tasks').update({
      'last_completed_at': completedDate.toIso8601String().split('T').first,
      'next_due_date': nextDueDate.toIso8601String().split('T').first,
      'cost': cost,
      'technician_name': technicianName ?? task.technicianName,
      'technician_phone': technicianPhone ?? task.technicianPhone,
      'notes': notes ?? task.notes,
      'is_completed': false, // Sẵn sàng cho chu kỳ tiếp theo
    }).eq('id', taskId);

    // 4. Tự động ghi 1 bản ghi vào bảng 'service_logs'
    await _client.from('service_logs').insert({
      'user_id': userId,
      'item_id': task.itemId,
      'task_id': task.id,
      'service_type': 'maintenance',
      'title': task.taskName,
      'service_date': completedDate.toIso8601String().split('T').first,
      'cost': cost,
      'technician_name': technicianName ?? task.technicianName,
      'technician_phone': technicianPhone ?? task.technicianPhone,
      'receipt_image_url': receiptImageUrl,
      'notes': notes,
    });
  }

  Future<void> deleteTask(String id) async {
    await _client.from('maintenance_tasks').delete().eq('id', id);
  }

  /// Lấy toàn bộ danh mục từ Supabase và sắp xếp chuẩn UX ('Khác' luôn đứng cuối cùng)
  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.from('categories').select();
    final list = response as List<dynamic>;
    final models = list.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList();

    const orderMap = {
      'điện lạnh': 1,
      'điện tử': 2,
      'thiết bị bếp': 3,
      'bếp': 3,
      'gia dụng': 4,
      'xe cộ': 5,
      'xe': 5,
      'cá nhân': 6,
      'khác': 99,
      'other': 99,
    };

    models.sort((a, b) {
      final orderA = orderMap[a.name.toLowerCase()] ?? 50;
      final orderB = orderMap[b.name.toLowerCase()] ?? 50;
      if (orderA != orderB) {
        return orderA.compareTo(orderB);
      }
      return a.name.compareTo(b.name);
    });

    return models;
  }

  Future<List<MaintenancePresetModel>> getPresetsByCategory(String categoryId) async {
    final response = await _client.from('maintenance_presets').select().eq('category_id', categoryId);
    final list = response as List<dynamic>;
    return list.map((json) => MaintenancePresetModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}

/// Repository Implementation cho Maintenance với fpdart Either
class MaintenanceRepositoryImpl implements MaintenanceRepository {
  MaintenanceRepositoryImpl({MaintenanceRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? MaintenanceRemoteDataSource();

  final MaintenanceRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<MaintenanceTaskEntity>>> getTasks({String? itemId, bool? isCompleted}) async {
    try {
      final models = await _remoteDataSource.getTasks(itemId: itemId, isCompleted: isCompleted);
      return Right(models.map(MaintenanceTaskMapper.toEntity).toList());
    } on PostgrestException catch (e) {
      debugPrint('[HOMESYNC DB ERROR - MAINTENANCE_TASKS] Code: [${e.code}] Message: ${e.message} | Details: ${e.details} | Hint: ${e.hint}');
      return Left(ServerFailure('[${e.code}] ${e.message}'));
    } catch (e) {
      debugPrint('[HOMESYNC DB ERROR - MAINTENANCE_TASKS] Lỗi không xác định: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceTaskEntity>> addTask(MaintenanceTaskEntity task) async {
    try {
      final model = await _remoteDataSource.addTask(MaintenanceTaskMapper.toModel(task));
      return Right(MaintenanceTaskMapper.toEntity(model));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceTaskEntity>> updateTask(MaintenanceTaskEntity task) async {
    try {
      final model = await _remoteDataSource.updateTask(MaintenanceTaskMapper.toModel(task));
      return Right(MaintenanceTaskMapper.toEntity(model));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> completeTask({
    required String taskId,
    required DateTime completedDate,
    required double cost,
    String? technicianName,
    String? technicianPhone,
    String? receiptImageUrl,
    String? notes,
  }) async {
    try {
      await _remoteDataSource.completeTask(
        taskId: taskId,
        completedDate: completedDate,
        cost: cost,
        technicianName: technicianName,
        technicianPhone: technicianPhone,
        receiptImageUrl: receiptImageUrl,
        notes: notes,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String id) async {
    try {
      await _remoteDataSource.deleteTask(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  List<CategoryEntity>? _cachedCategories;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedCategories != null && _cachedCategories!.isNotEmpty) {
      return Right(_cachedCategories!);
    }
    try {
      final models = await _remoteDataSource.getCategories();
      _cachedCategories = models.map(CategoryMapper.toEntity).toList();
      return Right(_cachedCategories!);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MaintenancePresetEntity>>> getPresetsByCategory(String categoryId) async {
    try {
      final models = await _remoteDataSource.getPresetsByCategory(categoryId);
      return Right(models.map(CategoryMapper.presetToEntity).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
