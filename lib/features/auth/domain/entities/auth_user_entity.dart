/// Entity người dùng sau khi xác thực
class AuthUserEntity {
  const AuthUserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.isAnonymous = false,
  });

  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final bool isAnonymous;
}
