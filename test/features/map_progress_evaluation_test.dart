import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/services/navigation_progress_service.dart';
import 'package:visitor_mall/features/map/domain/entities/navigation_instruction_entity.dart';
import 'package:visitor_mall/features/map/domain/services/navigation_instruction_service.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';
import 'map_crossfloor_test.dart'; // Reuse MockMapRepository

void main() {
  group('NavigationProgressService Pure Unit Tests', () {
    const node1 = NavigationNodeEntity(
      id: 'N01',
      x: 10.0,
      y: 10.0,
      floorId: 'g',
      type: 'hallway',
    );
    const node2 = NavigationNodeEntity(
      id: 'N02',
      x: 20.0,
      y: 10.0,
      floorId: 'g',
      type: 'hallway',
    );
    const node3 = NavigationNodeEntity(
      id: 'N03',
      x: 30.0,
      y: 10.0,
      floorId: 'g',
      type: 'hallway',
    );

    const segment = RouteSegmentEntity(
      floorId: 'g',
      nodes: [node1, node2, node3],
    );

    const route = NavigationRouteEntity(
      completeRoute: [node1, node2, node3],
      segments: [segment],
      totalDistance: 20.0,
    );

    const session = NavigationSessionEntity(
      destinationShopId: 'shop_zara',
      destinationEntranceId: 'N03',
      route: route,
      segments: [segment],
      currentSegmentIndex: 0,
      currentFloorId: 'g',
      nextConnectorId: null,
      remainingDistance: 20.0,
      estimatedWalkingDistance: 20.0,
      navigationStatus: NavigationStatus.navigating,
    );

    test('Identifies the closest route node and index correctly', () {
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 18.0,
        y: 10.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final result = NavigationProgressService.evaluateProgress(
        position: pos,
        session: session,
      );

      expect(result.nearestNodeId, 'N02');
      expect(result.nearestRouteIndex, 1);
    });

    test('checkOffRoute returns false when user is close to path segments', () {
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 15.0,
        y: 12.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final isOffRoute = NavigationProgressService.checkOffRoute(
        position: pos,
        session: session,
        threshold: 30.0,
      );

      expect(isOffRoute, isFalse);
    });

    test('checkOffRoute returns true when user deviates past threshold', () {
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 15.0,
        y: 45.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final isOffRoute = NavigationProgressService.checkOffRoute(
        position: pos,
        session: session,
        threshold: 30.0,
      );

      expect(isOffRoute, isTrue);
    });

    test('checkOffRoute returns true when user is on a different floor', () {
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'first_floor',
        x: 15.0,
        y: 10.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final isOffRoute = NavigationProgressService.checkOffRoute(
        position: pos,
        session: session,
        threshold: 30.0,
      );

      expect(isOffRoute, isTrue);
    });

    test('Correctly computes remaining distance dynamically', () {
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 18.0,
        y: 10.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final result = NavigationProgressService.evaluateProgress(
        position: pos,
        session: session,
        threshold: 5.0,
      );

      // Distance from user(18) to node2(20) is 2.0. Plus distance from node2(20) to node3(30) is 10.0.
      // Total remaining distance should be 12.0
      expect(result.remainingDistance, closeTo(12.0, 0.001));
    });

    test(
      'Path-based remaining distance decreases monotonically as user advances along segment edges',
      () {
        final nodes = [
          const NavigationNodeEntity(
            id: 'N01',
            x: 0.0,
            y: 0.0,
            floorId: 'g',
            type: 'hallway',
          ),
          const NavigationNodeEntity(
            id: 'N02',
            x: 10.0,
            y: 0.0,
            floorId: 'g',
            type: 'hallway',
          ),
          const NavigationNodeEntity(
            id: 'N03',
            x: 10.0,
            y: 10.0,
            floorId: 'g',
            type: 'hallway',
          ),
        ];
        final route = NavigationRouteEntity(
          completeRoute: nodes,
          segments: [RouteSegmentEntity(floorId: 'g', nodes: nodes)],
          totalDistance: 20.0,
        );
        final session = NavigationSessionEntity(
          destinationShopId: 'shop_zara',
          destinationEntranceId: 'N03',
          route: route,
          segments: route.segments,
          currentSegmentIndex: 0,
          currentFloorId: 'g',
          remainingDistance: 20.0,
          estimatedWalkingDistance: 20.0,
          navigationStatus: NavigationStatus.navigating,
        );

        final pos1 = IndoorPositionEntity(
          id: 'u1',
          floorId: 'g',
          x: 0.0,
          y: 0.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );
        final res1 = NavigationProgressService.evaluateProgress(
          position: pos1,
          session: session,
          threshold: 5.0,
        );
        expect(res1.remainingDistance, closeTo(20.0, 0.01));

        final pos2 = IndoorPositionEntity(
          id: 'u2',
          floorId: 'g',
          x: 4.0,
          y: 0.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );
        final res2 = NavigationProgressService.evaluateProgress(
          position: pos2,
          session: session,
          threshold: 5.0,
        );
        expect(res2.remainingDistance, closeTo(16.0, 0.01));

        final pos3 = IndoorPositionEntity(
          id: 'u3',
          floorId: 'g',
          x: 10.0,
          y: 3.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );
        final res3 = NavigationProgressService.evaluateProgress(
          position: pos3,
          session: session,
          threshold: 5.0,
        );
        expect(res3.remainingDistance, closeTo(7.0, 0.01));
      },
    );

    test('Forward-only progression prevents backtracking node search', () {
      // Create session with currentRouteNodeIndex set to 1 (at N02)
      final advancedSession = session.copyWith(currentRouteNodeIndex: 1);

      // User position is near N01 (x: 5.0, y: 10.0), which is physically closer to N01 than N02
      final posNearN01 = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 5.0,
        y: 10.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final result = NavigationProgressService.evaluateProgress(
        position: posNearN01,
        session: advancedSession,
      );

      // Node index must remain 1 and not backtrack to 0
      expect(result.currentRouteNodeIndex, 1);
    });

    test(
      'Junction threshold rule activates turn instruction only within threshold',
      () {
        final junctionNodes = [
          const NavigationNodeEntity(
            id: 'N01',
            x: 0.0,
            y: 0.0,
            floorId: 'g',
            type: 'hallway',
          ),
          const NavigationNodeEntity(
            id: 'N02',
            x: 50.0,
            y: 0.0,
            floorId: 'g',
            type: 'hallway',
          ),
          const NavigationNodeEntity(
            id: 'N03',
            x: 50.0,
            y: 50.0,
            floorId: 'g',
            type: 'hallway',
          ),
        ];
        final jRoute = NavigationRouteEntity(
          completeRoute: junctionNodes,
          segments: [RouteSegmentEntity(floorId: 'g', nodes: junctionNodes)],
          totalDistance: 100.0,
        );

        final instructions = [
          const NavigationInstructionEntity(
            instructionId: 'inst1',
            type: 'straight',
            text: 'Continue straight',
            floorId: 'g',
            relatedNodeId: 'N01',
            distanceRemaining: 50.0,
            isCompleted: false,
            startNodeIndex: 0,
            endNodeIndex: 1,
          ),
          const NavigationInstructionEntity(
            instructionId: 'inst2',
            type: 'right',
            text: 'Turn right',
            floorId: 'g',
            relatedNodeId: 'N02',
            distanceRemaining: 0.0,
            isCompleted: false,
            startNodeIndex: 1,
            endNodeIndex: 1,
          ),
        ];

        // User is at (20, 0), which is 30m away from junction N02 (50, 0) -> > 12m threshold
        final posFar = IndoorPositionEntity(
          id: 'u_far',
          floorId: 'g',
          x: 20.0,
          y: 0.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );
        final updatedFar =
            NavigationInstructionService.updateInstructionProgress(
              instructions: instructions,
              nearestRouteIndex: 0,
              currentRouteNodeIndex: 0,
              position: posFar,
              route: jRoute,
              junctionThreshold: 12.0,
            );

        // Straight instruction is not completed yet (user is >12m from junction)
        expect(updatedFar[0].isCompleted, isFalse);
        expect(updatedFar[1].isCompleted, isFalse);

        // User walks to (40, 0), which is 10m away from junction N02 (50, 0) -> <= 12m threshold
        final posNear = IndoorPositionEntity(
          id: 'u_near',
          floorId: 'g',
          x: 40.0,
          y: 0.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );
        final updatedNear =
            NavigationInstructionService.updateInstructionProgress(
              instructions: instructions,
              nearestRouteIndex: 0,
              currentRouteNodeIndex: 0,
              position: posNear,
              route: jRoute,
              junctionThreshold: 12.0,
            );

        // Straight instruction completes as user enters junction threshold, making Turn right the active instruction
        expect(updatedNear[0].isCompleted, isTrue);
        expect(updatedNear[1].isCompleted, isFalse);
      },
    );

    test('Checks next node reached based on configurable threshold', () {
      // User is at (18, 10), node2 is at (20, 10). Distance is 2.0.
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 18.0,
        y: 10.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      // 1. With threshold of 5.0 (greater than 2.0), hasReachedNextNode should be true
      final result1 = NavigationProgressService.evaluateProgress(
        position: pos,
        session: session,
        threshold: 5.0,
      );
      expect(result1.hasReachedNextNode, isTrue);

      // 2. With threshold of 1.0 (smaller than 2.0), hasReachedNextNode should be false
      final result2 = NavigationProgressService.evaluateProgress(
        position: pos,
        session: session,
        threshold: 1.0,
      );
      expect(result2.hasReachedNextNode, isFalse);
    });

    test(
      'Detects destination arrival correctly when near final entrance node',
      () {
        // User is at (28, 10), node3 (destination) is at (30, 10). Distance is 2.0.
        final pos = IndoorPositionEntity(
          id: 'user_pos',
          floorId: 'g',
          x: 28.0,
          y: 10.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );

        final result = NavigationProgressService.evaluateProgress(
          position: pos,
          session: session,
          threshold: 5.0,
        );

        expect(result.hasReachedDestination, isTrue);
      },
    );

    test('Detects connector arrival correctly when near segment connector', () {
      const connSegment = RouteSegmentEntity(
        floorId: 'g',
        nodes: [node1, node2], // node2 is connector node
      );

      const connSession = NavigationSessionEntity(
        destinationShopId: 'shop_zara',
        destinationEntranceId: 'N03',
        route: route,
        segments: [connSegment],
        currentSegmentIndex: 0,
        currentFloorId: 'g',
        nextConnectorId: 'conn_g1',
        remainingDistance: 20.0,
        estimatedWalkingDistance: 20.0,
        navigationStatus: NavigationStatus.navigating,
      );

      // User is at (18, 10), node2 (connector node) is at (20, 10).
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 18.0,
        y: 10.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final result = NavigationProgressService.evaluateProgress(
        position: pos,
        session: connSession,
        threshold: 5.0,
      );

      expect(result.hasReachedConnector, isTrue);
      expect(result.shouldAdvanceSegment, isTrue);
      expect(result.shouldBeginFloorTransition, isTrue);
    });

    test('generateInstructions creates correct straight and turn steps', () {
      final nodes = [
        const NavigationNodeEntity(
          id: 'N01',
          x: 0.0,
          y: 0.0,
          floorId: 'g',
          type: 'hallway',
        ),
        const NavigationNodeEntity(
          id: 'N02',
          x: 0.0,
          y: 10.0,
          floorId: 'g',
          type: 'hallway',
        ),
        const NavigationNodeEntity(
          id: 'N03',
          x: 10.0,
          y: 10.0,
          floorId: 'g',
          type: 'hallway',
        ),
      ];
      final route = NavigationRouteEntity(
        completeRoute: nodes,
        segments: [RouteSegmentEntity(floorId: 'g', nodes: nodes)],
        totalDistance: 20.0,
      );

      final instructions = NavigationInstructionService.generateInstructions(
        route: route,
        floors: const [],
        destinationShopId: 'shop_zara',
      );

      expect(instructions.length, 4);
      expect(instructions[0].type, 'straight');
      expect(instructions[0].text, 'Head straight');
      expect(instructions[0].startNodeIndex, 0);
      expect(instructions[0].endNodeIndex, 1);

      expect(instructions[1].type, 'left');
      expect(instructions[1].text, 'Turn left');
      expect(instructions[1].startNodeIndex, 1);
      expect(instructions[1].endNodeIndex, 1);

      expect(instructions[2].type, 'straight');
      expect(instructions[2].text, 'Continue straight');
      expect(instructions[2].startNodeIndex, 1);
      expect(instructions[2].endNodeIndex, 2);

      expect(instructions[3].type, 'arrival');
      expect(instructions[3].text, contains('your destination'));
    });

    test('generateInstructions creates correct connector steps', () {
      final nodes = [
        const NavigationNodeEntity(
          id: 'N01',
          x: 0.0,
          y: 0.0,
          floorId: 'g',
          type: 'hallway',
        ),
        const NavigationNodeEntity(
          id: 'L01',
          x: 0.0,
          y: 10.0,
          floorId: 'g',
          type: 'lift',
        ),
        const NavigationNodeEntity(
          id: 'L02',
          x: 0.0,
          y: 10.0,
          floorId: 'f1',
          type: 'lift',
        ),
        const NavigationNodeEntity(
          id: 'N02',
          x: 10.0,
          y: 10.0,
          floorId: 'f1',
          type: 'hallway',
        ),
      ];
      final route = NavigationRouteEntity(
        completeRoute: nodes,
        segments: [
          RouteSegmentEntity(floorId: 'g', nodes: [nodes[0], nodes[1]]),
          RouteSegmentEntity(
            floorId: 'transition',
            nodes: [nodes[1], nodes[2]],
          ),
          RouteSegmentEntity(floorId: 'f1', nodes: [nodes[2], nodes[3]]),
        ],
        totalDistance: 20.0,
      );

      final floors = [
        const FloorEntity(
          id: 'g',
          name: 'Ground Floor',
          svgPath: '',
          shops: [],
          navigationGraph: NavigationGraphEntity(nodes: [], edges: []),
          connectors: [
            ConnectorEntity(
              id: 'c1',
              floorId: 'g',
              navigationNodeId: 'L01',
              connectorType: 'lift',
              accessible: true,
            ),
          ],
        ),
        const FloorEntity(
          id: 'f1',
          name: 'First Floor',
          svgPath: '',
          shops: [],
          navigationGraph: NavigationGraphEntity(nodes: [], edges: []),
          connectors: [],
        ),
      ];

      final instructions = NavigationInstructionService.generateInstructions(
        route: route,
        floors: floors,
        destinationShopId: 'shop_zara',
      );

      expect(instructions.length, 5);
      expect(instructions[0].text, 'Proceed to Lift');
      expect(instructions[1].text, 'Take Lift to First Floor');
      expect(instructions[2].text, 'Exit Lift');
      expect(instructions[3].text, 'Continue straight');
      expect(instructions[4].type, 'arrival');
    });

    test(
      'Consecutive turns with short corridor generate and complete in strict sequential order',
      () {
        final nodes = [
          const NavigationNodeEntity(
            id: 'N01',
            x: 0.0,
            y: 0.0,
            floorId: 'g',
            type: 'hallway',
          ),
          const NavigationNodeEntity(
            id: 'N02',
            x: 50.0,
            y: 0.0,
            floorId: 'g',
            type: 'hallway',
          ),
          const NavigationNodeEntity(
            id: 'N03',
            x: 50.0,
            y: 5.0,
            floorId: 'g',
            type: 'hallway',
          ), // short 5m corridor, turn right
          const NavigationNodeEntity(
            id: 'N04',
            x: 100.0,
            y: 5.0,
            floorId: 'g',
            type: 'hallway',
          ),
        ];
        final route = NavigationRouteEntity(
          completeRoute: nodes,
          segments: [RouteSegmentEntity(floorId: 'g', nodes: nodes)],
          totalDistance: 105.0,
        );

        final instructions = NavigationInstructionService.generateInstructions(
          route: route,
          floors: const [
            FloorEntity(
              id: 'g',
              name: 'Ground',
              svgPath: '',
              shops: [],
              navigationGraph: NavigationGraphEntity(nodes: [], edges: []),
              connectors: [],
            ),
          ],
          destinationShopId: 'zara',
        );

        // Verify instruction sequence contains: Head straight -> Turn right -> Continue straight -> Turn left -> Continue straight -> Arrived
        expect(instructions.length, 6);
        expect(instructions[0].type, 'straight');
        expect(instructions[1].type, 'right');
        expect(instructions[2].type, 'straight'); // short corridor preserved!
        expect(instructions[3].type, 'left');
        expect(instructions[4].type, 'straight');
        expect(instructions[5].type, 'arrival');

        // Test progression: at start (0,0), instructions 0..5 are uncompleted
        final posStart = IndoorPositionEntity(
          id: 'u',
          floorId: 'g',
          x: 0.0,
          y: 0.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );
        final res1 = NavigationInstructionService.updateInstructionProgress(
          instructions: instructions,
          nearestRouteIndex: 0,
          currentRouteNodeIndex: 0,
          position: posStart,
          route: route,
        );
        expect(res1[0].isCompleted, false);
        expect(res1[1].isCompleted, false);
        expect(res1[2].isCompleted, false);

        // Advance to (49, 0) - near N02 turn left
        final posN02 = IndoorPositionEntity(
          id: 'u',
          floorId: 'g',
          x: 49.0,
          y: 0.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );
        final res2 = NavigationInstructionService.updateInstructionProgress(
          instructions: instructions,
          nearestRouteIndex: 1,
          currentRouteNodeIndex: 1,
          position: posN02,
          route: route,
        );
        expect(res2[0].isCompleted, true); // Head straight completed
        expect(res2[1].isCompleted, false); // Turn right active at junction!
        expect(res2[2].isCompleted, false); // Short corridor NOT yet completed!
      },
    );

    test(
      'Turn instruction becomes active at junction threshold and completes after stepping past junction',
      () {
        final nodes = [
          const NavigationNodeEntity(
            id: 'N01',
            x: 0.0,
            y: 0.0,
            floorId: 'g',
            type: 'hallway',
          ),
          const NavigationNodeEntity(
            id: 'N02',
            x: 100.0,
            y: 0.0,
            floorId: 'g',
            type: 'hallway',
          ),
          const NavigationNodeEntity(
            id: 'N03',
            x: 100.0,
            y: 100.0,
            floorId: 'g',
            type: 'hallway',
          ),
        ];
        final route = NavigationRouteEntity(
          completeRoute: nodes,
          segments: [RouteSegmentEntity(floorId: 'g', nodes: nodes)],
          totalDistance: 200.0,
        );

        final instructions = NavigationInstructionService.generateInstructions(
          route: route,
          floors: const [
            FloorEntity(
              id: 'g',
              name: 'Ground',
              svgPath: '',
              shops: [],
              navigationGraph: NavigationGraphEntity(nodes: [], edges: []),
              connectors: [],
            ),
          ],
          destinationShopId: 'zara',
        );

        // Step 1: User at (50, 0) - 50m from junction N02.
        // Instruction 0 (Head straight) MUST be active. Instruction 1 (Turn right) MUST NOT be active.
        final posFar = IndoorPositionEntity(
          id: 'u',
          floorId: 'g',
          x: 50.0,
          y: 0.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );
        final resFar = NavigationInstructionService.updateInstructionProgress(
          instructions: instructions,
          nearestRouteIndex: 0,
          currentRouteNodeIndex: 0,
          position: posFar,
          route: route,
        );
        final activeInstFar = resFar.firstWhere((inst) => !inst.isCompleted);
        expect(activeInstFar.type, 'straight'); // "Head straight" active

        // Step 2: User at (95, 0) - within 10m threshold of junction N02.
        // Instruction 0 (Head straight) completes. Instruction 1 (Turn right) BECOMES ACTIVE.
        final posNear = IndoorPositionEntity(
          id: 'u',
          floorId: 'g',
          x: 95.0,
          y: 0.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );
        final resNear = NavigationInstructionService.updateInstructionProgress(
          instructions: instructions,
          nearestRouteIndex: 1,
          currentRouteNodeIndex: 1,
          position: posNear,
          route: route,
        );
        final activeInstNear = resNear.firstWhere((inst) => !inst.isCompleted);
        expect(activeInstNear.type, 'right'); // "Turn right" BECOMES ACTIVE!

        // Step 3: User steps past junction N02 to (100, 20).
        // Instruction 1 (Turn right) completes. Instruction 2 (Continue straight) BECOMES ACTIVE.
        final posPast = IndoorPositionEntity(
          id: 'u',
          floorId: 'g',
          x: 100.0,
          y: 20.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );
        final resPast = NavigationInstructionService.updateInstructionProgress(
          instructions: resNear,
          nearestRouteIndex: 1,
          currentRouteNodeIndex: 1,
          position: posPast,
          route: route,
        );
        final activeInstPast = resPast.firstWhere((inst) => !inst.isCompleted);
        expect(activeInstPast.type, 'straight'); // "Continue straight" active!
      },
    );

    test(
      'Anti-tunneling safeguard prevents turn instruction from being skipped on sparse position jumps',
      () {
        final nodes = [
          const NavigationNodeEntity(
            id: 'N01',
            x: 0.0,
            y: 0.0,
            floorId: 'g',
            type: 'hallway',
          ),
          const NavigationNodeEntity(
            id: 'N02',
            x: 100.0,
            y: 0.0,
            floorId: 'g',
            type: 'hallway',
          ),
          const NavigationNodeEntity(
            id: 'N03',
            x: 100.0,
            y: 100.0,
            floorId: 'g',
            type: 'hallway',
          ),
        ];
        final route = NavigationRouteEntity(
          completeRoute: nodes,
          segments: [RouteSegmentEntity(floorId: 'g', nodes: nodes)],
          totalDistance: 200.0,
        );

        final instructions = NavigationInstructionService.generateInstructions(
          route: route,
          floors: const [
            FloorEntity(
              id: 'g',
              name: 'Ground',
              svgPath: '',
              shops: [],
              navigationGraph: NavigationGraphEntity(nodes: [], edges: []),
              connectors: [],
            ),
          ],
          destinationShopId: 'zara',
        );

        // Single large position jump from (50,0) [before junction] to (100, 20) [20m past junction]
        // On pass 1, straight instruction 0 completes, but turn instruction 1 MUST REMAIN ACTIVE (isCompleted = false)!
        final posJump = IndoorPositionEntity(
          id: 'u',
          floorId: 'g',
          x: 100.0,
          y: 20.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );
        final resPass1 = NavigationInstructionService.updateInstructionProgress(
          instructions: instructions,
          nearestRouteIndex: 1,
          currentRouteNodeIndex: 1,
          position: posJump,
          route: route,
        );

        final activeInstPass1 = resPass1.firstWhere(
          (inst) => !inst.isCompleted,
        );
        expect(
          activeInstPass1.type,
          'right',
        ); // Turn instruction MUST BE ACTIVE on pass 1 despite large jump!

        // On pass 2 (subsequent update), turn instruction completes and straight instruction 2 becomes active
        final resPass2 = NavigationInstructionService.updateInstructionProgress(
          instructions: resPass1,
          nearestRouteIndex: 1,
          currentRouteNodeIndex: 1,
          position: posJump,
          route: route,
        );

        final activeInstPass2 = resPass2.firstWhere(
          (inst) => !inst.isCompleted,
        );
        expect(
          activeInstPass2.type,
          'straight',
        ); // Next straight instruction active on pass 2!
      },
    );
  });

  group('MapBloc Progression Integration Tests', () {
    late MockMapRepository mockRepo;
    late MapBloc mapBloc;

    const node1 = NavigationNodeEntity(
      id: 'N01',
      x: 100.0,
      y: 100.0,
      floorId: 'ground_floor',
      type: 'hallway',
    );
    const node2 = NavigationNodeEntity(
      id: 'N02',
      x: 200.0,
      y: 100.0,
      floorId: 'ground_floor',
      type: 'hallway',
    );

    setUp(() {
      final groundFloor = FloorEntity(
        id: 'ground_floor',
        name: 'Ground Floor',
        svgPath: '',
        shops: const [
          ShopEntity(
            id: 'shop_001',
            name: 'Zara',
            category: 'Fashion',
            description: '',
            status: 'open',
            rating: 4.5,
            offer: '',
            geometry: RectangleGeometry(x: 0, y: 0, width: 50, height: 50),
            entranceNodeIds: ['N02'],
          ),
        ],
        navigationGraph: const NavigationGraphEntity(
          nodes: [node1, node2],
          edges: [
            NavigationEdgeEntity(
              fromNodeId: 'N01',
              toNodeId: 'N02',
              distance: 100.0,
            ),
          ],
        ),
        connectors: const [],
      );

      final mapEntity = MapEntity(id: 'mall_phoenix', floors: [groundFloor]);

      mockRepo = MockMapRepository(mapEntity);
      mapBloc = MapBloc(mapRepository: mockRepo);
    });

    tearDown(() {
      mapBloc.close();
    });

    test(
      'MapBloc automatically updates remainingDistance and triggers arrived state on position updates',
      () async {
        // 1. Load Map
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        // 2. Select and Calculate Route to Shop
        mapBloc.add(const CalculateRoute(startNodeId: 'N01', endNodeId: 'N02'));
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        mapBloc.add(const StartNavigation());
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.navigationSession,
              'navigationSession',
              isNotNull,
            ),
          ),
        );

        var state = mapBloc.state as MapLoaded;
        expect(state.navigationSession!.remainingDistance, 100.0);
        expect(
          state.navigationSession!.navigationStatus,
          NavigationStatus.navigating,
        );

        // 3. User moves halfway to (150, 100). Remaining distance should decrease to ~50.0
        final midPos = IndoorPositionEntity(
          id: 'user_pos',
          floorId: 'ground_floor',
          x: 150.0,
          y: 100.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );

        mapBloc.add(UpdateUserPosition(midPos));
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.navigationSession?.remainingDistance,
              'remainingDistance',
              closeTo(50.0, 1.0),
            ),
          ),
        );

        // 4. User arrives at destination entrance (198, 100) (within threshold of 15.0 to N02)
        final arrivalPos = IndoorPositionEntity(
          id: 'user_pos',
          floorId: 'ground_floor',
          x: 198.0,
          y: 100.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );

        mapBloc.add(UpdateUserPosition(arrivalPos));
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>()
                .having(
                  (s) => s.navigationSession?.navigationStatus,
                  'navigationStatus',
                  NavigationStatus.arrived,
                )
                .having(
                  (s) => s.navigationSession?.remainingDistance,
                  'remainingDistance',
                  0.0,
                ),
          ),
        );
      },
    );
  });
}
