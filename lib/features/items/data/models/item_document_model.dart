import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_document_model.freezed.dart';
part 'item_document_model.g.dart';

/// Data Model đại diện cho bảng 'item_documents' trên Supabase (DTO với Freezed & JsonSerializable)
@freezed
abstract class ItemDocumentModel with _$ItemDocumentModel {
  const factory ItemDocumentModel({
    required String id,
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'document_type') required String documentType,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'file_url') required String fileUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ItemDocumentModel;

  factory ItemDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$ItemDocumentModelFromJson(json);
}
