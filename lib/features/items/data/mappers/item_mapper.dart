import 'package:home_sync/features/items/domain/entities/item_document_entity.dart';
import 'package:home_sync/features/items/domain/entities/item_entity.dart';
import 'package:home_sync/features/items/data/models/item_document_model.dart';
import 'package:home_sync/features/items/data/models/item_model.dart';

/// Bộ chuyển đổi 2 chiều giữa ItemModel / ItemDocumentModel và ItemEntity / ItemDocumentEntity
class ItemMapper {
  ItemMapper._();

  static ItemEntity toEntity(ItemModel model) {
    return ItemEntity(
      id: model.id,
      userId: model.userId,
      homeId: model.homeId,
      categoryId: model.categoryId,
      categoryName: model.categoryName,
      categoryIcon: model.categoryIcon,
      name: model.name,
      brand: model.brand,
      modelNumber: model.modelNumber,
      serialNumber: model.serialNumber,
      location: model.location,
      price: model.price,
      storeName: model.storeName,
      status: model.status,
      isFavorite: model.isFavorite,
      tags: model.tags,
      purchaseDate: model.purchaseDate,
      warrantyPeriodMonths: model.warrantyPeriodMonths,
      warrantyExpiryDate: model.warrantyExpiryDate,
      warrantyType: model.warrantyType,
      supportPhone: model.supportPhone,
      deviceImageUrl: model.deviceImageUrl,
      receiptImageUrl: model.receiptImageUrl,
      warrantyCardImageUrl: model.warrantyCardImageUrl,
      manualUrl: model.manualUrl,
      notes: model.notes,
      createdAt: model.createdAt,
    );
  }

  static ItemModel toModel(ItemEntity entity) {
    return ItemModel(
      id: entity.id,
      userId: entity.userId,
      homeId: entity.homeId,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      categoryIcon: entity.categoryIcon,
      name: entity.name,
      brand: entity.brand,
      modelNumber: entity.modelNumber,
      serialNumber: entity.serialNumber,
      location: entity.location,
      price: entity.price,
      storeName: entity.storeName,
      status: entity.status,
      isFavorite: entity.isFavorite,
      tags: entity.tags,
      purchaseDate: entity.purchaseDate,
      warrantyPeriodMonths: entity.warrantyPeriodMonths,
      warrantyExpiryDate: entity.warrantyExpiryDate,
      warrantyType: entity.warrantyType,
      supportPhone: entity.supportPhone,
      deviceImageUrl: entity.deviceImageUrl,
      receiptImageUrl: entity.receiptImageUrl,
      warrantyCardImageUrl: entity.warrantyCardImageUrl,
      manualUrl: entity.manualUrl,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  static ItemDocumentEntity documentToEntity(ItemDocumentModel model) {
    return ItemDocumentEntity(
      id: model.id,
      itemId: model.itemId,
      documentType: model.documentType,
      fileName: model.fileName,
      fileUrl: model.fileUrl,
      createdAt: model.createdAt,
    );
  }

  static ItemDocumentModel documentToModel(ItemDocumentEntity entity) {
    return ItemDocumentModel(
      id: entity.id,
      itemId: entity.itemId,
      documentType: entity.documentType,
      fileName: entity.fileName,
      fileUrl: entity.fileUrl,
      createdAt: entity.createdAt,
    );
  }
}
