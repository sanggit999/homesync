import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Data Model đại diện cho bảng 'categories' (DTO với Freezed & JsonSerializable)
@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    @JsonKey(name: 'icon_name') required String iconName,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
