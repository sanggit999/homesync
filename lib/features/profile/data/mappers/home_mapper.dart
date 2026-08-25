import '../../domain/entities/home_entity.dart';
import '../models/home_member_model.dart';
import '../models/home_model.dart';

/// Bộ chuyển đổi 2 chiều giữa HomeModel / HomeMemberModel và HomeEntity / HomeMemberEntity
class HomeMapper {
  HomeMapper._();

  static HomeEntity toEntity(HomeModel model) {
    return HomeEntity(
      id: model.id,
      ownerId: model.ownerId,
      name: model.name,
      address: model.address,
      createdAt: model.createdAt,
    );
  }

  static HomeModel toModel(HomeEntity entity) {
    return HomeModel(
      id: entity.id,
      ownerId: entity.ownerId,
      name: entity.name,
      address: entity.address,
      createdAt: entity.createdAt,
    );
  }

  static HomeMemberEntity memberToEntity(HomeMemberModel model) {
    return HomeMemberEntity(
      id: model.id,
      homeId: model.homeId,
      userId: model.userId,
      role: model.role,
      userFullName: model.userFullName,
      userEmail: model.userEmail,
      userAvatarUrl: model.userAvatarUrl,
      createdAt: model.createdAt,
    );
  }

  static HomeMemberModel memberToModel(HomeMemberEntity entity) {
    return HomeMemberModel(
      id: entity.id,
      homeId: entity.homeId,
      userId: entity.userId,
      role: entity.role,
      userFullName: entity.userFullName,
      userEmail: entity.userEmail,
      userAvatarUrl: entity.userAvatarUrl,
      createdAt: entity.createdAt,
    );
  }
}
