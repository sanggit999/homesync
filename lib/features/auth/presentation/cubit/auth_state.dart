import 'package:home_sync/features/auth/domain/entities/auth_user_entity.dart';

/// Dart 3 Sealed Class cho Authentication State
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class Authenticated extends AuthState {
  const Authenticated({
    required this.user,
    this.isAnonymous = false,
    this.message,
  });

  final AuthUserEntity user;
  final bool isAnonymous;
  final String? message;
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

final class AuthFailureState extends AuthState {
  const AuthFailureState(
    this.message, {
    this.user,
    this.isAnonymous = false,
    this.isCanceled = false,
    this.isAccountAlreadyExists = false,
    this.conflictEmail,
  });

  final String message;
  final AuthUserEntity? user;
  final bool isAnonymous;
  final bool isCanceled;
  final bool isAccountAlreadyExists;
  final String? conflictEmail;
}
