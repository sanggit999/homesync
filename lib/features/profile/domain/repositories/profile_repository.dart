import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import '../entities/home_entity.dart';
import '../entities/profile_entity.dart';
export '../entities/home_entity.dart';
export '../entities/profile_entity.dart';

/// Abstract Repository Contract cho Profile & Quản lý Nhà dùng fpdart Either
abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, List<HomeEntity>>> getHomes();
  Future<Either<Failure, HomeEntity>> createHome(String name, String? address);
  Future<Either<Failure, List<HomeMemberEntity>>> getHomeMembers(String homeId);
  Future<Either<Failure, Unit>> addHomeMember(String homeId, String userId, String role);
  Future<Either<Failure, Unit>> removeHomeMember(String homeId, String userId);
}
