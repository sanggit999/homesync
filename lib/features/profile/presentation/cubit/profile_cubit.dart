import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/profile_usecases.dart';
import 'profile_state.dart';

export 'profile_state.dart';

/// Cubit quản lý thông tin tài khoản, cài đặt thông báo & quản lý Nhà (Homes & Members)
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.getHomesUseCase,
    required this.createHomeUseCase,
    required this.getHomeMembersUseCase,
    required this.addHomeMemberUseCase,
    required this.removeHomeMemberUseCase,
  }) : super(const ProfileInitial());

  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetHomesUseCase getHomesUseCase;
  final CreateHomeUseCase createHomeUseCase;
  final GetHomeMembersUseCase getHomeMembersUseCase;
  final AddHomeMemberUseCase addHomeMemberUseCase;
  final RemoveHomeMemberUseCase removeHomeMemberUseCase;

  /// Tải thông tin tài khoản và danh sách Nhà
  Future<void> loadProfileData() async {
    emit(const ProfileLoading());
    final profileResult = await getProfileUseCase();
    final homesResult = await getHomesUseCase();

    profileResult.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) {
        final homes = homesResult.getOrElse((_) => []);
        emit(ProfileLoaded(profile: profile, homes: homes));
      },
    );
  }

  /// Cập nhật thông tin tài khoản và cấu hình thông báo
  Future<void> updateProfile(ProfileEntity profile) async {
    final result = await updateProfileUseCase(profile);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (updatedProfile) {
        if (state is ProfileLoaded) {
          final current = state as ProfileLoaded;
          emit(current.copyWith(profile: updatedProfile));
        } else {
          emit(ProfileLoaded(profile: updatedProfile));
        }
      },
    );
  }

  /// Tạo Nhà / Căn hộ mới
  Future<void> createHome(String name, String? address) async {
    final result = await createHomeUseCase(CreateHomeParams(name: name, address: address));
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => loadProfileData(),
    );
  }

  /// Tải danh sách thành viên trong nhà
  Future<void> loadHomeMembers(String homeId) async {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final result = await getHomeMembersUseCase(homeId);
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (members) => emit(current.copyWith(members: members)),
      );
    }
  }

  /// Thêm / Mời thành viên vào nhà
  Future<void> addMember({required String homeId, required String userId, required String role}) async {
    final result = await addHomeMemberUseCase(AddHomeMemberParams(homeId: homeId, userId: userId, role: role));
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => loadHomeMembers(homeId),
    );
  }

  /// Xóa thành viên khỏi nhà
  Future<void> removeMember({required String homeId, required String userId}) async {
    final result = await removeHomeMemberUseCase(RemoveHomeMemberParams(homeId: homeId, userId: userId));
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => loadHomeMembers(homeId),
    );
  }
}
