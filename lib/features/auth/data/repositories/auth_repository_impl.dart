import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';

/// Remote Data Source xử lý giao tiếp Supabase Auth & Google Sign-In SDK
class AuthRemoteDataSource {
  AuthRemoteDataSource({
    SupabaseClient? client,
    GoogleSignIn? googleSignIn,
  })  : _client = client ?? Supabase.instance.client,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final SupabaseClient _client;
  final GoogleSignIn _googleSignIn;

  Future<AuthResponse> signInAnonymously() async {
    return _client.auth.signInAnonymously();
  }

  Future<AuthResponse> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthException('Đã hủy đăng nhập Google.');
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw const AuthException('Không nhận được ID Token từ Google.');
    }

    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<AuthResponse> linkWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthException('Đã hủy liên kết tài khoản Google.');
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw const AuthException('Không nhận được ID Token từ Google.');
    }

    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
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
      final response = await _remoteDataSource.signInWithGoogle();
      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure('Không lấy được thông tin người dùng từ Google.'));
      }
      return Right(_toEntity(user));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> signInAnonymously() async {
    try {
      final response = await _remoteDataSource.signInAnonymously();
      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure('Không thể tạo phiên đăng nhập ẩn danh.'));
      }
      return Right(_toEntity(user));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> linkWithGoogle() async {
    try {
      final response = await _remoteDataSource.linkWithGoogle();
      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure('Không thể liên kết tài khoản Google.'));
      }
      return Right(_toEntity(user));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
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
