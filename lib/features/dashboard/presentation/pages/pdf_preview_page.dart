import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:home_sync/core/services/pdf_export_service.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_cubit.dart';

/// Màn hình Xem trước & In/Chia sẻ Báo Cáo PDF Tài Sản Bảo Hiểm
class PdfPreviewPage extends StatelessWidget {
  const PdfPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final userName = authState is Authenticated
        ? (authState.user.fullName?.isNotEmpty == true ? authState.user.fullName! : 'Gia đình')
        : 'Gia đình';

    final itemsState = context.read<ItemListCubit>().state;
    final items = itemsState is ItemListLoaded ? itemsState.items : [];

    final pdfItems = items
        .map(
          (e) => PdfAssetItem(
            name: e.name,
            brand: e.brand ?? 'Khác',
            category: e.categoryName ?? 'Thiết bị',
            location: e.location ?? 'Chung',
            purchaseDate: e.purchaseDate,
            warrantyExpiryDate: e.warrantyExpiryDate,
            serialNumber: e.serialNumber,
            price: e.price,
            status: e.status,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo Cáo PDF Bảo Hiểm'),
      ),
      body: PdfPreview(
        build: (format) => PdfExportService.generateAssetReport(
          homeName: 'Tài sản Gia đình',
          userName: userName,
          items: pdfItems,
        ),
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        pdfFileName: 'Bao_Cao_Tai_San_HomeSync.pdf',
      ),
    );
  }
}
