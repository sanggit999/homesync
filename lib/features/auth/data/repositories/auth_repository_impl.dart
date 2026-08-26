import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/core/config/app_config.dart';
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
}

/// Remote Data Source xử lý giao tiếp Supabase Auth & Google Sign-In SDK
class AuthRemoteDataSource {
  AuthRemoteDataSource({
    SupabaseClient? client,
    GoogleSignIn? googleSignIn,
  })  : _client = client ?? Supabase.instance.client,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              serverClientId: AppConfig.googleWebClientId,
            );

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

/// Repository Implementation của AuthRepository sử dụng fpdart `Either<Failure, T>`
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AuthUserEntity>> signInWithGoogle() async {
    try {
      debugPrint('[HomeSync Auth] Đang bắt đầu đăng nhập bằng tài khoản Google...');
      final response = await _remoteDataSource.signInWithGoogle();
      final user = response.user;
      if (user == null) {
        debugPrint('[HomeSync Auth] Đăng nhập Google thành công nhưng không lấy được User.');
        return const Left(AuthFailure('Không lấy được thông tin người dùng từ Google.'));
      }
      debugPrint('[HomeSync Auth] Đăng nhập Google thành công! User ID: ${user.id}');
      return Right(_toEntity(user));
    } on GoogleSignInException catch (e) {
      debugPrint('[HomeSync Auth] Lỗi GoogleSignInException khi đăng nhập: ${e.code} - ${e.description}');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Left(AuthCanceledFailure('Đã hủy đăng nhập Google.'));
      }
      return Left(AuthFailure(e.description ?? 'Đăng nhập Google thất bại.'));
    } on PlatformException catch (e) {
      debugPrint('[HomeSync Auth] Lỗi PlatformException khi đăng nhập Google: ${e.code} - ${e.message}');
      if (e.code == GoogleAuthErrorCodes.canceled ||
          e.code == GoogleAuthErrorCodes.androidCanceledCode) {
        return const Left(AuthCanceledFailure('Đã hủy đăng nhập Google.'));
      }
      return Left(AuthFailure(e.message ?? 'Đăng nhập Google thất bại.'));
    } on AuthException catch (e) {
      debugPrint('[HomeSync Auth] Lỗi Supabase AuthException: [${e.statusCode}] ${e.message}');
      return Left(AuthFailure(e.message));
    } catch (e) {
      debugPrint('[HomeSync Auth] Lỗi không xác định khi đăng nhập Google: $e');
      return const Left(AuthFailure('Đã xảy ra lỗi khi đăng nhập Google.'));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> signInAnonymously() async {
    try {
      debugPrint('[HomeSync Auth] Đang bắt đầu đăng nhập ẩn danh (Guest Mode)...');
      final response = await _remoteDataSource.signInAnonymously();
      final user = response.user;
      if (user == null) {
        debugPrint('[HomeSync Auth] Đăng nhập ẩn danh thành công nhưng user trả về null.');
        return const Left(AuthFailure('Không thể tạo phiên đăng nhập ẩn danh.'));
      }
      debugPrint('[HomeSync Auth] Đăng nhập ẩn danh thành công! User ID: ${user.id}');
      return Right(_toEntity(user));
    } on AuthException catch (e) {
      debugPrint('[HomeSync Auth] Lỗi Supabase AuthException: [${e.statusCode}] ${e.message}');
      if (e.statusCode == SupabaseAuthStatusCodes.unprocessableEntity ||
          e.code == SupabaseAuthStatusCodes.anonymousDisabled) {
        debugPrint('[HomeSync Auth] GỢI Ý: Lỗi 422 do chưa BẬT "Anonymous Sign-In" trên Supabase Dashboard!');
      }
      return Left(AuthFailure(e.message));
    } catch (e) {
      debugPrint('[HomeSync Auth] Lỗi không xác định khi đăng nhập ẩn danh: $e');
      return const Left(AuthFailure('Không thể kết nối phiên dùng thử.'));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> linkWithGoogle() async {
    try {
      debugPrint('[HomeSync Auth] Đang bắt đầu liên kết tài khoản ẩn danh hiện tại với Google...');
      final response = await _remoteDataSource.linkWithGoogle();
      final user = response.user;
      if (user == null) {
        debugPrint('[HomeSync Auth] Liên kết Google thành công nhưng User nhận được là null.');
        return const Left(AuthFailure('Không thể liên kết tài khoản Google.'));
      }
      debugPrint('[HomeSync Auth] Liên kết Google thành công! User ID: ${user.id}');
      return Right(_toEntity(user));
    } on GoogleSignInException catch (e) {
      debugPrint('[HomeSync Auth] Lỗi GoogleSignInException khi liên kết: ${e.code} - ${e.description}');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Left(AuthCanceledFailure('Đã hủy thao tác liên kết.'));
      }
      return Left(AuthFailure(e.description ?? 'Liên kết tài khoản Google thất bại.'));
    } on PlatformException catch (e) {
      debugPrint('[HomeSync Auth] Lỗi PlatformException khi liên kết Google: ${e.code} - ${e.message}');
      if (e.code == GoogleAuthErrorCodes.canceled ||
          e.code == GoogleAuthErrorCodes.androidCanceledCode) {
        return const Left(AuthCanceledFailure('Đã hủy thao tác liên kết.'));
      }
      return Left(AuthFailure(e.message ?? 'Liên kết tài khoản Google thất bại.'));
    } on AuthException catch (e) {
      debugPrint('[HomeSync Auth] Lỗi Supabase AuthException: [${e.statusCode}] ${e.message}');
      return Left(AuthFailure(e.message));
    } catch (e) {
      debugPrint('[HomeSync Auth] Lỗi không xác định khi liên kết Google: $e');
      return const Left(AuthFailure('Đã xảy ra sự cố khi liên kết tài khoản Google.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
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
