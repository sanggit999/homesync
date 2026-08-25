/// Entity đại diện cho Tài liệu / Hóa đơn đính kèm của thiết bị
class ItemDocumentEntity {
  const ItemDocumentEntity({
    required this.id,
    required this.itemId,
    required this.documentType,
    required this.fileName,
    required this.fileUrl,
    this.createdAt,
  });

  final String id;
  final String itemId;
  final String documentType; // 'receipt', 'warranty_card', 'manual', 'other'
  final String fileName;
  final String fileUrl;
  final DateTime? createdAt;
}
