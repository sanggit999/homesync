import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/features/auth/domain/usecases/auth_usecases.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_state.dart';

export 'auth_state.dart';

/// Cubit quản lý trạng thái Xác thực người dùng (Auth & Guest Mode)
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.signInAnonymouslyUseCase,
    required this.signInWithGoogleUseCase,
    required this.linkWithGoogleUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.updatePlayerIdUseCase,
  }) : super(const AuthInitial());

  final SignInAnonymouslyUseCase signInAnonymouslyUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final LinkWithGoogleUseCase linkWithGoogleUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdatePlayerIdUseCase updatePlayerIdUseCase;

  /// Kiểm tra trạng thái đăng nhập khi mở ứng dụng
  void checkAuthStatus() {
    final currentUser = getCurrentUserUseCase();
    if (currentUser != null) {
      emit(Authenticated(
        user: currentUser,
        isAnonymous: currentUser.isAnonymous,
      ));
    } else {
      emit(const Unauthenticated());
    }
  }

  /// Trải nghiệm trước - Đăng nhập ẩn danh 1 chạm (Guest Mode)
  Future<void> signInAnonymously() async {
    debugPrint('[HOMESYNC DEBUG] Kích hoạt signInAnonymously()...');
    emit(const AuthLoading());
    final result = await signInAnonymouslyUseCase();
    result.fold(
      (failure) {
        debugPrint('[HOMESYNC DEBUG] Đăng nhập ẩn danh LỖI: ${failure.message}');
        emit(AuthFailureState(failure.message));
      },
      (user) {
        debugPrint('[HOMESYNC DEBUG] Đăng nhập ẩn danh THÀNH CÔNG. User ID: ${user.id}');
        emit(Authenticated(user: user, isAnonymous: true));
      },
    );
  }

  /// Đăng nhập bằng tài khoản Google
  Future<void> signInWithGoogle() async {
    debugPrint('[HOMESYNC DEBUG] Kích hoạt signInWithGoogle()...');
    emit(const AuthLoading());
    final result = await signInWithGoogleUseCase();
    result.fold(
      (failure) {
        debugPrint('[HOMESYNC DEBUG] Đăng nhập Google LỖI: ${failure.message}');
        emit(AuthFailureState(
          failure.message,
          isCanceled: failure is AuthCanceledFailure,
        ));
      },
      (user) {
        debugPrint('[HOMESYNC DEBUG] Đăng nhập Google THÀNH CÔNG. User ID: ${user.id}');
        emit(Authenticated(
          user: user,
          isAnonymous: false,
          message: 'Đăng nhập Google thành công',
        ));
      },
    );
  }

  /// Liên kết tài khoản Guest với Google để lưu trữ đám mây
  Future<void> linkWithGoogle() async {
    final currentUser = getCurrentUserUseCase();
    emit(const AuthLoading());
    final result = await linkWithGoogleUseCase();
    result.fold(
      (failure) {
        debugPrint('[HOMESYNC DEBUG] Liên kết Google THẤT BẠI: ${failure.message}');
        final isCanceled = failure is AuthCanceledFailure;
        final isAccountAlreadyExists = failure is AuthAccountAlreadyExistsFailure;
        final conflictEmail = failure is AuthAccountAlreadyExistsFailure ? failure.email : null;
        final activeUser = getCurrentUserUseCase() ?? currentUser;

        if (activeUser != null) {
          emit(AuthFailureState(
            failure.message,
            user: activeUser,
            isAnonymous: activeUser.isAnonymous,
            isCanceled: isCanceled,
            isAccountAlreadyExists: isAccountAlreadyExists,
            conflictEmail: conflictEmail,
          ));
        } else {
          emit(AuthFailureState(
            failure.message,
            isCanceled: isCanceled,
            isAccountAlreadyExists: isAccountAlreadyExists,
            conflictEmail: conflictEmail,
          ));
        }
      },
      (user) {
        debugPrint('[HOMESYNC DEBUG] Liên kết Google THÀNH CÔNG. User ID: ${user.id}');
        emit(Authenticated(
          user: user,
          isAnonymous: false,
          message: 'Bạn đã liên kết Google thành công',
        ));
      },
    );
  }

  /// Đăng xuất tài khoản
  Future<void> signOut() async {
    emit(const AuthLoading());
    final result = await signOutUseCase();
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  /// Cập nhật OneSignal Player ID cho thiết bị
  Future<void> updatePlayerId(String playerId) async {
    await updatePlayerIdUseCase(playerId);
  }
}
