import '../../domain/entities/profile_entity.dart';
import '../models/profile_model.dart';

/// Bộ chuyển đổi 2 chiều giữa ProfileModel và ProfileEntity
class ProfileMapper {
  ProfileMapper._();

  static ProfileEntity toEntity(ProfileModel model) {
    return ProfileEntity(
      id: model.id,
      fullName: model.fullName,
      avatarUrl: model.avatarUrl,
      oneSignalPlayerId: model.oneSignalPlayerId,
      reminderDaysBefore: model.reminderDaysBefore,
      notifyWarranty: model.notifyWarranty,
      notifyMaintenance: model.notifyMaintenance,
      updatedAt: model.updatedAt,
    );
  }

  static ProfileModel toModel(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      fullName: entity.fullName,
      avatarUrl: entity.avatarUrl,
      oneSignalPlayerId: entity.oneSignalPlayerId,
      reminderDaysBefore: entity.reminderDaysBefore,
      notifyWarranty: entity.notifyWarranty,
      notifyMaintenance: entity.notifyMaintenance,
      updatedAt: entity.updatedAt,
    );
  }
}
