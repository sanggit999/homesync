export 'maintenance_preset_entity.dart';

/// Entity đại diện cho Danh mục thiết bị trong Tầng Domain
class CategoryEntity {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconName,
    this.userId,
    this.createdAt,
  });

  final String id;
  final String name;
  final String iconName;
  final String? userId; // null: Danh mục hệ thống mặc định, != null: Danh mục riêng của User
  final DateTime? createdAt;

  /// Kiểm tra xem có phải danh mục mặc định của hệ thống không
  bool get isSystemCategory => userId == null;
}
