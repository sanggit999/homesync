// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_preset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MaintenancePresetModel {

 String get id;@JsonKey(name: 'category_id') String get categoryId;@JsonKey(name: 'preset_name') String get presetName;@JsonKey(name: 'default_frequency_months') int get defaultFrequencyMonths;@JsonKey(name: 'suggested_priority') String get suggestedPriority;
/// Create a copy of MaintenancePresetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenancePresetModelCopyWith<MaintenancePresetModel> get copyWith => _$MaintenancePresetModelCopyWithImpl<MaintenancePresetModel>(this as MaintenancePresetModel, _$identity);

  /// Serializes this MaintenancePresetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenancePresetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.presetName, presetName) || other.presetName == presetName)&&(identical(other.defaultFrequencyMonths, defaultFrequencyMonths) || other.defaultFrequencyMonths == defaultFrequencyMonths)&&(identical(other.suggestedPriority, suggestedPriority) || other.suggestedPriority == suggestedPriority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,presetName,defaultFrequencyMonths,suggestedPriority);

@override
String toString() {
  return 'MaintenancePresetModel(id: $id, categoryId: $categoryId, presetName: $presetName, defaultFrequencyMonths: $defaultFrequencyMonths, suggestedPriority: $suggestedPriority)';
}


}

/// @nodoc
abstract mixin class $MaintenancePresetModelCopyWith<$Res>  {
  factory $MaintenancePresetModelCopyWith(MaintenancePresetModel value, $Res Function(MaintenancePresetModel) _then) = _$MaintenancePresetModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'preset_name') String presetName,@JsonKey(name: 'default_frequency_months') int defaultFrequencyMonths,@JsonKey(name: 'suggested_priority') String suggestedPriority
});




}
/// @nodoc
class _$MaintenancePresetModelCopyWithImpl<$Res>
    implements $MaintenancePresetModelCopyWith<$Res> {
  _$MaintenancePresetModelCopyWithImpl(this._self, this._then);

  final MaintenancePresetModel _self;
  final $Res Function(MaintenancePresetModel) _then;

/// Create a copy of MaintenancePresetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? presetName = null,Object? defaultFrequencyMonths = null,Object? suggestedPriority = null,}) {
  return _then(MaintenancePresetModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,presetName: null == presetName ? _self.presetName : presetName // ignore: cast_nullable_to_non_nullable
as String,defaultFrequencyMonths: null == defaultFrequencyMonths ? _self.defaultFrequencyMonths : defaultFrequencyMonths // ignore: cast_nullable_to_non_nullable
as int,suggestedPriority: null == suggestedPriority ? _self.suggestedPriority : suggestedPriority // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MaintenancePresetModel].
extension MaintenancePresetModelPatterns on MaintenancePresetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaintenancePresetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaintenancePresetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaintenancePresetModel value)  $default,){
final _that = this;
switch (_that) {
case _MaintenancePresetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaintenancePresetModel value)?  $default,){
final _that = this;
switch (_that) {
case _MaintenancePresetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'preset_name')  String presetName, @JsonKey(name: 'default_frequency_months')  int defaultFrequencyMonths, @JsonKey(name: 'suggested_priority')  String suggestedPriority)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaintenancePresetModel() when $default != null:
return $default(_that.id,_that.categoryId,_that.presetName,_that.defaultFrequencyMonths,_that.suggestedPriority);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'preset_name')  String presetName, @JsonKey(name: 'default_frequency_months')  int defaultFrequencyMonths, @JsonKey(name: 'suggested_priority')  String suggestedPriority)  $default,) {final _that = this;
switch (_that) {
case _MaintenancePresetModel():
return $default(_that.id,_that.categoryId,_that.presetName,_that.defaultFrequencyMonths,_that.suggestedPriority);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'preset_name')  String presetName, @JsonKey(name: 'default_frequency_months')  int defaultFrequencyMonths, @JsonKey(name: 'suggested_priority')  String suggestedPriority)?  $default,) {final _that = this;
switch (_that) {
case _MaintenancePresetModel() when $default != null:
return $default(_that.id,_that.categoryId,_that.presetName,_that.defaultFrequencyMonths,_that.suggestedPriority);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaintenancePresetModel implements MaintenancePresetModel {
  const _MaintenancePresetModel({required this.id, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'preset_name') required this.presetName, @JsonKey(name: 'default_frequency_months') required this.defaultFrequencyMonths, @JsonKey(name: 'suggested_priority') this.suggestedPriority = 'medium'});
  factory _MaintenancePresetModel.fromJson(Map<String, dynamic> json) => _$MaintenancePresetModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'category_id') final  String categoryId;
@override@JsonKey(name: 'preset_name') final  String presetName;
@override@JsonKey(name: 'default_frequency_months') final  int defaultFrequencyMonths;
@override@JsonKey(name: 'suggested_priority') final  String suggestedPriority;

/// Create a copy of MaintenancePresetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenancePresetModelCopyWith<_MaintenancePresetModel> get copyWith => __$MaintenancePresetModelCopyWithImpl<_MaintenancePresetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaintenancePresetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaintenancePresetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.presetName, presetName) || other.presetName == presetName)&&(identical(other.defaultFrequencyMonths, defaultFrequencyMonths) || other.defaultFrequencyMonths == defaultFrequencyMonths)&&(identical(other.suggestedPriority, suggestedPriority) || other.suggestedPriority == suggestedPriority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,presetName,defaultFrequencyMonths,suggestedPriority);

@override
String toString() {
  return 'MaintenancePresetModel(id: $id, categoryId: $categoryId, presetName: $presetName, defaultFrequencyMonths: $defaultFrequencyMonths, suggestedPriority: $suggestedPriority)';
}


}

/// @nodoc
abstract mixin class _$MaintenancePresetModelCopyWith<$Res> implements $MaintenancePresetModelCopyWith<$Res> {
  factory _$MaintenancePresetModelCopyWith(_MaintenancePresetModel value, $Res Function(_MaintenancePresetModel) _then) = __$MaintenancePresetModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'preset_name') String presetName,@JsonKey(name: 'default_frequency_months') int defaultFrequencyMonths,@JsonKey(name: 'suggested_priority') String suggestedPriority
});




}
/// @nodoc
class __$MaintenancePresetModelCopyWithImpl<$Res>
    implements _$MaintenancePresetModelCopyWith<$Res> {
  __$MaintenancePresetModelCopyWithImpl(this._self, this._then);

  final _MaintenancePresetModel _self;
  final $Res Function(_MaintenancePresetModel) _then;

/// Create a copy of MaintenancePresetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? presetName = null,Object? defaultFrequencyMonths = null,Object? suggestedPriority = null,}) {
  return _then(_MaintenancePresetModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,presetName: null == presetName ? _self.presetName : presetName // ignore: cast_nullable_to_non_nullable
as String,defaultFrequencyMonths: null == defaultFrequencyMonths ? _self.defaultFrequencyMonths : defaultFrequencyMonths // ignore: cast_nullable_to_non_nullable
as int,suggestedPriority: null == suggestedPriority ? _self.suggestedPriority : suggestedPriority // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
