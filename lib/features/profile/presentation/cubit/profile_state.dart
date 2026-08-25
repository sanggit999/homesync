import '../../domain/entities/home_entity.dart';
import '../../domain/entities/profile_entity.dart';

/// Dart 3 Sealed Class cho Profile State
sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.profile,
    this.homes = const [],
    this.members = const [],
  });

  final ProfileEntity profile;
  final List<HomeEntity> homes;
  final List<HomeMemberEntity> members;

  ProfileLoaded copyWith({
    ProfileEntity? profile,
    List<HomeEntity>? homes,
    List<HomeMemberEntity>? members,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      homes: homes ?? this.homes,
      members: members ?? this.members,
    );
  }
}

final class ProfileUpdatedSuccess extends ProfileState {
  const ProfileUpdatedSuccess(this.profile);
  final ProfileEntity profile;
}

final class ProfileError extends ProfileState {
  const ProfileError(this.message);
  final String message;
}
