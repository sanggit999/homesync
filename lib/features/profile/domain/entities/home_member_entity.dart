/// Entity đại diện cho Thành viên trong Nhà
class HomeMemberEntity {
  const HomeMemberEntity({
    required this.id,
    required this.homeId,
    required this.userId,
    this.role = 'member', // 'owner', 'admin', 'member', 'viewer'
    this.userFullName,
    this.userEmail,
    this.userAvatarUrl,
    this.createdAt,
  });

  final String id;
  final String homeId;
  final String userId;
  final String role;
  final String? userFullName;
  final String? userEmail;
  final String? userAvatarUrl;
  final DateTime? createdAt;
}
