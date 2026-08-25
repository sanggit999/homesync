// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileModel {

 String get id;@JsonKey(name: 'full_name') String? get fullName;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'onesignal_player_id') String? get oneSignalPlayerId;@JsonKey(name: 'reminder_days_before') int get reminderDaysBefore;@JsonKey(name: 'notify_warranty') bool get notifyWarranty;@JsonKey(name: 'notify_maintenance') bool get notifyMaintenance;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<ProfileModel> get copyWith => _$ProfileModelCopyWithImpl<ProfileModel>(this as ProfileModel, _$identity);

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.oneSignalPlayerId, oneSignalPlayerId) || other.oneSignalPlayerId == oneSignalPlayerId)&&(identical(other.reminderDaysBefore, reminderDaysBefore) || other.reminderDaysBefore == reminderDaysBefore)&&(identical(other.notifyWarranty, notifyWarranty) || other.notifyWarranty == notifyWarranty)&&(identical(other.notifyMaintenance, notifyMaintenance) || other.notifyMaintenance == notifyMaintenance)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,oneSignalPlayerId,reminderDaysBefore,notifyWarranty,notifyMaintenance,updatedAt);

@override
String toString() {
  return 'ProfileModel(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, oneSignalPlayerId: $oneSignalPlayerId, reminderDaysBefore: $reminderDaysBefore, notifyWarranty: $notifyWarranty, notifyMaintenance: $notifyMaintenance, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProfileModelCopyWith<$Res>  {
  factory $ProfileModelCopyWith(ProfileModel value, $Res Function(ProfileModel) _then) = _$ProfileModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String? fullName,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'onesignal_player_id') String? oneSignalPlayerId,@JsonKey(name: 'reminder_days_before') int reminderDaysBefore,@JsonKey(name: 'notify_warranty') bool notifyWarranty,@JsonKey(name: 'notify_maintenance') bool notifyMaintenance,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$ProfileModelCopyWithImpl<$Res>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._self, this._then);

  final ProfileModel _self;
  final $Res Function(ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = freezed,Object? avatarUrl = freezed,Object? oneSignalPlayerId = freezed,Object? reminderDaysBefore = null,Object? notifyWarranty = null,Object? notifyMaintenance = null,Object? updatedAt = freezed,}) {
  return _then(ProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,oneSignalPlayerId: freezed == oneSignalPlayerId ? _self.oneSignalPlayerId : oneSignalPlayerId // ignore: cast_nullable_to_non_nullable
as String?,reminderDaysBefore: null == reminderDaysBefore ? _self.reminderDaysBefore : reminderDaysBefore // ignore: cast_nullable_to_non_nullable
as int,notifyWarranty: null == notifyWarranty ? _self.notifyWarranty : notifyWarranty // ignore: cast_nullable_to_non_nullable
as bool,notifyMaintenance: null == notifyMaintenance ? _self.notifyMaintenance : notifyMaintenance // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileModel].
extension ProfileModelPatterns on ProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'onesignal_player_id')  String? oneSignalPlayerId, @JsonKey(name: 'reminder_days_before')  int reminderDaysBefore, @JsonKey(name: 'notify_warranty')  bool notifyWarranty, @JsonKey(name: 'notify_maintenance')  bool notifyMaintenance, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.oneSignalPlayerId,_that.reminderDaysBefore,_that.notifyWarranty,_that.notifyMaintenance,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'onesignal_player_id')  String? oneSignalPlayerId, @JsonKey(name: 'reminder_days_before')  int reminderDaysBefore, @JsonKey(name: 'notify_warranty')  bool notifyWarranty, @JsonKey(name: 'notify_maintenance')  bool notifyMaintenance, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProfileModel():
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.oneSignalPlayerId,_that.reminderDaysBefore,_that.notifyWarranty,_that.notifyMaintenance,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'onesignal_player_id')  String? oneSignalPlayerId, @JsonKey(name: 'reminder_days_before')  int reminderDaysBefore, @JsonKey(name: 'notify_warranty')  bool notifyWarranty, @JsonKey(name: 'notify_maintenance')  bool notifyMaintenance, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.oneSignalPlayerId,_that.reminderDaysBefore,_that.notifyWarranty,_that.notifyMaintenance,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileModel implements ProfileModel {
  const _ProfileModel({required this.id, @JsonKey(name: 'full_name') this.fullName, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'onesignal_player_id') this.oneSignalPlayerId, @JsonKey(name: 'reminder_days_before') this.reminderDaysBefore = 7, @JsonKey(name: 'notify_warranty') this.notifyWarranty = true, @JsonKey(name: 'notify_maintenance') this.notifyMaintenance = true, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'full_name') final  String? fullName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'onesignal_player_id') final  String? oneSignalPlayerId;
@override@JsonKey(name: 'reminder_days_before') final  int reminderDaysBefore;
@override@JsonKey(name: 'notify_warranty') final  bool notifyWarranty;
@override@JsonKey(name: 'notify_maintenance') final  bool notifyMaintenance;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileModelCopyWith<_ProfileModel> get copyWith => __$ProfileModelCopyWithImpl<_ProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.oneSignalPlayerId, oneSignalPlayerId) || other.oneSignalPlayerId == oneSignalPlayerId)&&(identical(other.reminderDaysBefore, reminderDaysBefore) || other.reminderDaysBefore == reminderDaysBefore)&&(identical(other.notifyWarranty, notifyWarranty) || other.notifyWarranty == notifyWarranty)&&(identical(other.notifyMaintenance, notifyMaintenance) || other.notifyMaintenance == notifyMaintenance)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,oneSignalPlayerId,reminderDaysBefore,notifyWarranty,notifyMaintenance,updatedAt);

@override
String toString() {
  return 'ProfileModel(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, oneSignalPlayerId: $oneSignalPlayerId, reminderDaysBefore: $reminderDaysBefore, notifyWarranty: $notifyWarranty, notifyMaintenance: $notifyMaintenance, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProfileModelCopyWith<$Res> implements $ProfileModelCopyWith<$Res> {
  factory _$ProfileModelCopyWith(_ProfileModel value, $Res Function(_ProfileModel) _then) = __$ProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String? fullName,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'onesignal_player_id') String? oneSignalPlayerId,@JsonKey(name: 'reminder_days_before') int reminderDaysBefore,@JsonKey(name: 'notify_warranty') bool notifyWarranty,@JsonKey(name: 'notify_maintenance') bool notifyMaintenance,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$ProfileModelCopyWithImpl<$Res>
    implements _$ProfileModelCopyWith<$Res> {
  __$ProfileModelCopyWithImpl(this._self, this._then);

  final _ProfileModel _self;
  final $Res Function(_ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = freezed,Object? avatarUrl = freezed,Object? oneSignalPlayerId = freezed,Object? reminderDaysBefore = null,Object? notifyWarranty = null,Object? notifyMaintenance = null,Object? updatedAt = freezed,}) {
  return _then(_ProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,oneSignalPlayerId: freezed == oneSignalPlayerId ? _self.oneSignalPlayerId : oneSignalPlayerId // ignore: cast_nullable_to_non_nullable
as String?,reminderDaysBefore: null == reminderDaysBefore ? _self.reminderDaysBefore : reminderDaysBefore // ignore: cast_nullable_to_non_nullable
as int,notifyWarranty: null == notifyWarranty ? _self.notifyWarranty : notifyWarranty // ignore: cast_nullable_to_non_nullable
as bool,notifyMaintenance: null == notifyMaintenance ? _self.notifyMaintenance : notifyMaintenance // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
