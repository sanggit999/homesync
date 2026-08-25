import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/features/service_logs/domain/repositories/service_log_repository.dart';
import 'package:home_sync/features/service_logs/data/mappers/service_log_mapper.dart';
import 'package:home_sync/features/service_logs/data/models/service_log_model.dart';

/// Remote Data Source cho Service Logs
class ServiceLogsRemoteDataSource {
  ServiceLogsRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<ServiceLogModel>> getLogs({
    String? itemId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    var request = _client.from('service_logs').select('*, items(name)');

    if (itemId != null) {
      request = request.eq('item_id', itemId);
    }
    if (fromDate != null) {
      request = request.gte('service_date', fromDate.toIso8601String().split('T').first);
    }
    if (toDate != null) {
      request = request.lte('service_date', toDate.toIso8601String().split('T').first);
    }

    final response = await request.order('service_date', ascending: false);
    final list = response as List<dynamic>;
    return list.map((json) => ServiceLogModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<ServiceLogModel> addLog(ServiceLogModel log) async {
    final data = log.toJson();
    data.remove('id');
    final response = await _client.from('service_logs').insert(data).select('*, items(name)').single();
    return ServiceLogModel.fromJson(response);
  }

  Future<void> deleteLog(String id) async {
    await _client.from('service_logs').delete().eq('id', id);
  }

  Future<double> getTotalCost({DateTime? fromDate, DateTime? toDate}) async {
    final logs = await getLogs(fromDate: fromDate, toDate: toDate);
    return logs.fold<double>(0.0, (sum, item) => sum + item.cost);
  }
}

/// Repository Implementation cho Service Logs với fpdart Either
class ServiceLogRepositoryImpl implements ServiceLogRepository {
  ServiceLogRepositoryImpl({ServiceLogsRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ServiceLogsRemoteDataSource();

  final ServiceLogsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<ServiceLogEntity>>> getLogs({
    String? itemId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final models = await _remoteDataSource.getLogs(
        itemId: itemId,
        fromDate: fromDate,
        toDate: toDate,
      );
      return Right(models.map(ServiceLogMapper.toEntity).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServiceLogEntity>> addLog(ServiceLogEntity log) async {
    try {
      final model = ServiceLogMapper.toModel(log);
      final savedModel = await _remoteDataSource.addLog(model);
      return Right(ServiceLogMapper.toEntity(savedModel));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLog(String id) async {
    try {
      await _remoteDataSource.deleteLog(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalCost({DateTime? fromDate, DateTime? toDate}) async {
    try {
      final total = await _remoteDataSource.getTotalCost(fromDate: fromDate, toDate: toDate);
      return Right(total);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
