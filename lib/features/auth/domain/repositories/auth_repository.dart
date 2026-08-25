import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/auth_user_entity.dart';
export '../entities/auth_user_entity.dart';

/// Abstract Repository Contract cho Authentication sử dụng Either (fpdart)
abstract class AuthRepository {
  Future<Either<Failure, AuthUserEntity>> signInAnonymously();
  Future<Either<Failure, AuthUserEntity>> signInWithGoogle();
  Future<Either<Failure, AuthUserEntity>> linkWithGoogle();
  Future<Either<Failure, Unit>> signOut();
  AuthUserEntity? getCurrentUser();
  Stream<AuthState> get authStateChanges;
  Future<Either<Failure, Unit>> updatePlayerId(String playerId);
}
