import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/core/di/injection_container.dart';
import 'package:home_sync/features/items/domain/repositories/item_repository.dart';
import 'package:home_sync/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:home_sync/features/service_logs/domain/repositories/service_log_repository.dart';

/// Bộ công cụ nạp dữ liệu mẫu chuẩn Clean Architecture (thông qua Repositories & Domain Entities)
class DemoDataSeeder {
  DemoDataSeeder._();

  /// Nạp trọn bộ dữ liệu mẫu (7 thiết bị thuộc đúng 7 danh mục chuẩn + 2 lịch bảo trì + 1 nhật ký chi phí)
  static Future<bool> seedDemoData() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;

    if (user == null) {
      debugPrint('[HOMESYNC SEEDER] ❌ Lỗi: Chưa có phiên đăng nhập người dùng.');
      return false;
    }

    try {
      debugPrint('[HOMESYNC SEEDER] 🚀 Bắt đầu nạp dữ liệu mẫu chuẩn Clean Architecture cho User: ${user.id}...');

      final itemRepository = sl<ItemRepository>();
      final maintenanceRepository = sl<MaintenanceRepository>();
      final serviceLogRepository = sl<ServiceLogRepository>();

      // 1. Lấy danh mục từ Database thông qua MaintenanceRepository
      final categoriesEither = await maintenanceRepository.getCategories();
      final List<CategoryEntity> categories = categoriesEither.getOrElse((_) => []);

      String? getCatId(String name) {
        // Khớp chính xác 100% tên danh mục
        for (final cat in categories) {
          if (cat.name.toLowerCase() == name.toLowerCase()) {
            return cat.id;
          }
        }
        // Khớp theo từ khóa phụ
        for (final cat in categories) {
          if (cat.name.toLowerCase().contains(name.toLowerCase())) {
            return cat.id;
          }
        }
        return categories.isNotEmpty ? categories.first.id : null;
      }

      final catDienLanh = getCatId('Điện lạnh');
      final catDienTu = getCatId('Điện tử');
      final catBep = getCatId('Thiết bị bếp');
      final catGiaDung = getCatId('Gia dụng');
      final catXe = getCatId('Xe cộ');
      final catCaNhan = getCatId('Cá nhân');
      final catKhac = getCatId('Khác');

      final now = DateTime.now();

      // 2. Danh sách 7 thiết bị mẫu tương ứng 7 danh mục chuẩn
      final demoEntities = [
        // 1. Điện lạnh
        ItemEntity(
          id: '',
          userId: user.id,
          categoryId: catDienLanh,
          name: 'Tủ lạnh Panasonic Inverter 550L',
          brand: 'Panasonic',
          modelNumber: 'NR-CW530XMMV',
          serialNumber: 'PANA-550L-9988',
          location: 'Phòng bếp',
          price: 22500000,
          storeName: 'Điện Máy Xanh',
          isFavorite: true,
          purchaseDate: now.subtract(const Duration(days: 180)),
          warrantyPeriodMonths: 24,
          warrantyExpiryDate: now.add(const Duration(days: 545)), // Còn 18 tháng
          supportPhone: '18001593',
          notes: 'Bảo hành chính hãng 24 tháng, máy nén 12 năm.',
        ),

        // 2. Điện tử
        ItemEntity(
          id: '',
          userId: user.id,
          categoryId: catDienTu,
          name: 'Smart TV LG OLED 65 inch 4K',
          brand: 'LG',
          modelNumber: 'OLED65C3PSA',
          serialNumber: 'LG-OLED-6577',
          location: 'Phòng khách',
          price: 38900000,
          storeName: 'Nguyễn Kim',
          isFavorite: true,
          purchaseDate: now.subtract(const Duration(days: 715)),
          warrantyPeriodMonths: 24,
          warrantyExpiryDate: now.add(const Duration(days: 15)), // ⚠️ Sắp hết hạn (15 ngày)
          supportPhone: '18001503',
          notes: 'Cần kiểm tra gia hạn bảo hành Premium Care.',
        ),

        // 3. Thiết bị bếp
        ItemEntity(
          id: '',
          userId: user.id,
          categoryId: catBep,
          name: 'Nồi chiên không dầu Philips XXL',
          brand: 'Philips',
          modelNumber: 'HD9650/91',
          serialNumber: 'PHI-XXL-3344',
          location: 'Phòng bếp',
          price: 4290000,
          storeName: 'Shopee Mall (Philips Official)',
          isFavorite: false,
          purchaseDate: now.subtract(const Duration(days: 450)),
          warrantyPeriodMonths: 12,
          warrantyExpiryDate: now.subtract(const Duration(days: 85)), // ❌ Đã hết hạn bảo hành
          supportPhone: '1800599988',
          notes: 'Đã hết bảo hành chính hãng, hoạt động bình thường.',
        ),

        // 4. Gia dụng
        ItemEntity(
          id: '',
          userId: user.id,
          categoryId: catGiaDung,
          name: 'Máy lọc không khí Dyson Purifier Cool',
          brand: 'Dyson',
          modelNumber: 'TP07',
          serialNumber: 'DYS-TP07-8899',
          location: 'Phòng ngủ',
          price: 17890000,
          storeName: 'Dyson Store Vincom',
          isFavorite: true,
          purchaseDate: now.subtract(const Duration(days: 60)),
          warrantyPeriodMonths: 24,
          warrantyExpiryDate: now.add(const Duration(days: 670)), // Còn tốt
          supportPhone: '18006388',
          notes: 'Nhắc thay màng lọc HEPA sau mỗi 6 tháng.',
        ),

        // 5. Xe cộ
        ItemEntity(
          id: '',
          userId: user.id,
          categoryId: catXe,
          name: 'Xe máy Honda SH 150i ABS 2024',
          brand: 'Honda',
          modelNumber: 'SH150i-2024',
          serialNumber: 'HD-SH-29E1-99999',
          location: 'Ga-ra / Xe',
          price: 98500000,
          storeName: 'HEAD Honda Kường Ngân',
          isFavorite: false,
          purchaseDate: now.subtract(const Duration(days: 120)),
          warrantyPeriodMonths: 36,
          warrantyExpiryDate: now.add(const Duration(days: 975)), // Còn 3 năm
          supportPhone: '18008001',
          notes: 'Bảo hành 3 năm hoặc 30.000km, bảo dưỡng định kỳ 2.000km.',
        ),

        // 6. Cá nhân
        ItemEntity(
          id: '',
          userId: user.id,
          categoryId: catCaNhan,
          name: 'MacBook Pro 16 M3 Max 36GB',
          brand: 'Apple',
          modelNumber: 'MUW63SA/A',
          serialNumber: 'C02G9988MD6M',
          location: 'Nơi làm việc',
          price: 79990000,
          storeName: 'TopZone',
          isFavorite: true,
          purchaseDate: now.subtract(const Duration(days: 90)),
          warrantyPeriodMonths: 12,
          warrantyExpiryDate: now.add(const Duration(days: 275)), // Còn tốt
          supportPhone: '18001127',
          notes: 'Bảo hành Apple Care toàn cầu.',
        ),

        // 7. Khác
        ItemEntity(
          id: '',
          userId: user.id,
          categoryId: catKhac,
          name: 'Bộ máy khoan búa pin Bosch GSB 18V-50',
          brand: 'Bosch',
          modelNumber: 'GSB 18V-50',
          serialNumber: 'BOSCH-18V-5522',
          location: 'Kho đồ / Ban công',
          price: 3650000,
          storeName: 'Bosch Flagship Store',
          isFavorite: false,
          purchaseDate: now.subtract(const Duration(days: 30)),
          warrantyPeriodMonths: 12,
          warrantyExpiryDate: now.add(const Duration(days: 335)), // Còn 11 tháng
          supportPhone: '18001575',
          notes: 'Bảo hành động cơ không chổi than 12 tháng.',
        ),
      ];

      final List<ItemEntity> createdItems = [];
      for (final entity in demoEntities) {
        final result = await itemRepository.addItem(entity);
        result.fold(
          (failure) => debugPrint('[HOMESYNC SEEDER] ⚠️ Không tạo được item "${entity.name}": ${failure.message}'),
          (createdItem) => createdItems.add(createdItem),
        );
      }

      debugPrint('[HOMESYNC SEEDER] ✅ Đã tạo thành công ${createdItems.length} thiết bị mẫu qua ItemRepository.');

      // 3. Tạo 2 Lịch bảo trì mẫu qua MaintenanceRepository
      if (createdItems.isNotEmpty) {
        final firstItem = createdItems[0];
        final secondItem = createdItems.length > 3 ? createdItems[3] : firstItem;

        final task1 = MaintenanceTaskEntity(
          id: '',
          itemId: firstItem.id,
          taskName: 'Vệ sinh lưới lọc & kiểm tra ron cửa tủ lạnh',
          nextDueDate: now.add(const Duration(days: 7)),
          frequencyMonths: 3,
          isCompleted: false,
          priority: 'medium',
        );

        final task2 = MaintenanceTaskEntity(
          id: '',
          itemId: secondItem.id,
          taskName: 'Thay màng lọc không khí HEPA Dyson',
          nextDueDate: now.add(const Duration(days: 18)),
          frequencyMonths: 6,
          isCompleted: false,
          priority: 'high',
        );

        await maintenanceRepository.addTask(task1);
        await maintenanceRepository.addTask(task2);
        debugPrint('[HOMESYNC SEEDER] ✅ Đã tạo 2 lịch bảo trì mẫu qua MaintenanceRepository.');

        // 4. Tạo 1 Nhật ký chi phí mẫu qua ServiceLogRepository
        final log = ServiceLogEntity(
          id: '',
          userId: user.id,
          itemId: firstItem.id,
          serviceType: 'maintenance',
          title: 'Vệ sinh dàn lạnh & nạp ga bổ sung',
          serviceDate: now.subtract(const Duration(days: 5)),
          cost: 650000,
          technicianName: 'Điện Lạnh Bách Khoa',
          notes: 'Đã vệ sinh sạch sẽ, máy lạnh chạy êm và mát sâu.',
        );

        await serviceLogRepository.addLog(log);
        debugPrint('[HOMESYNC SEEDER] ✅ Đã tạo 1 nhật ký chi phí mẫu qua ServiceLogRepository.');
      }

      return true;
    } catch (e, stack) {
      debugPrint('[HOMESYNC SEEDER] ❌ Lỗi khi nạp dữ liệu mẫu: $e');
      debugPrint('$stack');
      return false;
    }
  }
}
