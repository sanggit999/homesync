// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemDocumentModel _$ItemDocumentModelFromJson(Map<String, dynamic> json) =>
    _ItemDocumentModel(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      documentType: json['document_type'] as String,
      fileName: json['file_name'] as String,
      fileUrl: json['file_url'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ItemDocumentModelToJson(_ItemDocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_id': instance.itemId,
      'document_type': instance.documentType,
      'file_name': instance.fileName,
      'file_url': instance.fileUrl,
      'created_at': instance.createdAt?.toIso8601String(),
    };
