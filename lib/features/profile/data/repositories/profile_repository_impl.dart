import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/profile_repository.dart';
import '../mappers/home_mapper.dart';
import '../mappers/profile_mapper.dart';
import '../models/home_member_model.dart';
import '../models/home_model.dart';
import '../models/profile_model.dart';

/// Remote Data Source cho Profile & Homes
class ProfileRemoteDataSource {
  ProfileRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<ProfileModel> getProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) throw const AuthException('Chưa đăng nhập.');

    final response = await _client.from('profiles').select().eq('id', user.id).single();
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final response = await _client
        .from('profiles')
        .update(profile.toJson())
        .eq('id', profile.id)
        .select()
        .single();
    return ProfileModel.fromJson(response);
  }

  Future<List<HomeModel>> getHomes() async {
    final response = await _client.from('homes').select().order('created_at');
    final list = response as List<dynamic>;
    return list.map((json) => HomeModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<HomeModel> createHome(String name, String? address) async {
    final user = _client.auth.currentUser;
    if (user == null) throw const AuthException('Chưa đăng nhập.');

    final response = await _client.from('homes').insert({
      'owner_id': user.id,
      'name': name,
      'address': address,
    }).select().single();
    return HomeModel.fromJson(response);
  }

  Future<List<HomeMemberModel>> getHomeMembers(String homeId) async {
    final response = await _client
        .from('home_members')
        .select('*, profiles(full_name, avatar_url)')
        .eq('home_id', homeId);
    final list = response as List<dynamic>;
    return list.map((json) => HomeMemberModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> addHomeMember(String homeId, String userId, String role) async {
    await _client.from('home_members').insert({
      'home_id': homeId,
      'user_id': userId,
      'role': role,
    });
  }

  Future<void> removeHomeMember(String homeId, String userId) async {
    await _client.from('home_members').delete().eq('home_id', homeId).eq('user_id', userId);
  }
}

/// Repository Implementation cho Profile với fpdart Either
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({ProfileRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProfileRemoteDataSource();

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final model = await _remoteDataSource.getProfile();
      return Right(ProfileMapper.toEntity(model));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile) async {
    try {
      final model = ProfileMapper.toModel(profile);
      final updatedModel = await _remoteDataSource.updateProfile(model);
      return Right(ProfileMapper.toEntity(updatedModel));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getHomes() async {
    try {
      final models = await _remoteDataSource.getHomes();
      return Right(models.map(HomeMapper.toEntity).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HomeEntity>> createHome(String name, String? address) async {
    try {
      final model = await _remoteDataSource.createHome(name, address);
      return Right(HomeMapper.toEntity(model));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HomeMemberEntity>>> getHomeMembers(String homeId) async {
    try {
      final models = await _remoteDataSource.getHomeMembers(homeId);
      return Right(models.map(HomeMapper.memberToEntity).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addHomeMember(String homeId, String userId, String role) async {
    try {
      await _remoteDataSource.addHomeMember(homeId, userId, role);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeHomeMember(String homeId, String userId) async {
    try {
      await _remoteDataSource.removeHomeMember(homeId, userId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
