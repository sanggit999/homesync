// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeMemberModel {

 String get id;@JsonKey(name: 'home_id') String get homeId;@JsonKey(name: 'user_id') String get userId; String get role;@JsonKey(name: 'user_full_name') String? get userFullName;@JsonKey(name: 'user_email') String? get userEmail;@JsonKey(name: 'user_avatar_url') String? get userAvatarUrl;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of HomeMemberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeMemberModelCopyWith<HomeMemberModel> get copyWith => _$HomeMemberModelCopyWithImpl<HomeMemberModel>(this as HomeMemberModel, _$identity);

  /// Serializes this HomeMemberModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.homeId, homeId) || other.homeId == homeId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.userFullName, userFullName) || other.userFullName == userFullName)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,homeId,userId,role,userFullName,userEmail,userAvatarUrl,createdAt);

@override
String toString() {
  return 'HomeMemberModel(id: $id, homeId: $homeId, userId: $userId, role: $role, userFullName: $userFullName, userEmail: $userEmail, userAvatarUrl: $userAvatarUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $HomeMemberModelCopyWith<$Res>  {
  factory $HomeMemberModelCopyWith(HomeMemberModel value, $Res Function(HomeMemberModel) _then) = _$HomeMemberModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'home_id') String homeId,@JsonKey(name: 'user_id') String userId, String role,@JsonKey(name: 'user_full_name') String? userFullName,@JsonKey(name: 'user_email') String? userEmail,@JsonKey(name: 'user_avatar_url') String? userAvatarUrl,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$HomeMemberModelCopyWithImpl<$Res>
    implements $HomeMemberModelCopyWith<$Res> {
  _$HomeMemberModelCopyWithImpl(this._self, this._then);

  final HomeMemberModel _self;
  final $Res Function(HomeMemberModel) _then;

/// Create a copy of HomeMemberModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? homeId = null,Object? userId = null,Object? role = null,Object? userFullName = freezed,Object? userEmail = freezed,Object? userAvatarUrl = freezed,Object? createdAt = freezed,}) {
  return _then(HomeMemberModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,homeId: null == homeId ? _self.homeId : homeId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,userFullName: freezed == userFullName ? _self.userFullName : userFullName // ignore: cast_nullable_to_non_nullable
as String?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userAvatarUrl: freezed == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeMemberModel].
extension HomeMemberModelPatterns on HomeMemberModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeMemberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeMemberModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeMemberModel value)  $default,){
final _that = this;
switch (_that) {
case _HomeMemberModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeMemberModel value)?  $default,){
final _that = this;
switch (_that) {
case _HomeMemberModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'home_id')  String homeId, @JsonKey(name: 'user_id')  String userId,  String role, @JsonKey(name: 'user_full_name')  String? userFullName, @JsonKey(name: 'user_email')  String? userEmail, @JsonKey(name: 'user_avatar_url')  String? userAvatarUrl, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeMemberModel() when $default != null:
return $default(_that.id,_that.homeId,_that.userId,_that.role,_that.userFullName,_that.userEmail,_that.userAvatarUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'home_id')  String homeId, @JsonKey(name: 'user_id')  String userId,  String role, @JsonKey(name: 'user_full_name')  String? userFullName, @JsonKey(name: 'user_email')  String? userEmail, @JsonKey(name: 'user_avatar_url')  String? userAvatarUrl, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _HomeMemberModel():
return $default(_that.id,_that.homeId,_that.userId,_that.role,_that.userFullName,_that.userEmail,_that.userAvatarUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'home_id')  String homeId, @JsonKey(name: 'user_id')  String userId,  String role, @JsonKey(name: 'user_full_name')  String? userFullName, @JsonKey(name: 'user_email')  String? userEmail, @JsonKey(name: 'user_avatar_url')  String? userAvatarUrl, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _HomeMemberModel() when $default != null:
return $default(_that.id,_that.homeId,_that.userId,_that.role,_that.userFullName,_that.userEmail,_that.userAvatarUrl,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeMemberModel implements HomeMemberModel {
  const _HomeMemberModel({required this.id, @JsonKey(name: 'home_id') required this.homeId, @JsonKey(name: 'user_id') required this.userId, this.role = 'member', @JsonKey(name: 'user_full_name') this.userFullName, @JsonKey(name: 'user_email') this.userEmail, @JsonKey(name: 'user_avatar_url') this.userAvatarUrl, @JsonKey(name: 'created_at') this.createdAt});
  factory _HomeMemberModel.fromJson(Map<String, dynamic> json) => _$HomeMemberModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'home_id') final  String homeId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String role;
@override@JsonKey(name: 'user_full_name') final  String? userFullName;
@override@JsonKey(name: 'user_email') final  String? userEmail;
@override@JsonKey(name: 'user_avatar_url') final  String? userAvatarUrl;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of HomeMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeMemberModelCopyWith<_HomeMemberModel> get copyWith => __$HomeMemberModelCopyWithImpl<_HomeMemberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeMemberModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.homeId, homeId) || other.homeId == homeId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.userFullName, userFullName) || other.userFullName == userFullName)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,homeId,userId,role,userFullName,userEmail,userAvatarUrl,createdAt);

@override
String toString() {
  return 'HomeMemberModel(id: $id, homeId: $homeId, userId: $userId, role: $role, userFullName: $userFullName, userEmail: $userEmail, userAvatarUrl: $userAvatarUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$HomeMemberModelCopyWith<$Res> implements $HomeMemberModelCopyWith<$Res> {
  factory _$HomeMemberModelCopyWith(_HomeMemberModel value, $Res Function(_HomeMemberModel) _then) = __$HomeMemberModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'home_id') String homeId,@JsonKey(name: 'user_id') String userId, String role,@JsonKey(name: 'user_full_name') String? userFullName,@JsonKey(name: 'user_email') String? userEmail,@JsonKey(name: 'user_avatar_url') String? userAvatarUrl,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$HomeMemberModelCopyWithImpl<$Res>
    implements _$HomeMemberModelCopyWith<$Res> {
  __$HomeMemberModelCopyWithImpl(this._self, this._then);

  final _HomeMemberModel _self;
  final $Res Function(_HomeMemberModel) _then;

/// Create a copy of HomeMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? homeId = null,Object? userId = null,Object? role = null,Object? userFullName = freezed,Object? userEmail = freezed,Object? userAvatarUrl = freezed,Object? createdAt = freezed,}) {
  return _then(_HomeMemberModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,homeId: null == homeId ? _self.homeId : homeId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,userFullName: freezed == userFullName ? _self.userFullName : userFullName // ignore: cast_nullable_to_non_nullable
as String?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userAvatarUrl: freezed == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
