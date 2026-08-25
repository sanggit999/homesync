import 'package:home_sync/core/utils/warranty_calculator.dart';

/// Entity đại diện cho Thiết bị / Tài sản trong gia đình
class ItemEntity {
  const ItemEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.purchaseDate,
    required this.warrantyExpiryDate,
    this.homeId,
    this.categoryId,
    this.categoryName,
    this.categoryIcon,
    this.brand,
    this.modelNumber,
    this.serialNumber,
    this.location,
    this.price,
    this.storeName,
    this.status = 'active',
    this.isFavorite = false,
    this.tags = const [],
    this.warrantyPeriodMonths,
    this.warrantyType = 'standard',
    this.supportPhone,
    this.deviceImageUrl,
    this.receiptImageUrl,
    this.warrantyCardImageUrl,
    this.manualUrl,
    this.notes,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String? homeId;
  final String? categoryId;
  final String? categoryName;
  final String? categoryIcon;

  final String name;
  final String? brand;
  final String? modelNumber;
  final String? serialNumber;
  final String? location;
  final double? price;
  final String? storeName;
  final String status;
  final bool isFavorite;
  final List<String> tags;

  final DateTime purchaseDate;
  final int? warrantyPeriodMonths;
  final DateTime warrantyExpiryDate;
  final String warrantyType;
  final String? supportPhone;

  final String? deviceImageUrl;
  final String? receiptImageUrl;
  final String? warrantyCardImageUrl;
  final String? manualUrl;
  final String? notes;
  final DateTime? createdAt;

  /// Số ngày còn lại của bảo hành
  int get remainingDays => WarrantyCalculator.calculateDaysRemaining(warrantyExpiryDate);

  /// Tiến độ bảo hành (0.0: vừa mua -> 1.0: hết hạn)
  double get warrantyProgress => WarrantyCalculator.calculateProgress(
        purchaseDate: purchaseDate,
        expiryDate: warrantyExpiryDate,
      );

  /// Trạng thái bảo hành
  WarrantyStatus get warrantyStatus => WarrantyCalculator.getStatus(warrantyExpiryDate);

  /// Tình trạng thiết bị tốt (còn bảo hành > 30 ngày)
  bool get isGood => warrantyStatus == WarrantyStatus.good;

  /// Thiết bị sắp hết hạn (<= 30 ngày)
  bool get isWarning => warrantyStatus == WarrantyStatus.expiringSoon;

  /// Thiết bị đã hết hạn bảo hành
  bool get isExpired => warrantyStatus == WarrantyStatus.expired;
}
