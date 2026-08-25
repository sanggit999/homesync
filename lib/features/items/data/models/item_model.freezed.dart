// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemModel {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'home_id') String? get homeId;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'category_name') String? get categoryName;@JsonKey(name: 'category_icon') String? get categoryIcon; String get name; String? get brand;@JsonKey(name: 'model_number') String? get modelNumber;@JsonKey(name: 'serial_number') String? get serialNumber; String? get location; double? get price;@JsonKey(name: 'store_name') String? get storeName; String get status;@JsonKey(name: 'is_favorite') bool get isFavorite; List<String> get tags;@JsonKey(name: 'purchase_date') DateTime get purchaseDate;@JsonKey(name: 'warranty_period_months') int? get warrantyPeriodMonths;@JsonKey(name: 'warranty_expiry_date') DateTime get warrantyExpiryDate;@JsonKey(name: 'warranty_type') String get warrantyType;@JsonKey(name: 'support_phone') String? get supportPhone;@JsonKey(name: 'device_image_url') String? get deviceImageUrl;@JsonKey(name: 'receipt_image_url') String? get receiptImageUrl;@JsonKey(name: 'warranty_card_image_url') String? get warrantyCardImageUrl;@JsonKey(name: 'manual_url') String? get manualUrl; String? get notes;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of ItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemModelCopyWith<ItemModel> get copyWith => _$ItemModelCopyWithImpl<ItemModel>(this as ItemModel, _$identity);

  /// Serializes this ItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.homeId, homeId) || other.homeId == homeId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryIcon, categoryIcon) || other.categoryIcon == categoryIcon)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.modelNumber, modelNumber) || other.modelNumber == modelNumber)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.location, location) || other.location == location)&&(identical(other.price, price) || other.price == price)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.warrantyPeriodMonths, warrantyPeriodMonths) || other.warrantyPeriodMonths == warrantyPeriodMonths)&&(identical(other.warrantyExpiryDate, warrantyExpiryDate) || other.warrantyExpiryDate == warrantyExpiryDate)&&(identical(other.warrantyType, warrantyType) || other.warrantyType == warrantyType)&&(identical(other.supportPhone, supportPhone) || other.supportPhone == supportPhone)&&(identical(other.deviceImageUrl, deviceImageUrl) || other.deviceImageUrl == deviceImageUrl)&&(identical(other.receiptImageUrl, receiptImageUrl) || other.receiptImageUrl == receiptImageUrl)&&(identical(other.warrantyCardImageUrl, warrantyCardImageUrl) || other.warrantyCardImageUrl == warrantyCardImageUrl)&&(identical(other.manualUrl, manualUrl) || other.manualUrl == manualUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,homeId,categoryId,categoryName,categoryIcon,name,brand,modelNumber,serialNumber,location,price,storeName,status,isFavorite,const DeepCollectionEquality().hash(tags),purchaseDate,warrantyPeriodMonths,warrantyExpiryDate,warrantyType,supportPhone,deviceImageUrl,receiptImageUrl,warrantyCardImageUrl,manualUrl,notes,createdAt]);

@override
String toString() {
  return 'ItemModel(id: $id, userId: $userId, homeId: $homeId, categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, name: $name, brand: $brand, modelNumber: $modelNumber, serialNumber: $serialNumber, location: $location, price: $price, storeName: $storeName, status: $status, isFavorite: $isFavorite, tags: $tags, purchaseDate: $purchaseDate, warrantyPeriodMonths: $warrantyPeriodMonths, warrantyExpiryDate: $warrantyExpiryDate, warrantyType: $warrantyType, supportPhone: $supportPhone, deviceImageUrl: $deviceImageUrl, receiptImageUrl: $receiptImageUrl, warrantyCardImageUrl: $warrantyCardImageUrl, manualUrl: $manualUrl, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ItemModelCopyWith<$Res>  {
  factory $ItemModelCopyWith(ItemModel value, $Res Function(ItemModel) _then) = _$ItemModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'home_id') String? homeId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'category_name') String? categoryName,@JsonKey(name: 'category_icon') String? categoryIcon, String name, String? brand,@JsonKey(name: 'model_number') String? modelNumber,@JsonKey(name: 'serial_number') String? serialNumber, String? location, double? price,@JsonKey(name: 'store_name') String? storeName, String status,@JsonKey(name: 'is_favorite') bool isFavorite, List<String> tags,@JsonKey(name: 'purchase_date') DateTime purchaseDate,@JsonKey(name: 'warranty_period_months') int? warrantyPeriodMonths,@JsonKey(name: 'warranty_expiry_date') DateTime warrantyExpiryDate,@JsonKey(name: 'warranty_type') String warrantyType,@JsonKey(name: 'support_phone') String? supportPhone,@JsonKey(name: 'device_image_url') String? deviceImageUrl,@JsonKey(name: 'receipt_image_url') String? receiptImageUrl,@JsonKey(name: 'warranty_card_image_url') String? warrantyCardImageUrl,@JsonKey(name: 'manual_url') String? manualUrl, String? notes,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$ItemModelCopyWithImpl<$Res>
    implements $ItemModelCopyWith<$Res> {
  _$ItemModelCopyWithImpl(this._self, this._then);

  final ItemModel _self;
  final $Res Function(ItemModel) _then;

/// Create a copy of ItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? homeId = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? categoryIcon = freezed,Object? name = null,Object? brand = freezed,Object? modelNumber = freezed,Object? serialNumber = freezed,Object? location = freezed,Object? price = freezed,Object? storeName = freezed,Object? status = null,Object? isFavorite = null,Object? tags = null,Object? purchaseDate = null,Object? warrantyPeriodMonths = freezed,Object? warrantyExpiryDate = null,Object? warrantyType = null,Object? supportPhone = freezed,Object? deviceImageUrl = freezed,Object? receiptImageUrl = freezed,Object? warrantyCardImageUrl = freezed,Object? manualUrl = freezed,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(ItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,homeId: freezed == homeId ? _self.homeId : homeId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,categoryIcon: freezed == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,modelNumber: freezed == modelNumber ? _self.modelNumber : modelNumber // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,purchaseDate: null == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,warrantyPeriodMonths: freezed == warrantyPeriodMonths ? _self.warrantyPeriodMonths : warrantyPeriodMonths // ignore: cast_nullable_to_non_nullable
as int?,warrantyExpiryDate: null == warrantyExpiryDate ? _self.warrantyExpiryDate : warrantyExpiryDate // ignore: cast_nullable_to_non_nullable
as DateTime,warrantyType: null == warrantyType ? _self.warrantyType : warrantyType // ignore: cast_nullable_to_non_nullable
as String,supportPhone: freezed == supportPhone ? _self.supportPhone : supportPhone // ignore: cast_nullable_to_non_nullable
as String?,deviceImageUrl: freezed == deviceImageUrl ? _self.deviceImageUrl : deviceImageUrl // ignore: cast_nullable_to_non_nullable
as String?,receiptImageUrl: freezed == receiptImageUrl ? _self.receiptImageUrl : receiptImageUrl // ignore: cast_nullable_to_non_nullable
as String?,warrantyCardImageUrl: freezed == warrantyCardImageUrl ? _self.warrantyCardImageUrl : warrantyCardImageUrl // ignore: cast_nullable_to_non_nullable
as String?,manualUrl: freezed == manualUrl ? _self.manualUrl : manualUrl // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemModel].
extension ItemModelPatterns on ItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemModel value)  $default,){
final _that = this;
switch (_that) {
case _ItemModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _ItemModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'home_id')  String? homeId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'category_name')  String? categoryName, @JsonKey(name: 'category_icon')  String? categoryIcon,  String name,  String? brand, @JsonKey(name: 'model_number')  String? modelNumber, @JsonKey(name: 'serial_number')  String? serialNumber,  String? location,  double? price, @JsonKey(name: 'store_name')  String? storeName,  String status, @JsonKey(name: 'is_favorite')  bool isFavorite,  List<String> tags, @JsonKey(name: 'purchase_date')  DateTime purchaseDate, @JsonKey(name: 'warranty_period_months')  int? warrantyPeriodMonths, @JsonKey(name: 'warranty_expiry_date')  DateTime warrantyExpiryDate, @JsonKey(name: 'warranty_type')  String warrantyType, @JsonKey(name: 'support_phone')  String? supportPhone, @JsonKey(name: 'device_image_url')  String? deviceImageUrl, @JsonKey(name: 'receipt_image_url')  String? receiptImageUrl, @JsonKey(name: 'warranty_card_image_url')  String? warrantyCardImageUrl, @JsonKey(name: 'manual_url')  String? manualUrl,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemModel() when $default != null:
return $default(_that.id,_that.userId,_that.homeId,_that.categoryId,_that.categoryName,_that.categoryIcon,_that.name,_that.brand,_that.modelNumber,_that.serialNumber,_that.location,_that.price,_that.storeName,_that.status,_that.isFavorite,_that.tags,_that.purchaseDate,_that.warrantyPeriodMonths,_that.warrantyExpiryDate,_that.warrantyType,_that.supportPhone,_that.deviceImageUrl,_that.receiptImageUrl,_that.warrantyCardImageUrl,_that.manualUrl,_that.notes,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'home_id')  String? homeId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'category_name')  String? categoryName, @JsonKey(name: 'category_icon')  String? categoryIcon,  String name,  String? brand, @JsonKey(name: 'model_number')  String? modelNumber, @JsonKey(name: 'serial_number')  String? serialNumber,  String? location,  double? price, @JsonKey(name: 'store_name')  String? storeName,  String status, @JsonKey(name: 'is_favorite')  bool isFavorite,  List<String> tags, @JsonKey(name: 'purchase_date')  DateTime purchaseDate, @JsonKey(name: 'warranty_period_months')  int? warrantyPeriodMonths, @JsonKey(name: 'warranty_expiry_date')  DateTime warrantyExpiryDate, @JsonKey(name: 'warranty_type')  String warrantyType, @JsonKey(name: 'support_phone')  String? supportPhone, @JsonKey(name: 'device_image_url')  String? deviceImageUrl, @JsonKey(name: 'receipt_image_url')  String? receiptImageUrl, @JsonKey(name: 'warranty_card_image_url')  String? warrantyCardImageUrl, @JsonKey(name: 'manual_url')  String? manualUrl,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ItemModel():
return $default(_that.id,_that.userId,_that.homeId,_that.categoryId,_that.categoryName,_that.categoryIcon,_that.name,_that.brand,_that.modelNumber,_that.serialNumber,_that.location,_that.price,_that.storeName,_that.status,_that.isFavorite,_that.tags,_that.purchaseDate,_that.warrantyPeriodMonths,_that.warrantyExpiryDate,_that.warrantyType,_that.supportPhone,_that.deviceImageUrl,_that.receiptImageUrl,_that.warrantyCardImageUrl,_that.manualUrl,_that.notes,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'home_id')  String? homeId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'category_name')  String? categoryName, @JsonKey(name: 'category_icon')  String? categoryIcon,  String name,  String? brand, @JsonKey(name: 'model_number')  String? modelNumber, @JsonKey(name: 'serial_number')  String? serialNumber,  String? location,  double? price, @JsonKey(name: 'store_name')  String? storeName,  String status, @JsonKey(name: 'is_favorite')  bool isFavorite,  List<String> tags, @JsonKey(name: 'purchase_date')  DateTime purchaseDate, @JsonKey(name: 'warranty_period_months')  int? warrantyPeriodMonths, @JsonKey(name: 'warranty_expiry_date')  DateTime warrantyExpiryDate, @JsonKey(name: 'warranty_type')  String warrantyType, @JsonKey(name: 'support_phone')  String? supportPhone, @JsonKey(name: 'device_image_url')  String? deviceImageUrl, @JsonKey(name: 'receipt_image_url')  String? receiptImageUrl, @JsonKey(name: 'warranty_card_image_url')  String? warrantyCardImageUrl, @JsonKey(name: 'manual_url')  String? manualUrl,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ItemModel() when $default != null:
return $default(_that.id,_that.userId,_that.homeId,_that.categoryId,_that.categoryName,_that.categoryIcon,_that.name,_that.brand,_that.modelNumber,_that.serialNumber,_that.location,_that.price,_that.storeName,_that.status,_that.isFavorite,_that.tags,_that.purchaseDate,_that.warrantyPeriodMonths,_that.warrantyExpiryDate,_that.warrantyType,_that.supportPhone,_that.deviceImageUrl,_that.receiptImageUrl,_that.warrantyCardImageUrl,_that.manualUrl,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemModel implements ItemModel {
  const _ItemModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'home_id') this.homeId, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'category_name') this.categoryName, @JsonKey(name: 'category_icon') this.categoryIcon, required this.name, this.brand, @JsonKey(name: 'model_number') this.modelNumber, @JsonKey(name: 'serial_number') this.serialNumber, this.location, this.price, @JsonKey(name: 'store_name') this.storeName, this.status = 'active', @JsonKey(name: 'is_favorite') this.isFavorite = false,  List<String> tags = const [], @JsonKey(name: 'purchase_date') required this.purchaseDate, @JsonKey(name: 'warranty_period_months') this.warrantyPeriodMonths, @JsonKey(name: 'warranty_expiry_date') required this.warrantyExpiryDate, @JsonKey(name: 'warranty_type') this.warrantyType = 'standard', @JsonKey(name: 'support_phone') this.supportPhone, @JsonKey(name: 'device_image_url') this.deviceImageUrl, @JsonKey(name: 'receipt_image_url') this.receiptImageUrl, @JsonKey(name: 'warranty_card_image_url') this.warrantyCardImageUrl, @JsonKey(name: 'manual_url') this.manualUrl, this.notes, @JsonKey(name: 'created_at') this.createdAt}): _tags = tags;
  factory _ItemModel.fromJson(Map<String, dynamic> json) => _$ItemModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'home_id') final  String? homeId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'category_name') final  String? categoryName;
@override@JsonKey(name: 'category_icon') final  String? categoryIcon;
@override final  String name;
@override final  String? brand;
@override@JsonKey(name: 'model_number') final  String? modelNumber;
@override@JsonKey(name: 'serial_number') final  String? serialNumber;
@override final  String? location;
@override final  double? price;
@override@JsonKey(name: 'store_name') final  String? storeName;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'is_favorite') final  bool isFavorite;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey(name: 'purchase_date') final  DateTime purchaseDate;
@override@JsonKey(name: 'warranty_period_months') final  int? warrantyPeriodMonths;
@override@JsonKey(name: 'warranty_expiry_date') final  DateTime warrantyExpiryDate;
@override@JsonKey(name: 'warranty_type') final  String warrantyType;
@override@JsonKey(name: 'support_phone') final  String? supportPhone;
@override@JsonKey(name: 'device_image_url') final  String? deviceImageUrl;
@override@JsonKey(name: 'receipt_image_url') final  String? receiptImageUrl;
@override@JsonKey(name: 'warranty_card_image_url') final  String? warrantyCardImageUrl;
@override@JsonKey(name: 'manual_url') final  String? manualUrl;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of ItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemModelCopyWith<_ItemModel> get copyWith => __$ItemModelCopyWithImpl<_ItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.homeId, homeId) || other.homeId == homeId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryIcon, categoryIcon) || other.categoryIcon == categoryIcon)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.modelNumber, modelNumber) || other.modelNumber == modelNumber)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.location, location) || other.location == location)&&(identical(other.price, price) || other.price == price)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.warrantyPeriodMonths, warrantyPeriodMonths) || other.warrantyPeriodMonths == warrantyPeriodMonths)&&(identical(other.warrantyExpiryDate, warrantyExpiryDate) || other.warrantyExpiryDate == warrantyExpiryDate)&&(identical(other.warrantyType, warrantyType) || other.warrantyType == warrantyType)&&(identical(other.supportPhone, supportPhone) || other.supportPhone == supportPhone)&&(identical(other.deviceImageUrl, deviceImageUrl) || other.deviceImageUrl == deviceImageUrl)&&(identical(other.receiptImageUrl, receiptImageUrl) || other.receiptImageUrl == receiptImageUrl)&&(identical(other.warrantyCardImageUrl, warrantyCardImageUrl) || other.warrantyCardImageUrl == warrantyCardImageUrl)&&(identical(other.manualUrl, manualUrl) || other.manualUrl == manualUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,homeId,categoryId,categoryName,categoryIcon,name,brand,modelNumber,serialNumber,location,price,storeName,status,isFavorite,const DeepCollectionEquality().hash(_tags),purchaseDate,warrantyPeriodMonths,warrantyExpiryDate,warrantyType,supportPhone,deviceImageUrl,receiptImageUrl,warrantyCardImageUrl,manualUrl,notes,createdAt]);

@override
String toString() {
  return 'ItemModel(id: $id, userId: $userId, homeId: $homeId, categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, name: $name, brand: $brand, modelNumber: $modelNumber, serialNumber: $serialNumber, location: $location, price: $price, storeName: $storeName, status: $status, isFavorite: $isFavorite, tags: $tags, purchaseDate: $purchaseDate, warrantyPeriodMonths: $warrantyPeriodMonths, warrantyExpiryDate: $warrantyExpiryDate, warrantyType: $warrantyType, supportPhone: $supportPhone, deviceImageUrl: $deviceImageUrl, receiptImageUrl: $receiptImageUrl, warrantyCardImageUrl: $warrantyCardImageUrl, manualUrl: $manualUrl, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ItemModelCopyWith<$Res> implements $ItemModelCopyWith<$Res> {
  factory _$ItemModelCopyWith(_ItemModel value, $Res Function(_ItemModel) _then) = __$ItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'home_id') String? homeId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'category_name') String? categoryName,@JsonKey(name: 'category_icon') String? categoryIcon, String name, String? brand,@JsonKey(name: 'model_number') String? modelNumber,@JsonKey(name: 'serial_number') String? serialNumber, String? location, double? price,@JsonKey(name: 'store_name') String? storeName, String status,@JsonKey(name: 'is_favorite') bool isFavorite, List<String> tags,@JsonKey(name: 'purchase_date') DateTime purchaseDate,@JsonKey(name: 'warranty_period_months') int? warrantyPeriodMonths,@JsonKey(name: 'warranty_expiry_date') DateTime warrantyExpiryDate,@JsonKey(name: 'warranty_type') String warrantyType,@JsonKey(name: 'support_phone') String? supportPhone,@JsonKey(name: 'device_image_url') String? deviceImageUrl,@JsonKey(name: 'receipt_image_url') String? receiptImageUrl,@JsonKey(name: 'warranty_card_image_url') String? warrantyCardImageUrl,@JsonKey(name: 'manual_url') String? manualUrl, String? notes,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$ItemModelCopyWithImpl<$Res>
    implements _$ItemModelCopyWith<$Res> {
  __$ItemModelCopyWithImpl(this._self, this._then);

  final _ItemModel _self;
  final $Res Function(_ItemModel) _then;

/// Create a copy of ItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? homeId = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? categoryIcon = freezed,Object? name = null,Object? brand = freezed,Object? modelNumber = freezed,Object? serialNumber = freezed,Object? location = freezed,Object? price = freezed,Object? storeName = freezed,Object? status = null,Object? isFavorite = null,Object? tags = null,Object? purchaseDate = null,Object? warrantyPeriodMonths = freezed,Object? warrantyExpiryDate = null,Object? warrantyType = null,Object? supportPhone = freezed,Object? deviceImageUrl = freezed,Object? receiptImageUrl = freezed,Object? warrantyCardImageUrl = freezed,Object? manualUrl = freezed,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(_ItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,homeId: freezed == homeId ? _self.homeId : homeId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,categoryIcon: freezed == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,modelNumber: freezed == modelNumber ? _self.modelNumber : modelNumber // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,purchaseDate: null == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,warrantyPeriodMonths: freezed == warrantyPeriodMonths ? _self.warrantyPeriodMonths : warrantyPeriodMonths // ignore: cast_nullable_to_non_nullable
as int?,warrantyExpiryDate: null == warrantyExpiryDate ? _self.warrantyExpiryDate : warrantyExpiryDate // ignore: cast_nullable_to_non_nullable
as DateTime,warrantyType: null == warrantyType ? _self.warrantyType : warrantyType // ignore: cast_nullable_to_non_nullable
as String,supportPhone: freezed == supportPhone ? _self.supportPhone : supportPhone // ignore: cast_nullable_to_non_nullable
as String?,deviceImageUrl: freezed == deviceImageUrl ? _self.deviceImageUrl : deviceImageUrl // ignore: cast_nullable_to_non_nullable
as String?,receiptImageUrl: freezed == receiptImageUrl ? _self.receiptImageUrl : receiptImageUrl // ignore: cast_nullable_to_non_nullable
as String?,warrantyCardImageUrl: freezed == warrantyCardImageUrl ? _self.warrantyCardImageUrl : warrantyCardImageUrl // ignore: cast_nullable_to_non_nullable
as String?,manualUrl: freezed == manualUrl ? _self.manualUrl : manualUrl // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
