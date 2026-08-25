// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MaintenanceTaskModel {

 String get id;@JsonKey(name: 'item_id') String get itemId;@JsonKey(name: 'item_name') String? get itemName;@JsonKey(name: 'item_location') String? get itemLocation;@JsonKey(name: 'task_name') String get taskName;@JsonKey(name: 'frequency_months') int get frequencyMonths;@JsonKey(name: 'last_completed_at') DateTime? get lastCompletedAt;@JsonKey(name: 'next_due_date') DateTime get nextDueDate;@JsonKey(name: 'is_completed') bool get isCompleted; String get priority;@JsonKey(name: 'technician_name') String? get technicianName;@JsonKey(name: 'technician_phone') String? get technicianPhone;@JsonKey(name: 'estimated_cost') double? get estimatedCost; double? get cost; String? get notes;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of MaintenanceTaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceTaskModelCopyWith<MaintenanceTaskModel> get copyWith => _$MaintenanceTaskModelCopyWithImpl<MaintenanceTaskModel>(this as MaintenanceTaskModel, _$identity);

  /// Serializes this MaintenanceTaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceTaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.itemLocation, itemLocation) || other.itemLocation == itemLocation)&&(identical(other.taskName, taskName) || other.taskName == taskName)&&(identical(other.frequencyMonths, frequencyMonths) || other.frequencyMonths == frequencyMonths)&&(identical(other.lastCompletedAt, lastCompletedAt) || other.lastCompletedAt == lastCompletedAt)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.technicianPhone, technicianPhone) || other.technicianPhone == technicianPhone)&&(identical(other.estimatedCost, estimatedCost) || other.estimatedCost == estimatedCost)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,itemName,itemLocation,taskName,frequencyMonths,lastCompletedAt,nextDueDate,isCompleted,priority,technicianName,technicianPhone,estimatedCost,cost,notes,createdAt);

@override
String toString() {
  return 'MaintenanceTaskModel(id: $id, itemId: $itemId, itemName: $itemName, itemLocation: $itemLocation, taskName: $taskName, frequencyMonths: $frequencyMonths, lastCompletedAt: $lastCompletedAt, nextDueDate: $nextDueDate, isCompleted: $isCompleted, priority: $priority, technicianName: $technicianName, technicianPhone: $technicianPhone, estimatedCost: $estimatedCost, cost: $cost, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MaintenanceTaskModelCopyWith<$Res>  {
  factory $MaintenanceTaskModelCopyWith(MaintenanceTaskModel value, $Res Function(MaintenanceTaskModel) _then) = _$MaintenanceTaskModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'item_name') String? itemName,@JsonKey(name: 'item_location') String? itemLocation,@JsonKey(name: 'task_name') String taskName,@JsonKey(name: 'frequency_months') int frequencyMonths,@JsonKey(name: 'last_completed_at') DateTime? lastCompletedAt,@JsonKey(name: 'next_due_date') DateTime nextDueDate,@JsonKey(name: 'is_completed') bool isCompleted, String priority,@JsonKey(name: 'technician_name') String? technicianName,@JsonKey(name: 'technician_phone') String? technicianPhone,@JsonKey(name: 'estimated_cost') double? estimatedCost, double? cost, String? notes,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$MaintenanceTaskModelCopyWithImpl<$Res>
    implements $MaintenanceTaskModelCopyWith<$Res> {
  _$MaintenanceTaskModelCopyWithImpl(this._self, this._then);

  final MaintenanceTaskModel _self;
  final $Res Function(MaintenanceTaskModel) _then;

/// Create a copy of MaintenanceTaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? itemName = freezed,Object? itemLocation = freezed,Object? taskName = null,Object? frequencyMonths = null,Object? lastCompletedAt = freezed,Object? nextDueDate = null,Object? isCompleted = null,Object? priority = null,Object? technicianName = freezed,Object? technicianPhone = freezed,Object? estimatedCost = freezed,Object? cost = freezed,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(MaintenanceTaskModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,itemLocation: freezed == itemLocation ? _self.itemLocation : itemLocation // ignore: cast_nullable_to_non_nullable
as String?,taskName: null == taskName ? _self.taskName : taskName // ignore: cast_nullable_to_non_nullable
as String,frequencyMonths: null == frequencyMonths ? _self.frequencyMonths : frequencyMonths // ignore: cast_nullable_to_non_nullable
as int,lastCompletedAt: freezed == lastCompletedAt ? _self.lastCompletedAt : lastCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,technicianName: freezed == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String?,technicianPhone: freezed == technicianPhone ? _self.technicianPhone : technicianPhone // ignore: cast_nullable_to_non_nullable
as String?,estimatedCost: freezed == estimatedCost ? _self.estimatedCost : estimatedCost // ignore: cast_nullable_to_non_nullable
as double?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MaintenanceTaskModel].
extension MaintenanceTaskModelPatterns on MaintenanceTaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaintenanceTaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaintenanceTaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaintenanceTaskModel value)  $default,){
final _that = this;
switch (_that) {
case _MaintenanceTaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaintenanceTaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _MaintenanceTaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'item_name')  String? itemName, @JsonKey(name: 'item_location')  String? itemLocation, @JsonKey(name: 'task_name')  String taskName, @JsonKey(name: 'frequency_months')  int frequencyMonths, @JsonKey(name: 'last_completed_at')  DateTime? lastCompletedAt, @JsonKey(name: 'next_due_date')  DateTime nextDueDate, @JsonKey(name: 'is_completed')  bool isCompleted,  String priority, @JsonKey(name: 'technician_name')  String? technicianName, @JsonKey(name: 'technician_phone')  String? technicianPhone, @JsonKey(name: 'estimated_cost')  double? estimatedCost,  double? cost,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaintenanceTaskModel() when $default != null:
return $default(_that.id,_that.itemId,_that.itemName,_that.itemLocation,_that.taskName,_that.frequencyMonths,_that.lastCompletedAt,_that.nextDueDate,_that.isCompleted,_that.priority,_that.technicianName,_that.technicianPhone,_that.estimatedCost,_that.cost,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'item_name')  String? itemName, @JsonKey(name: 'item_location')  String? itemLocation, @JsonKey(name: 'task_name')  String taskName, @JsonKey(name: 'frequency_months')  int frequencyMonths, @JsonKey(name: 'last_completed_at')  DateTime? lastCompletedAt, @JsonKey(name: 'next_due_date')  DateTime nextDueDate, @JsonKey(name: 'is_completed')  bool isCompleted,  String priority, @JsonKey(name: 'technician_name')  String? technicianName, @JsonKey(name: 'technician_phone')  String? technicianPhone, @JsonKey(name: 'estimated_cost')  double? estimatedCost,  double? cost,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MaintenanceTaskModel():
return $default(_that.id,_that.itemId,_that.itemName,_that.itemLocation,_that.taskName,_that.frequencyMonths,_that.lastCompletedAt,_that.nextDueDate,_that.isCompleted,_that.priority,_that.technicianName,_that.technicianPhone,_that.estimatedCost,_that.cost,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'item_name')  String? itemName, @JsonKey(name: 'item_location')  String? itemLocation, @JsonKey(name: 'task_name')  String taskName, @JsonKey(name: 'frequency_months')  int frequencyMonths, @JsonKey(name: 'last_completed_at')  DateTime? lastCompletedAt, @JsonKey(name: 'next_due_date')  DateTime nextDueDate, @JsonKey(name: 'is_completed')  bool isCompleted,  String priority, @JsonKey(name: 'technician_name')  String? technicianName, @JsonKey(name: 'technician_phone')  String? technicianPhone, @JsonKey(name: 'estimated_cost')  double? estimatedCost,  double? cost,  String? notes, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MaintenanceTaskModel() when $default != null:
return $default(_that.id,_that.itemId,_that.itemName,_that.itemLocation,_that.taskName,_that.frequencyMonths,_that.lastCompletedAt,_that.nextDueDate,_that.isCompleted,_that.priority,_that.technicianName,_that.technicianPhone,_that.estimatedCost,_that.cost,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaintenanceTaskModel implements MaintenanceTaskModel {
  const _MaintenanceTaskModel({required this.id, @JsonKey(name: 'item_id') required this.itemId, @JsonKey(name: 'item_name') this.itemName, @JsonKey(name: 'item_location') this.itemLocation, @JsonKey(name: 'task_name') required this.taskName, @JsonKey(name: 'frequency_months') required this.frequencyMonths, @JsonKey(name: 'last_completed_at') this.lastCompletedAt, @JsonKey(name: 'next_due_date') required this.nextDueDate, @JsonKey(name: 'is_completed') this.isCompleted = false, this.priority = 'medium', @JsonKey(name: 'technician_name') this.technicianName, @JsonKey(name: 'technician_phone') this.technicianPhone, @JsonKey(name: 'estimated_cost') this.estimatedCost, this.cost, this.notes, @JsonKey(name: 'created_at') this.createdAt});
  factory _MaintenanceTaskModel.fromJson(Map<String, dynamic> json) => _$MaintenanceTaskModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'item_id') final  String itemId;
@override@JsonKey(name: 'item_name') final  String? itemName;
@override@JsonKey(name: 'item_location') final  String? itemLocation;
@override@JsonKey(name: 'task_name') final  String taskName;
@override@JsonKey(name: 'frequency_months') final  int frequencyMonths;
@override@JsonKey(name: 'last_completed_at') final  DateTime? lastCompletedAt;
@override@JsonKey(name: 'next_due_date') final  DateTime nextDueDate;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override@JsonKey() final  String priority;
@override@JsonKey(name: 'technician_name') final  String? technicianName;
@override@JsonKey(name: 'technician_phone') final  String? technicianPhone;
@override@JsonKey(name: 'estimated_cost') final  double? estimatedCost;
@override final  double? cost;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of MaintenanceTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceTaskModelCopyWith<_MaintenanceTaskModel> get copyWith => __$MaintenanceTaskModelCopyWithImpl<_MaintenanceTaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaintenanceTaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaintenanceTaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.itemLocation, itemLocation) || other.itemLocation == itemLocation)&&(identical(other.taskName, taskName) || other.taskName == taskName)&&(identical(other.frequencyMonths, frequencyMonths) || other.frequencyMonths == frequencyMonths)&&(identical(other.lastCompletedAt, lastCompletedAt) || other.lastCompletedAt == lastCompletedAt)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.technicianPhone, technicianPhone) || other.technicianPhone == technicianPhone)&&(identical(other.estimatedCost, estimatedCost) || other.estimatedCost == estimatedCost)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,itemName,itemLocation,taskName,frequencyMonths,lastCompletedAt,nextDueDate,isCompleted,priority,technicianName,technicianPhone,estimatedCost,cost,notes,createdAt);

@override
String toString() {
  return 'MaintenanceTaskModel(id: $id, itemId: $itemId, itemName: $itemName, itemLocation: $itemLocation, taskName: $taskName, frequencyMonths: $frequencyMonths, lastCompletedAt: $lastCompletedAt, nextDueDate: $nextDueDate, isCompleted: $isCompleted, priority: $priority, technicianName: $technicianName, technicianPhone: $technicianPhone, estimatedCost: $estimatedCost, cost: $cost, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceTaskModelCopyWith<$Res> implements $MaintenanceTaskModelCopyWith<$Res> {
  factory _$MaintenanceTaskModelCopyWith(_MaintenanceTaskModel value, $Res Function(_MaintenanceTaskModel) _then) = __$MaintenanceTaskModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'item_name') String? itemName,@JsonKey(name: 'item_location') String? itemLocation,@JsonKey(name: 'task_name') String taskName,@JsonKey(name: 'frequency_months') int frequencyMonths,@JsonKey(name: 'last_completed_at') DateTime? lastCompletedAt,@JsonKey(name: 'next_due_date') DateTime nextDueDate,@JsonKey(name: 'is_completed') bool isCompleted, String priority,@JsonKey(name: 'technician_name') String? technicianName,@JsonKey(name: 'technician_phone') String? technicianPhone,@JsonKey(name: 'estimated_cost') double? estimatedCost, double? cost, String? notes,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$MaintenanceTaskModelCopyWithImpl<$Res>
    implements _$MaintenanceTaskModelCopyWith<$Res> {
  __$MaintenanceTaskModelCopyWithImpl(this._self, this._then);

  final _MaintenanceTaskModel _self;
  final $Res Function(_MaintenanceTaskModel) _then;

/// Create a copy of MaintenanceTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? itemName = freezed,Object? itemLocation = freezed,Object? taskName = null,Object? frequencyMonths = null,Object? lastCompletedAt = freezed,Object? nextDueDate = null,Object? isCompleted = null,Object? priority = null,Object? technicianName = freezed,Object? technicianPhone = freezed,Object? estimatedCost = freezed,Object? cost = freezed,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(_MaintenanceTaskModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,itemLocation: freezed == itemLocation ? _self.itemLocation : itemLocation // ignore: cast_nullable_to_non_nullable
as String?,taskName: null == taskName ? _self.taskName : taskName // ignore: cast_nullable_to_non_nullable
as String,frequencyMonths: null == frequencyMonths ? _self.frequencyMonths : frequencyMonths // ignore: cast_nullable_to_non_nullable
as int,lastCompletedAt: freezed == lastCompletedAt ? _self.lastCompletedAt : lastCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,technicianName: freezed == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String?,technicianPhone: freezed == technicianPhone ? _self.technicianPhone : technicianPhone // ignore: cast_nullable_to_non_nullable
as String?,estimatedCost: freezed == estimatedCost ? _self.estimatedCost : estimatedCost // ignore: cast_nullable_to_non_nullable
as double?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
