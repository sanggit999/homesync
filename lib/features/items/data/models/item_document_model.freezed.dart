// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_document_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemDocumentModel {

 String get id;@JsonKey(name: 'item_id') String get itemId;@JsonKey(name: 'document_type') String get documentType;@JsonKey(name: 'file_name') String get fileName;@JsonKey(name: 'file_url') String get fileUrl;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of ItemDocumentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDocumentModelCopyWith<ItemDocumentModel> get copyWith => _$ItemDocumentModelCopyWithImpl<ItemDocumentModel>(this as ItemDocumentModel, _$identity);

  /// Serializes this ItemDocumentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,documentType,fileName,fileUrl,createdAt);

@override
String toString() {
  return 'ItemDocumentModel(id: $id, itemId: $itemId, documentType: $documentType, fileName: $fileName, fileUrl: $fileUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ItemDocumentModelCopyWith<$Res>  {
  factory $ItemDocumentModelCopyWith(ItemDocumentModel value, $Res Function(ItemDocumentModel) _then) = _$ItemDocumentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'document_type') String documentType,@JsonKey(name: 'file_name') String fileName,@JsonKey(name: 'file_url') String fileUrl,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$ItemDocumentModelCopyWithImpl<$Res>
    implements $ItemDocumentModelCopyWith<$Res> {
  _$ItemDocumentModelCopyWithImpl(this._self, this._then);

  final ItemDocumentModel _self;
  final $Res Function(ItemDocumentModel) _then;

/// Create a copy of ItemDocumentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? documentType = null,Object? fileName = null,Object? fileUrl = null,Object? createdAt = freezed,}) {
  return _then(ItemDocumentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemDocumentModel].
extension ItemDocumentModelPatterns on ItemDocumentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDocumentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDocumentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDocumentModel value)  $default,){
final _that = this;
switch (_that) {
case _ItemDocumentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDocumentModel value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDocumentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'document_type')  String documentType, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDocumentModel() when $default != null:
return $default(_that.id,_that.itemId,_that.documentType,_that.fileName,_that.fileUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'document_type')  String documentType, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ItemDocumentModel():
return $default(_that.id,_that.itemId,_that.documentType,_that.fileName,_that.fileUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'document_type')  String documentType, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ItemDocumentModel() when $default != null:
return $default(_that.id,_that.itemId,_that.documentType,_that.fileName,_that.fileUrl,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemDocumentModel implements ItemDocumentModel {
  const _ItemDocumentModel({required this.id, @JsonKey(name: 'item_id') required this.itemId, @JsonKey(name: 'document_type') required this.documentType, @JsonKey(name: 'file_name') required this.fileName, @JsonKey(name: 'file_url') required this.fileUrl, @JsonKey(name: 'created_at') this.createdAt});
  factory _ItemDocumentModel.fromJson(Map<String, dynamic> json) => _$ItemDocumentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'item_id') final  String itemId;
@override@JsonKey(name: 'document_type') final  String documentType;
@override@JsonKey(name: 'file_name') final  String fileName;
@override@JsonKey(name: 'file_url') final  String fileUrl;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of ItemDocumentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDocumentModelCopyWith<_ItemDocumentModel> get copyWith => __$ItemDocumentModelCopyWithImpl<_ItemDocumentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemDocumentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,documentType,fileName,fileUrl,createdAt);

@override
String toString() {
  return 'ItemDocumentModel(id: $id, itemId: $itemId, documentType: $documentType, fileName: $fileName, fileUrl: $fileUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ItemDocumentModelCopyWith<$Res> implements $ItemDocumentModelCopyWith<$Res> {
  factory _$ItemDocumentModelCopyWith(_ItemDocumentModel value, $Res Function(_ItemDocumentModel) _then) = __$ItemDocumentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'document_type') String documentType,@JsonKey(name: 'file_name') String fileName,@JsonKey(name: 'file_url') String fileUrl,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$ItemDocumentModelCopyWithImpl<$Res>
    implements _$ItemDocumentModelCopyWith<$Res> {
  __$ItemDocumentModelCopyWithImpl(this._self, this._then);

  final _ItemDocumentModel _self;
  final $Res Function(_ItemDocumentModel) _then;

/// Create a copy of ItemDocumentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? documentType = null,Object? fileName = null,Object? fileUrl = null,Object? createdAt = freezed,}) {
  return _then(_ItemDocumentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
