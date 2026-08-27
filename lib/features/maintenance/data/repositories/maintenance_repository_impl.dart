import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/utils/warranty_calculator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:home_sync/features/maintenance/data/mappers/category_mapper.dart';
import 'package:home_sync/features/maintenance/data/mappers/maintenance_task_mapper.dart';
import 'package:home_sync/features/maintenance/data/models/category_model.dart';
import 'package:home_sync/features/maintenance/data/models/maintenance_preset_model.dart';
import 'package:home_sync/features/maintenance/data/models/maintenance_task_model.dart';

/// Remote Data Source cho Maintenance
class MaintenanceRemoteDataSource {
  MaintenanceRemoteDataSource({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<MaintenanceTaskModel>> getTasks({String? itemId, bool? isCompleted}) async {
    var request = _client.from('maintenance_tasks').select('*, items(name, location, user_id)');

    if (itemId != null) {
      request = request.eq('item_id', itemId);
    }
    if (isCompleted != null) {
      request = request.eq('is_completed', isCompleted);
    }

    final response = await request.order('next_due_date', ascending: true);
    final list = response as List<dynamic>;
    return list.map((json) => MaintenanceTaskModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<MaintenanceTaskModel> addTask(MaintenanceTaskModel task) async {
    final data = task.toJson();
    data.remove('id');
    final response = await _client.from('maintenance_tasks').insert(data).select('*, items(name, location)').single();
    return MaintenanceTaskModel.fromJson(response);
  }

  Future<MaintenanceTaskModel> updateTask(MaintenanceTaskModel task) async {
    final data = task.toJson();
    final response = await _client.from('maintenance_tasks').update(data).eq('id', task.id).select('*, items(name, location)').single();
    return MaintenanceTaskModel.fromJson(response);
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

  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.from('categories').select().order('name');
    final list = response as List<dynamic>;
    return list.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList();
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
      final model = MaintenanceTaskMapper.toModel(task);
      final savedModel = await _remoteDataSource.addTask(model);
      return Right(MaintenanceTaskMapper.toEntity(savedModel));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceTaskEntity>> updateTask(MaintenanceTaskEntity task) async {
    try {
      final model = MaintenanceTaskMapper.toModel(task);
      final updatedModel = await _remoteDataSource.updateTask(model);
      return Right(MaintenanceTaskMapper.toEntity(updatedModel));
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

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final models = await _remoteDataSource.getCategories();
      return Right(models.map(CategoryMapper.toEntity).toList());
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
