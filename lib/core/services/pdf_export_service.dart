import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../utils/currency_formatter.dart';
import '../utils/date_formatter.dart';

/// Dữ liệu đầu vào cho một mục trong báo cáo PDF
class PdfAssetItem {
  const PdfAssetItem({
    required this.name,
    required this.brand,
    required this.category,
    required this.location,
    required this.purchaseDate,
    required this.warrantyExpiryDate,
    this.serialNumber,
    this.price,
    this.status = 'active',
  });

  final String name;
  final String brand;
  final String category;
  final String location;
  final DateTime purchaseDate;
  final DateTime warrantyExpiryDate;
  final String? serialNumber;
  final double? price;
  final String status;
}

/// Dịch vụ khởi tạo & xuất bản hồ sơ tài sản bảo hiểm sang định dạng PDF
class PdfExportService {
  PdfExportService._();

  /// Tạo tài liệu PDF danh mục tài sản bảo hiểm
  static Future<Uint8List> generateAssetReport({
    required String homeName,
    required String userName,
    required List<PdfAssetItem> items,
  }) async {
    final pdf = pw.Document();

    final totalValue = items.fold<double>(0, (sum, item) => sum + (item.price ?? 0));
    final font = await PdfGoogleFonts.plusJakartaSansRegular();
    final fontBold = await PdfGoogleFonts.plusJakartaSansBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        header: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(bottom: 20),
          padding: const pw.EdgeInsets.only(bottom: 8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('HomeSync - Báo Cáo Danh Mục Tài Sản & Bảo Hành',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              pw.Text(DateFormatter.format(DateTime.now()),
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            ],
          ),
        ),
        build: (context) => [
          // Tiêu đề báo cáo
          pw.Text('HỒ SƠ TÀI SẢN & BẢO HIỂM GIA ĐÌNH',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
          pw.SizedBox(height: 6),
          pw.Text('Bất động sản: $homeName  |  Chủ sở hữu: $userName',
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey800)),
          pw.SizedBox(height: 16),

          // Khung tổng kết tài chính
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.blue200),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Column(
                  children: [
                    pw.Text('Tổng số thiết bị', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    pw.SizedBox(height: 4),
                    pw.Text('${items.length}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text('Tổng giá trị tài sản ước tính', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    pw.SizedBox(height: 4),
                    pw.Text(CurrencyFormatter.format(totalValue), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Bảng danh mục tài sản
          pw.TableHelper.fromTextArray(
            headers: ['STT', 'Tên thiết bị / Hãng', 'Vị trí', 'Số Serial', 'Ngày mua', 'Hạn bảo hành', 'Giá trị (VNĐ)'],
            data: List<List<dynamic>>.generate(items.length, (index) {
              final item = items[index];
              return [
                '${index + 1}',
                '${item.name}\n(${item.brand})',
                item.location,
                item.serialNumber ?? '-',
                DateFormatter.format(item.purchaseDate),
                DateFormatter.format(item.warrantyExpiryDate),
                CurrencyFormatter.format(item.price),
              ];
            }),
            headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue700),
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
            ),
            cellAlignment: pw.Alignment.centerLeft,
            cellStyle: const pw.TextStyle(fontSize: 8),
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 20),
          child: pw.Text('Trang ${context.pageNumber} / ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
        ),
      ),
    );

    return pdf.save();
  }

  /// Mở giao diện in hoặc chia sẻ trực tiếp trên điện thoại
  static Future<void> printOrShareReport({
    required String homeName,
    required String userName,
    required List<PdfAssetItem> items,
  }) async {
    final bytes = await generateAssetReport(
      homeName: homeName,
      userName: userName,
      items: items,
    );

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'HomeSync_Bao_Cao_Tai_San_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
}
