import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/features/items/domain/entities/item_entity.dart';
import 'package:home_sync/features/items/domain/usecases/item_usecases.dart';
import 'package:home_sync/features/items/presentation/cubit/item_list_cubit.dart';
import 'package:home_sync/core/usecases/usecase.dart';
import 'package:home_sync/features/maintenance/domain/entities/category_entity.dart';
import 'package:home_sync/features/maintenance/domain/usecases/maintenance_usecases.dart';
import 'package:mocktail/mocktail.dart';

class MockGetItemsUseCase extends Mock implements GetItemsUseCase {}
class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}
class MockToggleFavoriteUseCase extends Mock implements ToggleFavoriteUseCase {}

void main() {
  late MockGetItemsUseCase mockGetItems;
  late MockGetCategoriesUseCase mockGetCategories;
  late MockToggleFavoriteUseCase mockToggleFavorite;
  late ItemListCubit itemListCubit;

  final tItems = [
    ItemEntity(
      id: 'item-1',
      userId: 'u-1',
      name: 'Điều hòa Daikin',
      brand: 'Daikin',
      purchaseDate: DateTime(2026, 1, 1),
      warrantyExpiryDate: DateTime(2028, 1, 1),
      location: 'Phòng khách',
      isFavorite: true,
    ),
    ItemEntity(
      id: 'item-2',
      userId: 'u-1',
      name: 'Tủ lạnh Panasonic',
      brand: 'Panasonic',
      purchaseDate: DateTime(2025, 5, 1),
      warrantyExpiryDate: DateTime(2027, 5, 1),
      location: 'Nhà bếp',
      isFavorite: false,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(const GetItemsParams());
    registerFallbackValue(const ToggleFavoriteParams(id: 'any', isFavorite: true));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockGetItems = MockGetItemsUseCase();
    mockGetCategories = MockGetCategoriesUseCase();
    mockToggleFavorite = MockToggleFavoriteUseCase();
    when(() => mockGetCategories(any())).thenAnswer((_) async => const Right(<CategoryEntity>[]));

    itemListCubit = ItemListCubit(
      getItemsUseCase: mockGetItems,
      getCategoriesUseCase: mockGetCategories,
      toggleFavoriteUseCase: mockToggleFavorite,
    );
  });

  tearDown(() {
    itemListCubit.close();
  });

  group('ItemListCubit State Machine & Filter Tests', () {
    test('initial state should be ItemListInitial', () {
      expect(itemListCubit.state, isA<ItemListInitial>());
    });

    blocTest<ItemListCubit, ItemListState>(
      'emits [ItemListLoading, ItemListLoaded] when loadItems succeeds',
      build: () {
        when(() => mockGetItems(any())).thenAnswer((_) async => Right(tItems));
        return itemListCubit;
      },
      act: (cubit) => cubit.loadItems(),
      expect: () => [
        isA<ItemListLoading>(),
        isA<ItemListLoaded>()
            .having((s) => s.items.length, 'items.length', 2)
            .having((s) => s.filteredItems.length, 'filteredItems.length', 2),
      ],
    );

    blocTest<ItemListCubit, ItemListState>(
      'filters items by search query correctly',
      build: () {
        when(() => mockGetItems(any())).thenAnswer((_) async => Right(tItems));
        return itemListCubit;
      },
      act: (cubit) async {
        await cubit.loadItems();
        cubit.search('Daikin');
      },
      expect: () => [
        isA<ItemListLoading>(),
        isA<ItemListLoaded>().having((s) => s.filteredItems.length, 'all items', 2),
        isA<ItemListLoaded>()
            .having((s) => s.filteredItems.length, 'matched items', 1)
            .having((s) => s.filteredItems.first.name, 'item name', 'Điều hòa Daikin'),
      ],
    );

    blocTest<ItemListCubit, ItemListState>(
      'filters items by location correctly',
      build: () {
        when(() => mockGetItems(any())).thenAnswer((_) async => Right(tItems));
        return itemListCubit;
      },
      act: (cubit) async {
        await cubit.loadItems();
        cubit.filterByLocation('Nhà bếp');
      },
      expect: () => [
        isA<ItemListLoading>(),
        isA<ItemListLoaded>().having((s) => s.filteredItems.length, 'all items', 2),
        isA<ItemListLoaded>()
            .having((s) => s.filteredItems.length, 'filtered by location', 1)
            .having((s) => s.filteredItems.first.location, 'location', 'Nhà bếp'),
      ],
    );

    blocTest<ItemListCubit, ItemListState>(
      'emits [ItemListLoading, ItemListError] when loadItems fails',
      build: () {
        when(() => mockGetItems(any())).thenAnswer((_) async => const Left(ServerFailure('Không thể tải danh sách')));
        return itemListCubit;
      },
      act: (cubit) => cubit.loadItems(),
      expect: () => [
        isA<ItemListLoading>(),
        isA<ItemListError>().having((s) => s.message, 'error message', 'Không thể tải danh sách'),
      ],
    );
  });
}
