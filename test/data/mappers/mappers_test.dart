import 'package:flutter_test/flutter_test.dart';
import 'package:home_sync/features/items/data/mappers/item_mapper.dart';
import 'package:home_sync/features/items/data/models/item_model.dart';
import 'package:home_sync/features/maintenance/data/mappers/category_mapper.dart';
import 'package:home_sync/features/maintenance/data/mappers/maintenance_task_mapper.dart';
import 'package:home_sync/features/maintenance/data/models/category_model.dart';
import 'package:home_sync/features/maintenance/data/models/maintenance_task_model.dart';
import 'package:home_sync/features/profile/data/mappers/home_mapper.dart';
import 'package:home_sync/features/profile/data/mappers/profile_mapper.dart';
import 'package:home_sync/features/profile/data/models/home_model.dart';
import 'package:home_sync/features/profile/data/models/profile_model.dart';
import 'package:home_sync/features/service_logs/data/mappers/service_log_mapper.dart';
import 'package:home_sync/features/service_logs/data/models/service_log_model.dart';

void main() {
  group('Feature-First Clean Architecture Data Mappers Test', () {
    test('ProfileMapper converts bidirectionally with high fidelity', () {
      final model = ProfileModel(
        id: 'u-1',
        fullName: 'Nguyễn Văn A',
        avatarUrl: 'https://avatar.png',
        oneSignalPlayerId: 'os-123',
        reminderDaysBefore: 7,
      );

      final entity = ProfileMapper.toEntity(model);
      expect(entity.id, equals('u-1'));
      expect(entity.fullName, equals('Nguyễn Văn A'));

      final backToModel = ProfileMapper.toModel(entity);
      expect(backToModel.id, equals(model.id));
      expect(backToModel.fullName, equals(model.fullName));
    });

    test('ItemMapper converts bidirectionally preserving dates and calculations', () {
      final model = ItemModel(
        id: 'item-100',
        userId: 'u-1',
        name: 'Điều hòa Daikin Inverter',
        brand: 'Daikin',
        purchaseDate: DateTime(2026, 1, 1),
        warrantyExpiryDate: DateTime(2028, 1, 1),
        price: 15500000.0,
        supportPhone: '18006777',
      );

      final entity = ItemMapper.toEntity(model);
      expect(entity.name, equals('Điều hòa Daikin Inverter'));
      expect(entity.price, equals(15500000.0));
      expect(entity.isGood, isTrue);

      final backToModel = ItemMapper.toModel(entity);
      expect(backToModel.name, equals(model.name));
      expect(backToModel.purchaseDate, equals(model.purchaseDate));
    });

    test('MaintenanceTaskMapper and ServiceLogMapper convert correctly', () {
      final taskModel = MaintenanceTaskModel(
        id: 'task-1',
        itemId: 'item-100',
        taskName: 'Vệ sinh lưới lọc bụi',
        frequencyMonths: 6,
        nextDueDate: DateTime(2026, 12, 1),
        technicianPhone: '0901234567',
      );

      final taskEntity = MaintenanceTaskMapper.toEntity(taskModel);
      expect(taskEntity.taskName, equals('Vệ sinh lưới lọc bụi'));
      expect(taskEntity.technicianPhone, equals('0901234567'));

      final serviceLogModel = ServiceLogModel(
        id: 'log-1',
        userId: 'u-1',
        itemId: 'item-100',
        serviceType: 'maintenance',
        title: 'Vệ sinh & nạp gas điều hòa',
        serviceDate: DateTime(2026, 6, 15),
        cost: 450000.0,
      );

      final logEntity = ServiceLogMapper.toEntity(serviceLogModel);
      expect(logEntity.title, equals('Vệ sinh & nạp gas điều hòa'));
      expect(logEntity.cost, equals(450000.0));
    });

    test('HomeMapper and CategoryMapper convert correctly', () {
      final homeModel = HomeModel(id: 'h-1', ownerId: 'u-1', name: 'Nhà riêng');
      final homeEntity = HomeMapper.toEntity(homeModel);
      expect(homeEntity.name, equals('Nhà riêng'));

      final catModel = CategoryModel(id: 'c-1', name: 'Điện lạnh', iconName: 'wind');
      final catEntity = CategoryMapper.toEntity(catModel);
      expect(catEntity.name, equals('Điện lạnh'));
      expect(catEntity.iconName, equals('wind'));
    });
  });
}
