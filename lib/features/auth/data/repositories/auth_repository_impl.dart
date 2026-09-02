import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/utils/api_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/features/auth/domain/repositories/auth_repository.dart';

/// Mã lỗi chuẩn của Google Sign-In SDK & Google Play Services
abstract final class GoogleAuthErrorCodes {
  static const String canceled = 'sign_in_canceled';
  static const String androidCanceledCode = '12501';
  static const String networkError = 'network_error';
  static const String apiNotConnected = '17';
}

/// Mã lỗi chuẩn từ Supabase Auth API
abstract final class SupabaseAuthStatusCodes {
  static const String unprocessableEntity = '422';
  static const String anonymousDisabled = 'anonymous_provider_disabled';
  static const String identityAlreadyExists = 'identity_already_exists';
  static const String userAlreadyExists = 'user_already_exists';
  static const String emailExists = 'email_exists';
}

/// Remote Data Source xử lý giao tiếp Supabase Auth & Google Sign-In SDK
class AuthRemoteDataSource {
  AuthRemoteDataSource({
    SupabaseClient? client,
    GoogleSignIn? googleSignIn,
  })  : _client = client ?? Supabase.instance.client,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final SupabaseClient _client;
  final GoogleSignIn _googleSignIn;

  Future<AuthResponse> signInAnonymously() async {
    return _client.auth.signInAnonymously();
  }

  Future<AuthResponse> signInWithGoogle() async {
    final googleUser = await _googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw const AuthException('Không nhận được ID Token từ Google.');
    }

    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
  }

  Future<AuthResponse> linkWithGoogle() async {
    final googleUser = await _googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw const AuthException('Không nhận được ID Token từ Google.');
    }

    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> updatePlayerId(String playerId) async {
    final user = _client.auth.currentUser;
    if (user != null) {
      await _client.from('profiles').update({
        'onesignal_player_id': playerId,
      }).eq('id', user.id);
    }
  }
}

/// Repository Implementation của AuthRepository sử dụng Global safeApiCall
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AuthUserEntity>> signInWithGoogle() async {
    try {
      return await safeApiCall(() async {
        debugPrint('[HomeSync Auth] Đang bắt đầu đăng nhập bằng tài khoản Google...');
        final response = await _remoteDataSource.signInWithGoogle();
        final user = response.user;
        if (user == null) {
          throw const AuthException('Không lấy được thông tin người dùng từ Google.');
        }
        debugPrint('[HomeSync Auth] Đăng nhập Google thành công! User ID: ${user.id}');
        return _toEntity(user);
      });
    } on GoogleSignInException catch (e) {
      debugPrint('[HomeSync Auth] Lỗi GoogleSignInException khi đăng nhập: ${e.code} - ${e.description}');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Left(AuthCanceledFailure('Đã hủy đăng nhập Google.'));
      }
      return const Left(AuthFailure('Không thể đăng nhập bằng Google lúc này. Vui lòng thử lại sau.'));
    } on PlatformException catch (e) {
      debugPrint('[HomeSync Auth] Lỗi PlatformException khi đăng nhập Google: ${e.code} - ${e.message}');
      if (e.code == GoogleAuthErrorCodes.canceled ||
          e.code == GoogleAuthErrorCodes.androidCanceledCode) {
        return const Left(AuthCanceledFailure('Đã hủy đăng nhập Google.'));
      }
      if (e.code == GoogleAuthErrorCodes.networkError ||
          e.code == GoogleAuthErrorCodes.apiNotConnected) {
        return const Left(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Wi-Fi hoặc 4G/5G của bạn.'));
      }
      return const Left(AuthFailure('Không thể đăng nhập bằng Google lúc này. Vui lòng thử lại sau.'));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> signInAnonymously() {
    return safeApiCall(() async {
      debugPrint('[HomeSync Auth] Đang bắt đầu đăng nhập ẩn danh (Guest Mode)...');
      final response = await _remoteDataSource.signInAnonymously();
      final user = response.user;
      if (user == null) {
        throw const AuthException('Không thể tạo phiên đăng nhập ẩn danh.');
      }
      debugPrint('[HomeSync Auth] Đăng nhập ẩn danh thành công! User ID: ${user.id}');
      return _toEntity(user);
    });
  }

  @override
  Future<Either<Failure, AuthUserEntity>> linkWithGoogle() async {
    try {
      final previousUser = _remoteDataSource.currentUser;
      final wasAnonymous = previousUser?.isAnonymous ?? false;
      final previousUserId = previousUser?.id;

      return await safeApiCall(() async {
        debugPrint('[HomeSync Auth] Đang bắt đầu liên kết tài khoản ẩn danh hiện tại với Google...');
        final response = await _remoteDataSource.linkWithGoogle();
        final user = response.user;
        if (user == null) {
          throw const AuthException('Không thể liên kết tài khoản Google.');
        }

        // Kiểm tra xung đột: Nếu là Guest nhưng Google ID trả về thuộc User cũ
        if (wasAnonymous && previousUserId != null && user.id != previousUserId) {
          debugPrint('[HomeSync Auth] Phát hiện Google (${user.email}) ĐÃ TỒN TẠI trước đó (ID: ${user.id} != Guest: $previousUserId)');
          
          await _remoteDataSource.signOut();
          await _remoteDataSource.signInAnonymously();

          return Left(AuthAccountAlreadyExistsFailure(
            'Tài khoản Google này đã tồn tại trên hệ thống.',
            user.email,
          )) as dynamic;
        }

        debugPrint('[HomeSync Auth] Liên kết Google thành công! User ID: ${user.id}');
        return _toEntity(user);
      });
    } on GoogleSignInException catch (e) {
      debugPrint('[HomeSync Auth] Lỗi GoogleSignInException khi liên kết: ${e.code} - ${e.description}');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Left(AuthCanceledFailure('Đã hủy thao tác liên kết.'));
      }
      return const Left(AuthFailure('Không thể liên kết tài khoản Google lúc này. Vui lòng thử lại sau.'));
    } on PlatformException catch (e) {
      debugPrint('[HomeSync Auth] Lỗi PlatformException khi liên kết Google: ${e.code} - ${e.message}');
      if (e.code == GoogleAuthErrorCodes.canceled ||
          e.code == GoogleAuthErrorCodes.androidCanceledCode) {
        return const Left(AuthCanceledFailure('Đã hủy thao tác liên kết.'));
      }
      if (e.code == GoogleAuthErrorCodes.networkError ||
          e.code == GoogleAuthErrorCodes.apiNotConnected) {
        return const Left(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Wi-Fi hoặc 4G/5G của bạn.'));
      }
      return const Left(AuthFailure('Không thể liên kết tài khoản Google lúc này. Vui lòng thử lại sau.'));
    } catch (e) {
      debugPrint('[HomeSync Auth] Lỗi không xác định khi liên kết Google: $e');
      return const Left(AuthFailure('Đã xảy ra sự cố khi liên kết tài khoản Google.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() {
    return safeApiCall(() async {
      await _remoteDataSource.signOut();
      return unit;
    });
  }

  @override
  AuthUserEntity? getCurrentUser() {
    final user = _remoteDataSource.currentUser;
    if (user == null) return null;
    return _toEntity(user);
  }

  @override
  Stream<AuthState> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  Future<Either<Failure, Unit>> updatePlayerId(String playerId) async {
    try {
      await _remoteDataSource.updatePlayerId(playerId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  AuthUserEntity _toEntity(User user) {
    return AuthUserEntity(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?['full_name'] as String? ?? user.userMetadata?['name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String? ?? user.userMetadata?['picture'] as String?,
      isAnonymous: user.isAnonymous,
    );
  }
}
