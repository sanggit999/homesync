import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:home_sync/features/auth/domain/repositories/auth_repository.dart';
import 'package:home_sync/features/auth/domain/usecases/auth_usecases.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSignInAnonymouslyUseCase extends Mock implements SignInAnonymouslyUseCase {}
class MockSignInWithGoogleUseCase extends Mock implements SignInWithGoogleUseCase {}
class MockLinkWithGoogleUseCase extends Mock implements LinkWithGoogleUseCase {}
class MockSignOutUseCase extends Mock implements SignOutUseCase {}
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}
class MockUpdatePlayerIdUseCase extends Mock implements UpdatePlayerIdUseCase {}

void main() {
  late MockSignInAnonymouslyUseCase mockSignInAnonymously;
  late MockSignInWithGoogleUseCase mockSignInWithGoogle;
  late MockLinkWithGoogleUseCase mockLinkWithGoogle;
  late MockSignOutUseCase mockSignOut;
  late MockGetCurrentUserUseCase mockGetCurrentUser;
  late MockUpdatePlayerIdUseCase mockUpdatePlayerId;
  late AuthCubit authCubit;

  const tUser = AuthUserEntity(
    id: 'u-123',
    email: 'user@example.com',
    fullName: 'Test User',
    isAnonymous: false,
  );

  const tGuestUser = AuthUserEntity(
    id: 'guest-123',
    email: '',
    fullName: 'Khách',
    isAnonymous: true,
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockSignInAnonymously = MockSignInAnonymouslyUseCase();
    mockSignInWithGoogle = MockSignInWithGoogleUseCase();
    mockLinkWithGoogle = MockLinkWithGoogleUseCase();
    mockSignOut = MockSignOutUseCase();
    mockGetCurrentUser = MockGetCurrentUserUseCase();
    mockUpdatePlayerId = MockUpdatePlayerIdUseCase();

    authCubit = AuthCubit(
      signInAnonymouslyUseCase: mockSignInAnonymously,
      signInWithGoogleUseCase: mockSignInWithGoogle,
      linkWithGoogleUseCase: mockLinkWithGoogle,
      signOutUseCase: mockSignOut,
      getCurrentUserUseCase: mockGetCurrentUser,
      updatePlayerIdUseCase: mockUpdatePlayerId,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit State Machine Tests', () {
    test('initial state should be AuthInitial', () {
      expect(authCubit.state, isA<AuthInitial>());
    });

    blocTest<AuthCubit, AuthState>(
      'emits [Authenticated] when checkAuthStatus finds an existing session',
      build: () {
        when(() => mockGetCurrentUser(any())).thenReturn(tUser);
        return authCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        isA<Authenticated>().having((s) => s.user.id, 'id', 'u-123'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Unauthenticated] when checkAuthStatus finds no session',
      build: () {
        when(() => mockGetCurrentUser(any())).thenReturn(null);
        return authCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        isA<Unauthenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated(isAnonymous: true)] when signInAnonymously succeeds',
      build: () {
        when(() => mockSignInAnonymously(any())).thenAnswer((_) async => const Right(tGuestUser));
        return authCubit;
      },
      act: (cubit) => cubit.signInAnonymously(),
      expect: () => [
        isA<AuthLoading>(),
        isA<Authenticated>().having((s) => s.isAnonymous, 'isAnonymous', isTrue),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthFailureState] when signInWithGoogle fails',
      build: () {
        when(() => mockSignInWithGoogle(any())).thenAnswer((_) async => const Left(AuthFailure('Lỗi đăng nhập Google')));
        return authCubit;
      },
      act: (cubit) => cubit.signInWithGoogle(),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailureState>().having((s) => s.message, 'message', 'Lỗi đăng nhập Google'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Unauthenticated] when signOut succeeds',
      build: () {
        when(() => mockSignOut(any())).thenAnswer((_) async => const Right(unit));
        return authCubit;
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [
        isA<AuthLoading>(),
        isA<Unauthenticated>(),
      ],
    );
  });
}
