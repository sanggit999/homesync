/// Entity đại diện cho Nhà / Căn hộ
class HomeEntity {
  const HomeEntity({
    required this.id,
    required this.ownerId,
    required this.name,
    this.address,
    this.createdAt,
  });

  final String id;
  final String ownerId;
  final String name;
  final String? address;
  final DateTime? createdAt;
}
