import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/features/auth/domain/repositories/auth_repository.dart';

/// Use Case: Đăng nhập ẩn danh (Guest Mode)
class SignInAnonymouslyUseCase implements UseCase<AuthUserEntity, NoParams> {
  const SignInAnonymouslyUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUserEntity>> call([NoParams params = const NoParams()]) =>
      _repository.signInAnonymously();
}

/// Use Case: Đăng nhập Google
class SignInWithGoogleUseCase implements UseCase<AuthUserEntity, NoParams> {
  const SignInWithGoogleUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUserEntity>> call([NoParams params = const NoParams()]) =>
      _repository.signInWithGoogle();
}

/// Use Case: Liên kết tài khoản Guest với Google
class LinkWithGoogleUseCase implements UseCase<AuthUserEntity, NoParams> {
  const LinkWithGoogleUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUserEntity>> call([NoParams params = const NoParams()]) =>
      _repository.linkWithGoogle();
}

/// Use Case: Đăng xuất
class SignOutUseCase implements UseCase<Unit, NoParams> {
  const SignOutUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call([NoParams params = const NoParams()]) =>
      _repository.signOut();
}

/// Use Case: Lấy thông tin user hiện tại
class GetCurrentUserUseCase implements SyncUseCase<AuthUserEntity?, NoParams> {
  const GetCurrentUserUseCase(this._repository);
  final AuthRepository _repository;

  @override
  AuthUserEntity? call([NoParams params = const NoParams()]) =>
      _repository.getCurrentUser();
}

/// Use Case: Lắng nghe thay đổi trạng thái xác thực
class AuthStateChangesUseCase implements StreamUseCase<AuthState, NoParams> {
  const AuthStateChangesUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Stream<AuthState> call([NoParams params = const NoParams()]) =>
      _repository.authStateChanges;
}

/// Use Case: Cập nhật OneSignal Player ID
class UpdatePlayerIdUseCase implements UseCase<Unit, String> {
  const UpdatePlayerIdUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String playerId) =>
      _repository.updatePlayerId(playerId);
}
