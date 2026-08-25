import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:home_sync/features/profile/domain/repositories/profile_repository.dart';

/// Use Case: Lấy thông tin tài khoản người dùng
class GetProfileUseCase implements UseCase<ProfileEntity, NoParams> {
  const GetProfileUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, ProfileEntity>> call([NoParams params = const NoParams()]) {
    return _repository.getProfile();
  }
}

/// Use Case: Cập nhật thông tin tài khoản và cấu hình thông báo
class UpdateProfileUseCase implements UseCase<ProfileEntity, ProfileEntity> {
  const UpdateProfileUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, ProfileEntity>> call(ProfileEntity profile) {
    return _repository.updateProfile(profile);
  }
}

/// Use Case: Lấy danh sách Nhà / Căn hộ
class GetHomesUseCase implements UseCase<List<HomeEntity>, NoParams> {
  const GetHomesUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, List<HomeEntity>>> call([NoParams params = const NoParams()]) {
    return _repository.getHomes();
  }
}

/// Params cho CreateHomeUseCase
class CreateHomeParams {
  const CreateHomeParams({required this.name, this.address});
  final String name;
  final String? address;
}

/// Use Case: Tạo Nhà / Căn hộ mới
class CreateHomeUseCase implements UseCase<HomeEntity, CreateHomeParams> {
  const CreateHomeUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, HomeEntity>> call(CreateHomeParams params) {
    return _repository.createHome(params.name, params.address);
  }
}

/// Use Case: Lấy danh sách thành viên trong nhà
class GetHomeMembersUseCase implements UseCase<List<HomeMemberEntity>, String> {
  const GetHomeMembersUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, List<HomeMemberEntity>>> call(String homeId) {
    return _repository.getHomeMembers(homeId);
  }
}

/// Params cho AddHomeMemberUseCase
class AddHomeMemberParams {
  const AddHomeMemberParams({
    required this.homeId,
    required this.userId,
    required this.role,
  });

  final String homeId;
  final String userId;
  final String role;
}

/// Use Case: Thêm thành viên vào nhà
class AddHomeMemberUseCase implements UseCase<Unit, AddHomeMemberParams> {
  const AddHomeMemberUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(AddHomeMemberParams params) {
    return _repository.addHomeMember(params.homeId, params.userId, params.role);
  }
}

/// Params cho RemoveHomeMemberUseCase
class RemoveHomeMemberParams {
  const RemoveHomeMemberParams({required this.homeId, required this.userId});
  final String homeId;
  final String userId;
}

/// Use Case: Xóa thành viên khỏi nhà
class RemoveHomeMemberUseCase implements UseCase<Unit, RemoveHomeMemberParams> {
  const RemoveHomeMemberUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(RemoveHomeMemberParams params) {
    return _repository.removeHomeMember(params.homeId, params.userId);
  }
}
