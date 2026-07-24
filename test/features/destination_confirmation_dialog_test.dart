import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitor_mall/features/map/data/datasources/local_map_datasource.dart';
import 'package:visitor_mall/features/map/data/repositories/dummy_map_repository.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';
import 'package:visitor_mall/features/map/presentation/pages/map_page.dart';
import 'package:visitor_mall/features/map/presentation/widgets/shop_details_bottom_sheet.dart';
import 'package:visitor_mall/features/navigation/domain/entities/navigation_lifecycle_entity.dart';
import 'package:visitor_mall/features/navigation/domain/entities/active_position_source_entity.dart';
import 'navigation_lifecycle_test.dart';

class EmitTestState extends MapEvent {
  final MapState state;
  const EmitTestState(this.state);

  @override
  List<Object?> get props => [state];
}

class FakeMapBloc extends MapBloc {
  final List<MapEvent> dispatchedEvents = [];

  FakeMapBloc(MapState initialState)
      : super(
          mapRepository: DummyMapRepository(
            localDataSource: LocalMapDataSourceImpl(
              assetBundle: TestAssetBundle(),
            ),
          ),
        ) {
    on<EmitTestState>((event, emit) {
      emit(event.state);
    });
    add(EmitTestState(initialState));
  }

  @override
  void add(MapEvent event) {
    dispatchedEvents.add(event);
    if (event is EmitTestState) {
      super.add(event);
    }
  }
}

void main() {
  late FakeMapBloc fakeMapBloc;
  late ShopEntity shopA;
  late ShopEntity shopB;
  late FloorEntity floor;
  late MapEntity mapEntity;
  late MapLoaded initialMapLoadedState;

  setUp(() {
    shopA = const ShopEntity(
      id: 'shop_A',
      name: 'Shop A',
      category: 'Fashion',
      description: 'Shop A Desc',
      status: 'Open',
      rating: 4.5,
      offer: 'None',
      geometry: RectangleGeometry(x: 50, y: 50, width: 60, height: 60),
      entranceNodeIds: ['node_1'],
    );

    shopB = const ShopEntity(
      id: 'shop_B',
      name: 'Shop B',
      category: 'Food',
      description: 'Shop B Desc',
      status: 'Open',
      rating: 4.5,
      offer: 'None',
      geometry: RectangleGeometry(x: 280, y: 280, width: 40, height: 40),
      entranceNodeIds: ['node_3'],
    );

    floor = FloorEntity(
      id: 'floor_1',
      name: 'Floor 1',
      svgPath: '',
      shops: [shopA, shopB],
      navigationGraph: const NavigationGraphEntity(nodes: [], edges: []),
      connectors: const [],
    );

    mapEntity = MapEntity(id: 'mall_1', floors: [floor]);

    initialMapLoadedState = MapLoaded(
      mapEntity: mapEntity,
      currentFloor: floor,
      shops: [shopA, shopB],
      selectedShopId: null,
      searchResults: const [],
      searchQuery: '',
      activeRoute: null,
      navigationSession: null,
      latestPosition: null,
      instructions: const [],
      preview: null,
      isPreviewMode: false,
      isVoiceMuted: false,
      categories: const [],
      selectedCategory: null,
      navigationLifecycleState: NavigationLifecycleState.idle,
      activePositionSource: null,
    );
  });

  Widget buildTestWidget(FakeMapBloc bloc) {
    return MaterialApp(
      home: BlocProvider<MapBloc>(
        create: (_) => bloc,
        child: const Scaffold(body: MapPageBody()),
      ),
    );
  }

  testWidgets(
    'Navigate button starts navigation immediately if NOT navigating',
    (WidgetTester tester) async {
      fakeMapBloc = FakeMapBloc(initialMapLoadedState);

      await tester.pumpWidget(buildTestWidget(fakeMapBloc));
      await tester.pumpAndSettle();

      // Emit new state with selected shop
      fakeMapBloc.add(
        EmitTestState(initialMapLoadedState.copyWith(selectedShopId: 'shop_A')),
      );
      await tester.pumpAndSettle();

      // Check bottom sheet is open
      expect(find.byType(ShopDetailsBottomSheet), findsOneWidget);
      expect(find.text('Shop A'), findsOneWidget);

      // Find and tap Navigate button
      final navigateButton = find.text('Navigate to Store');
      expect(navigateButton, findsOneWidget);
      await tester.tap(navigateButton);
      await tester.pumpAndSettle();

      // Verify no dialog is shown
      expect(find.byType(AlertDialog), findsNothing);

      // Verify CalculateRoute and StartNavigation events are dispatched
      expect(
        fakeMapBloc.dispatchedEvents.any((e) => e is CalculateRoute),
        isTrue,
      );
      expect(
        fakeMapBloc.dispatchedEvents.any((e) => e is StartNavigation),
        isTrue,
      );
    },
  );

  testWidgets(
    'Navigate button shows confirmation dialog if navigation IS active',
    (WidgetTester tester) async {
      final activeNavState = initialMapLoadedState.copyWith(
        selectedShopId: null, // Start with null shop selected
        navigationLifecycleState: NavigationLifecycleState.navigating,
        navigationSession: NavigationSessionEntity(
          destinationShopId: 'shop_A',
          destinationEntranceId: 'node_1',
          route: const NavigationRouteEntity(
            completeRoute: [],
            segments: [],
            totalDistance: 10.0,
          ),
          segments: const [],
          currentSegmentIndex: 0,
          currentFloorId: 'floor_1',
          nextConnectorId: null,
          remainingDistance: 10.0,
          estimatedWalkingDistance: 10.0,
          navigationStatus: NavigationStatus.navigating,
        ),
        latestPosition: IndoorPositionEntity(
          id: 'user_pos',
          floorId: 'floor_1',
          x: 50.0,
          y: 50.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        ),
        activeRoute: const NavigationRouteEntity(
          completeRoute: [],
          segments: [],
          totalDistance: 10.0,
        ),
      );

      fakeMapBloc = FakeMapBloc(activeNavState);

      await tester.pumpWidget(buildTestWidget(fakeMapBloc));
      await tester.pumpAndSettle();

      // Select new shop B to show details bottom sheet
      fakeMapBloc.add(
        EmitTestState(activeNavState.copyWith(selectedShopId: 'shop_B')),
      );
      await tester.pumpAndSettle();

      // Tap Navigate
      final navigateButton = find.text('Navigate to Store');
      await tester.tap(navigateButton);
      await tester.pumpAndSettle();

      // Verify AlertDialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Replace current destination?'), findsOneWidget);
      expect(find.descendant(of: find.byType(AlertDialog), matching: find.text('Shop A')), findsOneWidget);
      expect(find.descendant(of: find.byType(AlertDialog), matching: find.text('Shop B')), findsOneWidget);
    },
  );

  testWidgets(
    'Keep Current Route dismisses dialog and does not dispatch switch event',
    (WidgetTester tester) async {
      final activeNavState = initialMapLoadedState.copyWith(
        selectedShopId: null,
        navigationLifecycleState: NavigationLifecycleState.navigating,
        navigationSession: NavigationSessionEntity(
          destinationShopId: 'shop_A',
          destinationEntranceId: 'node_1',
          route: const NavigationRouteEntity(
            completeRoute: [],
            segments: [],
            totalDistance: 10.0,
          ),
          segments: const [],
          currentSegmentIndex: 0,
          currentFloorId: 'floor_1',
          nextConnectorId: null,
          remainingDistance: 10.0,
          estimatedWalkingDistance: 10.0,
          navigationStatus: NavigationStatus.navigating,
        ),
        latestPosition: IndoorPositionEntity(
          id: 'user_pos',
          floorId: 'floor_1',
          x: 50.0,
          y: 50.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        ),
        activeRoute: const NavigationRouteEntity(
          completeRoute: [],
          segments: [],
          totalDistance: 10.0,
        ),
      );

      fakeMapBloc = FakeMapBloc(activeNavState);

      await tester.pumpWidget(buildTestWidget(fakeMapBloc));
      await tester.pumpAndSettle();

      // Select new shop B
      fakeMapBloc.add(
        EmitTestState(activeNavState.copyWith(selectedShopId: 'shop_B')),
      );
      await tester.pumpAndSettle();

      // Tap Navigate
      final navigateButton = find.text('Navigate to Store');
      await tester.tap(navigateButton);
      await tester.pumpAndSettle();

      // Tap Keep Current Route
      final cancelButton = find.text('Keep Current Route');
      expect(cancelButton, findsOneWidget);
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.byType(AlertDialog), findsNothing);

      // Verify DestinationSwitchRequested was NOT dispatched
      expect(
        fakeMapBloc.dispatchedEvents.any((e) => e is DestinationSwitchRequested),
        isFalse,
      );
    },
  );

  testWidgets(
    'Navigate to This Shop dispatches DestinationSwitchRequested',
    (WidgetTester tester) async {
      final activeNavState = initialMapLoadedState.copyWith(
        selectedShopId: null,
        navigationLifecycleState: NavigationLifecycleState.navigating,
        navigationSession: NavigationSessionEntity(
          destinationShopId: 'shop_A',
          destinationEntranceId: 'node_1',
          route: const NavigationRouteEntity(
            completeRoute: [],
            segments: [],
            totalDistance: 10.0,
          ),
          segments: const [],
          currentSegmentIndex: 0,
          currentFloorId: 'floor_1',
          nextConnectorId: null,
          remainingDistance: 10.0,
          estimatedWalkingDistance: 10.0,
          navigationStatus: NavigationStatus.navigating,
        ),
        latestPosition: IndoorPositionEntity(
          id: 'user_pos',
          floorId: 'floor_1',
          x: 50.0,
          y: 50.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        ),
        activeRoute: const NavigationRouteEntity(
          completeRoute: [],
          segments: [],
          totalDistance: 10.0,
        ),
      );

      fakeMapBloc = FakeMapBloc(activeNavState);

      await tester.pumpWidget(buildTestWidget(fakeMapBloc));
      await tester.pumpAndSettle();

      // Select new shop B
      fakeMapBloc.add(
        EmitTestState(activeNavState.copyWith(selectedShopId: 'shop_B')),
      );
      await tester.pumpAndSettle();

      // Tap Navigate
      final navigateButton = find.text('Navigate to Store');
      await tester.tap(navigateButton);
      await tester.pumpAndSettle();

      // Tap Navigate to This Shop
      final confirmButton = find.text('Navigate to This Shop');
      expect(confirmButton, findsOneWidget);
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.byType(AlertDialog), findsNothing);

      // Verify DestinationSwitchRequested was dispatched with shop_B
      expect(
        fakeMapBloc.dispatchedEvents.any(
          (e) =>
              e is DestinationSwitchRequested &&
              e.newDestinationShopId == 'shop_B',
        ),
        isTrue,
      );
    },
  );
}
