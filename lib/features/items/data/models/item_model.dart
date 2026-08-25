import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

/// Data Model đại diện cho bảng 'items' trên Supabase (DTO với Freezed & JsonSerializable)
@freezed
abstract class ItemModel with _$ItemModel {
  const factory ItemModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'home_id') String? homeId,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'category_name') String? categoryName,
    @JsonKey(name: 'category_icon') String? categoryIcon,
    required String name,
    String? brand,
    @JsonKey(name: 'model_number') String? modelNumber,
    @JsonKey(name: 'serial_number') String? serialNumber,
    String? location,
    double? price,
    @JsonKey(name: 'store_name') String? storeName,
    @Default('active') String status,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
    @Default([]) List<String> tags,
    @JsonKey(name: 'purchase_date') required DateTime purchaseDate,
    @JsonKey(name: 'warranty_period_months') int? warrantyPeriodMonths,
    @JsonKey(name: 'warranty_expiry_date') required DateTime warrantyExpiryDate,
    @JsonKey(name: 'warranty_type') @Default('standard') String warrantyType,
    @JsonKey(name: 'support_phone') String? supportPhone,
    @JsonKey(name: 'device_image_url') String? deviceImageUrl,
    @JsonKey(name: 'receipt_image_url') String? receiptImageUrl,
    @JsonKey(name: 'warranty_card_image_url') String? warrantyCardImageUrl,
    @JsonKey(name: 'manual_url') String? manualUrl,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
}
