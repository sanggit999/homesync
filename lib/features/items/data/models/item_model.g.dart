// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => _ItemModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  homeId: json['home_id'] as String?,
  categoryId: json['category_id'] as String?,
  categoryName: json['category_name'] as String?,
  categoryIcon: json['category_icon'] as String?,
  name: json['name'] as String,
  brand: json['brand'] as String?,
  modelNumber: json['model_number'] as String?,
  serialNumber: json['serial_number'] as String?,
  location: json['location'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  storeName: json['store_name'] as String?,
  status: json['status'] as String? ?? 'active',
  isFavorite: json['is_favorite'] as bool? ?? false,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  purchaseDate: DateTime.parse(json['purchase_date'] as String),
  warrantyPeriodMonths: (json['warranty_period_months'] as num?)?.toInt(),
  warrantyExpiryDate: DateTime.parse(json['warranty_expiry_date'] as String),
  warrantyType: json['warranty_type'] as String? ?? 'standard',
  supportPhone: json['support_phone'] as String?,
  deviceImageUrl: json['device_image_url'] as String?,
  receiptImageUrl: json['receipt_image_url'] as String?,
  warrantyCardImageUrl: json['warranty_card_image_url'] as String?,
  manualUrl: json['manual_url'] as String?,
  notes: json['notes'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ItemModelToJson(_ItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'home_id': instance.homeId,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'category_icon': instance.categoryIcon,
      'name': instance.name,
      'brand': instance.brand,
      'model_number': instance.modelNumber,
      'serial_number': instance.serialNumber,
      'location': instance.location,
      'price': instance.price,
      'store_name': instance.storeName,
      'status': instance.status,
      'is_favorite': instance.isFavorite,
      'tags': instance.tags,
      'purchase_date': instance.purchaseDate.toIso8601String(),
      'warranty_period_months': instance.warrantyPeriodMonths,
      'warranty_expiry_date': instance.warrantyExpiryDate.toIso8601String(),
      'warranty_type': instance.warrantyType,
      'support_phone': instance.supportPhone,
      'device_image_url': instance.deviceImageUrl,
      'receipt_image_url': instance.receiptImageUrl,
      'warranty_card_image_url': instance.warrantyCardImageUrl,
      'manual_url': instance.manualUrl,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
    };
