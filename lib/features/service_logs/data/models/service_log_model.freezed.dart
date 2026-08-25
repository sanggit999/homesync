// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceLogModel {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'item_id') String get itemId;@JsonKey(name: 'task_id') String? get taskId;@JsonKey(name: 'item_name') String? get itemName;@JsonKey(name: 'service_type') String get serviceType; String get title;@JsonKey(name: 'service_date') DateTime get serviceDate; double get cost;@JsonKey(name: 'technician_name') String? get technicianName;@JsonKey(name: 'technician_phone') String? get technicianPhone;@JsonKey(name: 'receipt_image_url') String? get receiptImageUrl; String? get notes;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of ServiceLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceLogModelCopyWith<ServiceLogModel> get copyWith => _$ServiceLogModelCopyWithImpl<ServiceLogModel>(this as ServiceLogModel, _$identity);

  /// Serializes this ServiceLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.title, title) || other.title == title)&&(identical(other.serviceDate, serviceDate) || other.serviceDate == serviceDate)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.technicianPhone, technicianPhone) || other.technicianPhone == technicianPhone)&&(identical(other.receiptImageUrl, receiptImageUrl) || other.receiptImageUrl == receiptImageUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,itemId,taskId,itemName,serviceType,title,serviceDate,cost,technicianName,technicianPhone,receiptImageUrl,notes,createdAt);

@override
String toString() {
  return 'ServiceLogModel(id: $id, userId: $userId, itemId: $itemId, taskId: $taskId, itemName: $itemName, serviceType: $serviceType, title: $title, serviceDate: $serviceDate, cost: $cost, technicianName: $technicianName, technicianPhone: $technicianPhone, receiptImageUrl: $receiptImageUrl, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ServiceLogModelCopyWith<$Res>  {
  factory $ServiceLogModelCopyWith(ServiceLogModel value, $Res Function(ServiceLogModel) _then) = _$ServiceLogModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'task_id') String? taskId,@JsonKey(name: 'item_name') String? itemName,@JsonKey(name: 'service_type') String serviceType, String title,@JsonKey(name: 'service_date') DateTime serviceDate, double cost,@JsonKey(name: 'technician_name') String? technicianName,@JsonKey(name: 'technician_phone') String? technicianPhone,@JsonKey(name: 'receipt_image_url') String? receiptImageUrl, String? notes,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$ServiceLogModelCopyWithImpl<$Res>
    implements $ServiceLogModelCopyWith<$Res> {
  _$ServiceLogModelCopyWithImpl(this._self, this._then);

  final ServiceLogModel _self;
  final $Res Function(ServiceLogModel) _then;

/// Create a copy of ServiceLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? itemId = null,Object? taskId = freezed,Object? itemName = freezed,Object? serviceType = null,Object? title = null,Object? serviceDate = null,Object? cost = null,Object? technicianName = freezed,Object? technicianPhone = freezed,Object? receiptImageUrl = freezed,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(ServiceLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,serviceDate: null == serviceDate ? _self.serviceDate : serviceDate // ignore: cast_nullable_to_non_nullable
as DateTime,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,technicianName: freezed == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String?,technicianPhone: freezed == technicianPhone ? _self.technicianPhone : technicianPhone // ignore: cast_nullable_to_non_nullable
as String?,receiptImageUrl: freezed == receiptImageUrl ? _self.receiptImageUrl : receiptImageUrl // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceLogModel].
extension ServiceLogModelPatterns on ServiceLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceLogModel value)  $default,){
final _that = this;
switch (_that) {
case _ServiceLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'task_id')  String? taskId, @JsonKey(name: 'item_name')  String? itemName, @JsonKey(name: 'service_type')  String serviceType,  String title, @JsonKey(name: 'service_date')  DateTime serviceDate,  double cost, @JsonKey(name: 'technician_name')  String? technicianName, @JsonKey(name: 'technician_phone')  String? technicianPhone, @JsonKey(name: 'receipt_image_url')  String? receiptImageUrl,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceLogModel() when $default != null:
return $default(_that.id,_that.userId,_that.itemId,_that.taskId,_that.itemName,_that.serviceType,_that.title,_that.serviceDate,_that.cost,_that.technicianName,_that.technicianPhone,_that.receiptImageUrl,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'task_id')  String? taskId, @JsonKey(name: 'item_name')  String? itemName, @JsonKey(name: 'service_type')  String serviceType,  String title, @JsonKey(name: 'service_date')  DateTime serviceDate,  double cost, @JsonKey(name: 'technician_name')  String? technicianName, @JsonKey(name: 'technician_phone')  String? technicianPhone, @JsonKey(name: 'receipt_image_url')  String? receiptImageUrl,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ServiceLogModel():
return $default(_that.id,_that.userId,_that.itemId,_that.taskId,_that.itemName,_that.serviceType,_that.title,_that.serviceDate,_that.cost,_that.technicianName,_that.technicianPhone,_that.receiptImageUrl,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'task_id')  String? taskId, @JsonKey(name: 'item_name')  String? itemName, @JsonKey(name: 'service_type')  String serviceType,  String title, @JsonKey(name: 'service_date')  DateTime serviceDate,  double cost, @JsonKey(name: 'technician_name')  String? technicianName, @JsonKey(name: 'technician_phone')  String? technicianPhone, @JsonKey(name: 'receipt_image_url')  String? receiptImageUrl,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ServiceLogModel() when $default != null:
return $default(_that.id,_that.userId,_that.itemId,_that.taskId,_that.itemName,_that.serviceType,_that.title,_that.serviceDate,_that.cost,_that.technicianName,_that.technicianPhone,_that.receiptImageUrl,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceLogModel implements ServiceLogModel {
  const _ServiceLogModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'item_id') required this.itemId, @JsonKey(name: 'task_id') this.taskId, @JsonKey(name: 'item_name') this.itemName, @JsonKey(name: 'service_type') required this.serviceType, required this.title, @JsonKey(name: 'service_date') required this.serviceDate, required this.cost, @JsonKey(name: 'technician_name') this.technicianName, @JsonKey(name: 'technician_phone') this.technicianPhone, @JsonKey(name: 'receipt_image_url') this.receiptImageUrl, this.notes, @JsonKey(name: 'created_at') this.createdAt});
  factory _ServiceLogModel.fromJson(Map<String, dynamic> json) => _$ServiceLogModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'item_id') final  String itemId;
@override@JsonKey(name: 'task_id') final  String? taskId;
@override@JsonKey(name: 'item_name') final  String? itemName;
@override@JsonKey(name: 'service_type') final  String serviceType;
@override final  String title;
@override@JsonKey(name: 'service_date') final  DateTime serviceDate;
@override final  double cost;
@override@JsonKey(name: 'technician_name') final  String? technicianName;
@override@JsonKey(name: 'technician_phone') final  String? technicianPhone;
@override@JsonKey(name: 'receipt_image_url') final  String? receiptImageUrl;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of ServiceLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceLogModelCopyWith<_ServiceLogModel> get copyWith => __$ServiceLogModelCopyWithImpl<_ServiceLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.title, title) || other.title == title)&&(identical(other.serviceDate, serviceDate) || other.serviceDate == serviceDate)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.technicianPhone, technicianPhone) || other.technicianPhone == technicianPhone)&&(identical(other.receiptImageUrl, receiptImageUrl) || other.receiptImageUrl == receiptImageUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,itemId,taskId,itemName,serviceType,title,serviceDate,cost,technicianName,technicianPhone,receiptImageUrl,notes,createdAt);

@override
String toString() {
  return 'ServiceLogModel(id: $id, userId: $userId, itemId: $itemId, taskId: $taskId, itemName: $itemName, serviceType: $serviceType, title: $title, serviceDate: $serviceDate, cost: $cost, technicianName: $technicianName, technicianPhone: $technicianPhone, receiptImageUrl: $receiptImageUrl, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ServiceLogModelCopyWith<$Res> implements $ServiceLogModelCopyWith<$Res> {
  factory _$ServiceLogModelCopyWith(_ServiceLogModel value, $Res Function(_ServiceLogModel) _then) = __$ServiceLogModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'task_id') String? taskId,@JsonKey(name: 'item_name') String? itemName,@JsonKey(name: 'service_type') String serviceType, String title,@JsonKey(name: 'service_date') DateTime serviceDate, double cost,@JsonKey(name: 'technician_name') String? technicianName,@JsonKey(name: 'technician_phone') String? technicianPhone,@JsonKey(name: 'receipt_image_url') String? receiptImageUrl, String? notes,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$ServiceLogModelCopyWithImpl<$Res>
    implements _$ServiceLogModelCopyWith<$Res> {
  __$ServiceLogModelCopyWithImpl(this._self, this._then);

  final _ServiceLogModel _self;
  final $Res Function(_ServiceLogModel) _then;

/// Create a copy of ServiceLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? itemId = null,Object? taskId = freezed,Object? itemName = freezed,Object? serviceType = null,Object? title = null,Object? serviceDate = null,Object? cost = null,Object? technicianName = freezed,Object? technicianPhone = freezed,Object? receiptImageUrl = freezed,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(_ServiceLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,serviceDate: null == serviceDate ? _self.serviceDate : serviceDate // ignore: cast_nullable_to_non_nullable
as DateTime,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,technicianName: freezed == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String?,technicianPhone: freezed == technicianPhone ? _self.technicianPhone : technicianPhone // ignore: cast_nullable_to_non_nullable
as String?,receiptImageUrl: freezed == receiptImageUrl ? _self.receiptImageUrl : receiptImageUrl // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
