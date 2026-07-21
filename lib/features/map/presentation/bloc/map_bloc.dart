import 'dart:async';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/map_repository.dart';
import '../../domain/repositories/position_repository.dart';
import '../../domain/services/pathfinding_service.dart';
import '../../domain/services/navigation_progress_service.dart';
import '../../domain/services/navigation_simulation_service.dart';
import '../../domain/entities/map_entities.dart';
import '../../domain/entities/position_entities.dart';
import '../../domain/services/navigation_instruction_service.dart';
import '../../domain/services/route_preview_service.dart';
import '../../domain/services/text_to_speech_service.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository mapRepository;
  final PositionRepository? positionRepository;
  final TextToSpeechService _ttsService = TextToSpeechService();
  StreamSubscription<IndoorPositionEntity>? _positionSubscription;
  bool _isRecalculating = false;

  MapBloc({required this.mapRepository, this.positionRepository})
    : super(const MapInitial()) {
    print('MAP BLOC CREATED ${identityHashCode(this)}');
    on<LoadMap>(_onLoadMap);
    on<SelectShop>(_onSelectShop);
    on<ClearSelection>(_onClearSelection);
    on<SearchShops>(_onSearchShops);
    on<ClearSearch>(_onClearSearch);
    on<CalculateRoute>(_onCalculateRoute);
    on<StartNavigation>(_onStartNavigation);
    on<ClearRoute>(_onClearRoute);
    on<AdvanceToNextSegment>(_onAdvanceToNextSegment);
    on<CompleteFloorTransition>(_onCompleteFloorTransition);
    on<CancelNavigation>(_onCancelNavigation);
    on<StartPositioning>(_onStartPositioning);
    on<StopPositioning>(_onStopPositioning);
    on<UpdateUserPosition>(_onUpdateUserPosition);
    on<SelectFloor>(_onSelectFloor);
    on<ToggleVoiceGuidance>(_onToggleVoiceGuidance);
  }

  @override
  void onEvent(MapEvent event) {
    super.onEvent(event);
    print('EVENT RECEIVED ${event.runtimeType} at ${DateTime.now()}');
  }

  Future<void> _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    emit(const MapLoading());
    try {
      final mapData = await mapRepository.getMapData();
      if (mapData.floors.isEmpty) {
        emit(const MapError('No floors found in map data.'));
        return;
      }
      final currentFloor = mapData.floors.first;
      emit(
        MapLoaded(
          mapEntity: mapData,
          currentFloor: currentFloor,
          shops: currentFloor.shops,
        ),
      );
      add(const StartPositioning());
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  void _onSelectShop(SelectShop event, Emitter<MapState> emit) {
    final currentState = state;
    if (currentState is MapLoaded) {
      // Find the floor that contains this shop
      FloorEntity targetFloor = currentState.currentFloor;
      for (final floor in currentState.mapEntity.floors) {
        if (floor.shops.any((s) => s.id == event.shopId)) {
          targetFloor = floor;
          break;
        }
      }

      emit(
        MapLoaded(
          mapEntity: currentState.mapEntity,
          currentFloor: targetFloor,
          shops: targetFloor.shops,
          selectedShopId: event.shopId,
          searchResults: currentState.searchResults,
          searchQuery: currentState.searchQuery,
          activeRoute: null,
          navigationSession: null,
        ),
      );
    }
  }

  void _onClearSelection(ClearSelection event, Emitter<MapState> emit) {
    final currentState = state;
    if (currentState is MapLoaded) {
      emit(
        MapLoaded(
          mapEntity: currentState.mapEntity,
          currentFloor: currentState.currentFloor,
          shops: currentState.shops,
          selectedShopId: null,
          searchResults: currentState.searchResults,
          searchQuery: currentState.searchQuery,
          activeRoute: currentState.activeRoute,
          navigationSession: currentState.navigationSession,
          latestPosition: currentState.latestPosition,
          instructions: currentState.instructions,
        ),
      );
    }
  }

  Future<void> _onSearchShops(SearchShops event, Emitter<MapState> emit) async {
    final currentState = state;
    if (currentState is MapLoaded) {
      if (event.query.trim().isEmpty) {
        emit(currentState.copyWith(searchResults: [], searchQuery: ''));
        return;
      }
      final results = await mapRepository.searchShops(event.query);
      final filteredResults = results
          .where((s) => s.category != 'Corridor' && s.category != 'Escalator')
          .toList();
      emit(
        currentState.copyWith(
          searchResults: filteredResults,
          searchQuery: event.query,
        ),
      );
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<MapState> emit) {
    final currentState = state;
    if (currentState is MapLoaded) {
      emit(
        MapLoaded(
          mapEntity: currentState.mapEntity,
          currentFloor: currentState.currentFloor,
          shops: currentState.shops,
          selectedShopId: currentState.selectedShopId,
          searchResults: null,
          searchQuery: null,
          activeRoute: currentState.activeRoute,
          navigationSession: currentState.navigationSession,
          latestPosition: currentState.latestPosition,
          instructions: currentState.instructions,
        ),
      );
    }
  }

  void _onCalculateRoute(CalculateRoute event, Emitter<MapState> emit) {
    final currentState = state;
    if (currentState is MapLoaded) {
      _isRecalculating = false;
      String resolvedStartNodeId = event.startNodeId ?? '';
      final latestPos = currentState.latestPosition;
      debugPrint("========== NEW ROUTE ==========");
debugPrint("latestPosition: ${latestPos?.floorId}");
debugPrint("x=${latestPos?.x}");
debugPrint("y=${latestPos?.y}");
debugPrint("resolvedStartNodeId=$resolvedStartNodeId");
debugPrint("destination=${event.endNodeId}");
      
      if (resolvedStartNodeId.isEmpty && latestPos == null) {
        resolvedStartNodeId = currentState.currentFloor.id == 'first_floor' ? 'H101' : 'H007';
      }

      if (latestPos != null) {
        FloorEntity? userFloor;
        for (final floor in currentState.mapEntity.floors) {
          if (floor.id == latestPos.floorId) {
            userFloor = floor;
            break;
          }
        }

        if (userFloor != null) {
          ShopEntity? containingShop;
          for (final shop in userFloor.shops) {
            if (shop.category == 'Corridor' || shop.category == 'Escalator') {
              continue;
            }
            if (shop.geometry.contains(Point2D(latestPos.x, latestPos.y))) {
              containingShop = shop;
              break;
            }
          }

          if (containingShop != null && containingShop.entranceNodeIds.isNotEmpty) {
            resolvedStartNodeId = containingShop.entranceNodeIds.first;
          } else {
            double minDistanceSq = double.infinity;
            NavigationNodeEntity? nearestNode;
            for (final node in userFloor.navigationGraph.nodes) {
              final dx = latestPos.x - node.x;
              final dy = latestPos.y - node.y;
              final distSq = dx * dx + dy * dy;
              if (distSq < minDistanceSq) {
                minDistanceSq = distSq;
                nearestNode = node;
              }
            }
            if (nearestNode != null) {
              resolvedStartNodeId = nearestNode.id;
            }
          }
        }
      }

      final floors = currentState.mapEntity.floors.map((f) => f).toList();
      final pathfindGraph = (latestPos != null)
          ? (floors.firstWhere(
              (f) => f.id == latestPos.floorId,
              orElse: () => currentState.currentFloor,
            ).navigationGraph)
          : currentState.currentFloor.navigationGraph;

      final nodes = PathfindingService.findPath(
        graph: pathfindGraph,
        startNodeId: resolvedStartNodeId,
        endNodeId: event.endNodeId,
        floors: currentState.mapEntity.floors,
      );

      NavigationRouteEntity? routeEntity;

      if (nodes.isNotEmpty) {
        final List<RouteSegmentEntity> segments = [];
        final List<int> floorChangeIndices = [];
        for (int i = 0; i < nodes.length - 1; i++) {
          if (nodes[i].floorId != nodes[i + 1].floorId) {
            floorChangeIndices.add(i);
          }
        }

        if (floorChangeIndices.isEmpty) {
          segments.add(
            RouteSegmentEntity(
              floorId: nodes.first.floorId,
              nodes: nodes,
            ),
          );
        } else {
          int startIdx = 0;
          for (final changeIdx in floorChangeIndices) {
            segments.add(
              RouteSegmentEntity(
                floorId: nodes[startIdx].floorId,
                nodes: nodes.sublist(startIdx, changeIdx + 1),
              ),
            );
            segments.add(
              RouteSegmentEntity(
                floorId: 'transition',
                nodes: [nodes[changeIdx], nodes[changeIdx + 1]],
              ),
            );
            startIdx = changeIdx + 1;
          }
          if (startIdx < nodes.length) {
            segments.add(
              RouteSegmentEntity(
                floorId: nodes[startIdx].floorId,
                nodes: nodes.sublist(startIdx),
              ),
            );
          }
        }

        double totalDistance = 0.0;
        for (int i = 0; i < nodes.length - 1; i++) {
          final n1 = nodes[i];
          final n2 = nodes[i + 1];
          double dist = 0.0;

          if (n1.floorId == n2.floorId) {
            final floor = currentState.mapEntity.floors.firstWhere(
              (f) => f.id == n1.floorId,
            );
            for (final edge in floor.navigationGraph.edges) {
              if ((edge.fromNodeId == n1.id && edge.toNodeId == n2.id) ||
                  (edge.fromNodeId == n2.id && edge.toNodeId == n1.id)) {
                dist = edge.distance;
                break;
              }
            }
          }

          if (dist == 0.0) {
            final dx = n1.x - n2.x;
            final dy = n1.y - n2.y;
            dist = sqrt(dx * dx + dy * dy);
          }
          totalDistance += dist;
        }

        routeEntity = NavigationRouteEntity(
          completeRoute: nodes,
          segments: segments,
          totalDistance: totalDistance,
        );

        String destinationShopId = '';
        for (final floor in currentState.mapEntity.floors) {
          for (final shop in floor.shops) {
            if (shop.entranceNodeIds.contains(event.endNodeId)) {
              destinationShopId = shop.id;
              break;
            }
          }
          if (destinationShopId.isNotEmpty) break;
        }

        final previewEntity = RoutePreviewService.generatePreview(
          route: routeEntity,
          floors: currentState.mapEntity.floors,
          destinationShopId: destinationShopId,
        );

        emit(
          MapLoaded(
            mapEntity: currentState.mapEntity,
            currentFloor: currentState.currentFloor,
            shops: currentState.shops,
            selectedShopId: currentState.selectedShopId,
            searchResults: currentState.searchResults,
            searchQuery: currentState.searchQuery,
            activeRoute: routeEntity,
            navigationSession: null,
            latestPosition: currentState.latestPosition,
            instructions: null,
            preview: previewEntity,
            isPreviewMode: true,
          ),
        );
      }
    }
  }

  void _onStartNavigation(StartNavigation event, Emitter<MapState> emit) {
    print('START NAVIGATION CALLED on MapBloc ${identityHashCode(this)}');
    debugPrint('START NAVIGATION EVENT RECEIVED');
    final currentState = state;
    if (currentState is MapLoaded && currentState.activeRoute != null) {
      final routeEntity = currentState.activeRoute!;
      final endNodeId = routeEntity.completeRoute.isNotEmpty
          ? routeEntity.completeRoute.last.id
          : '';

      String destinationShopId = '';
      for (final floor in currentState.mapEntity.floors) {
        for (final shop in floor.shops) {
          if (shop.entranceNodeIds.contains(endNodeId)) {
            destinationShopId = shop.id;
            break;
          }
        }
        if (destinationShopId.isNotEmpty) break;
      }

      String? nextConnectorId;
      if (routeEntity.segments.length > 1) {
        final firstSeg = routeEntity.segments[0];
        final lastNodeId = firstSeg.nodes.last.id;
        final matchingFloors = currentState.mapEntity.floors.where((f) => f.id == firstSeg.floorId);
        final currentFloor = matchingFloors.isNotEmpty
            ? matchingFloors.first
            : currentState.currentFloor;
        for (final conn in currentFloor.connectors) {
          if (conn.navigationNodeId == lastNodeId) {
            nextConnectorId = conn.id;
            break;
          }
        }
      }

      final sessionEntity = NavigationSessionEntity(
        destinationShopId: destinationShopId,
        destinationEntranceId: endNodeId,
        route: routeEntity,
        segments: routeEntity.segments,
        currentSegmentIndex: 0,
        currentFloorId: routeEntity.segments.isNotEmpty
            ? routeEntity.segments.first.floorId
            : currentState.currentFloor.id,
        nextConnectorId: nextConnectorId,
        remainingDistance: routeEntity.totalDistance,
        estimatedWalkingDistance: routeEntity.totalDistance,
        navigationStatus: NavigationStatus.navigating,
      );

      final instructions = NavigationInstructionService.generateInstructions(
        route: routeEntity,
        floors: currentState.mapEntity.floors,
        destinationShopId: destinationShopId,
      );

      _isRecalculating = false;

      final startNode = routeEntity.completeRoute.isNotEmpty
          ? routeEntity.completeRoute.first
          : null;

      final initialPosition = startNode != null
          ? IndoorPositionEntity(
              id: 'start_pos_${startNode.id}',
              floorId: startNode.floorId,
              x: startNode.x,
              y: startNode.y,
              accuracy: 1.0,
              timestamp: DateTime.now(),
              source: PositionSource.simulation,
            )
          : currentState.latestPosition;

      emit(
        MapLoaded(
          mapEntity: currentState.mapEntity,
          currentFloor: currentState.currentFloor,
          shops: currentState.shops,
          selectedShopId: currentState.selectedShopId,
          searchResults: currentState.searchResults,
          searchQuery: currentState.searchQuery,
          activeRoute: routeEntity,
          navigationSession: sessionEntity,
          latestPosition: initialPosition,
          instructions: instructions,
          preview: currentState.preview,
          isPreviewMode: false,
        ),
      );

      if (positionRepository != null) {
        final simPath = NavigationSimulationService.generateSimulationPath(
          routeEntity,
        );
        positionRepository!.loadPositionPath(simPath);
        add(const StartPositioning());
      }
    }
  }

  void _onClearRoute(ClearRoute event, Emitter<MapState> emit) {
    print('CLEAR ROUTE DISPATCHED');
    final currentState = state;
    if (currentState is MapLoaded) {
      emit(
        MapLoaded(
          mapEntity: currentState.mapEntity,
          currentFloor: currentState.currentFloor,
          shops: currentState.shops,
          selectedShopId: currentState.selectedShopId,
          searchResults: currentState.searchResults,
          searchQuery: currentState.searchQuery,
          activeRoute: null,
          navigationSession: null,
          latestPosition: currentState.latestPosition,
          instructions: null,
          preview: null,
          isPreviewMode: false,
        ),
      );
    }
  }

  void _onAdvanceToNextSegment(
    AdvanceToNextSegment event,
    Emitter<MapState> emit,
  ) {
    final currentState = state;
    if (currentState is MapLoaded && currentState.navigationSession != null) {
      final session = currentState.navigationSession!;

      final updatedSession = NavigationSessionEntity(
        destinationShopId: session.destinationShopId,
        destinationEntranceId: session.destinationEntranceId,
        route: session.route,
        segments: session.segments,
        currentSegmentIndex: session.currentSegmentIndex,
        currentFloorId: session.currentFloorId,
        nextConnectorId: session.nextConnectorId,
        remainingDistance: session.remainingDistance,
        estimatedWalkingDistance: session.estimatedWalkingDistance,
        navigationStatus: NavigationStatus.waitingForConnector,
      );

      emit(
        MapLoaded(
          mapEntity: currentState.mapEntity,
          currentFloor: currentState.currentFloor,
          shops: currentState.shops,
          selectedShopId: currentState.selectedShopId,
          searchResults: currentState.searchResults,
          searchQuery: currentState.searchQuery,
          activeRoute: currentState.activeRoute,
          navigationSession: updatedSession,
          latestPosition: currentState.latestPosition,
          instructions: currentState.instructions,
        ),
      );
    }
  }

  void _onCompleteFloorTransition(
    CompleteFloorTransition event,
    Emitter<MapState> emit,
  ) {
    final currentState = state;
    if (currentState is MapLoaded && currentState.navigationSession != null) {
      final session = currentState.navigationSession!;

      if (session.currentSegmentIndex < session.segments.length - 1) {
        if (session.navigationStatus == NavigationStatus.waitingForConnector) {
          final updatedSession = NavigationSessionEntity(
            destinationShopId: session.destinationShopId,
            destinationEntranceId: session.destinationEntranceId,
            route: session.route,
            segments: session.segments,
            currentSegmentIndex: session.currentSegmentIndex,
            currentFloorId: session.currentFloorId,
            nextConnectorId: session.nextConnectorId,
            remainingDistance: session.remainingDistance,
            estimatedWalkingDistance: session.estimatedWalkingDistance,
            navigationStatus: NavigationStatus.transitioningFloor,
          );

          emit(
            MapLoaded(
              mapEntity: currentState.mapEntity,
              currentFloor: currentState.currentFloor,
              shops: currentState.shops,
              selectedShopId: currentState.selectedShopId,
              searchResults: currentState.searchResults,
              searchQuery: currentState.searchQuery,
              activeRoute: currentState.activeRoute,
              navigationSession: updatedSession,
              latestPosition: currentState.latestPosition,
              instructions: currentState.instructions,
            ),
          );
          return;
        }

        final nextIndex = session.currentSegmentIndex + 1;
        final nextFloorId = session.segments[nextIndex].floorId;
        final floors = currentState.mapEntity.floors.map((f) => f).toList();
        final nextFloor = floors.firstWhere(
          (f) => f.id == nextFloorId,
          orElse: () => currentState.currentFloor,
        );

        String? nextConnectorId;
        if (nextIndex < session.segments.length - 1) {
          final nextSeg = session.segments[nextIndex];
          final lastNodeId = nextSeg.nodes.last.id;
          for (final conn in nextFloor.connectors) {
            if (conn.navigationNodeId == lastNodeId) {
              nextConnectorId = conn.id;
              break;
            }
          }
        }

        double remainingDistance = 0.0;
        for (int s = nextIndex; s < session.segments.length; s++) {
          final seg = session.segments[s];
          for (int i = 0; i < seg.nodes.length - 1; i++) {
            final n1 = seg.nodes[i];
            final n2 = seg.nodes[i + 1];
            double dist = 0.0;
            for (final edge in nextFloor.navigationGraph.edges) {
              if ((edge.fromNodeId == n1.id && edge.toNodeId == n2.id) ||
                  (edge.fromNodeId == n2.id && edge.toNodeId == n1.id)) {
                dist = edge.distance;
                break;
              }
            }
            if (dist == 0.0) {
              final dx = n1.x - n2.x;
              final dy = n1.y - n2.y;
              dist = sqrt(dx * dx + dy * dy);
            }
            remainingDistance += dist;
          }
        }

        final updatedSession = NavigationSessionEntity(
          destinationShopId: session.destinationShopId,
          destinationEntranceId: session.destinationEntranceId,
          route: session.route,
          segments: session.segments,
          currentSegmentIndex: nextIndex,
          currentRouteNodeIndex: session.currentRouteNodeIndex,
          currentFloorId: nextFloorId,
          nextConnectorId: nextConnectorId,
          remainingDistance: remainingDistance,
          estimatedWalkingDistance: session.estimatedWalkingDistance,
          navigationStatus: NavigationStatus.navigating,
        );

        emit(
          MapLoaded(
            mapEntity: currentState.mapEntity,
            currentFloor: nextFloor,
            shops: nextFloor.shops,
            selectedShopId: currentState.selectedShopId,
            searchResults: currentState.searchResults,
            searchQuery: currentState.searchQuery,
            activeRoute: currentState.activeRoute,
            navigationSession: updatedSession,
            latestPosition: currentState.latestPosition,
            instructions: currentState.instructions,
          ),
        );
      } else {
        final updatedSession = NavigationSessionEntity(
          destinationShopId: session.destinationShopId,
          destinationEntranceId: session.destinationEntranceId,
          route: session.route,
          segments: session.segments,
          currentSegmentIndex: session.currentSegmentIndex,
          currentFloorId: session.currentFloorId,
          nextConnectorId: session.nextConnectorId,
          remainingDistance: 0.0,
          estimatedWalkingDistance: session.estimatedWalkingDistance,
          navigationStatus: NavigationStatus.arrived,
        );

        emit(
          MapLoaded(
            mapEntity: currentState.mapEntity,
            currentFloor: currentState.currentFloor,
            shops: currentState.shops,
            selectedShopId: currentState.selectedShopId,
            searchResults: currentState.searchResults,
            searchQuery: currentState.searchQuery,
            activeRoute: currentState.activeRoute,
            navigationSession: updatedSession,
            latestPosition: currentState.latestPosition,
            instructions: currentState.instructions,
          ),
        );
      }
    }
  }

  void _onCancelNavigation(CancelNavigation event, Emitter<MapState> emit) {
    print('CANCEL NAVIGATION DISPATCHED');
    final currentState = state;
    if (currentState is MapLoaded) {
      emit(
        MapLoaded(
          mapEntity: currentState.mapEntity,
          currentFloor: currentState.currentFloor,
          shops: currentState.shops,
          selectedShopId: currentState.selectedShopId,
          searchResults: currentState.searchResults,
          searchQuery: currentState.searchQuery,
          activeRoute: null,
          navigationSession: null,
          latestPosition: currentState.latestPosition,
          instructions: null,
        ),
      );
    }
  }

  void _onStartPositioning(StartPositioning event, Emitter<MapState> emit) {
    if (positionRepository == null) return;
    _positionSubscription?.cancel();
    _positionSubscription = positionRepository!.positionStream.listen((pos) {
      add(UpdateUserPosition(pos));
    });
    positionRepository!.startPositioning();
  }

  void _onStopPositioning(StopPositioning event, Emitter<MapState> emit) {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    positionRepository?.stopPositioning();
  }

  void _onUpdateUserPosition(UpdateUserPosition event, Emitter<MapState> emit) {
    final currentState = state;
    if (currentState is MapLoaded) {
      if (event.position.x.isNaN || event.position.y.isNaN) {
        return;
      }
      final session = currentState.navigationSession;
      if (session != null &&
          session.navigationStatus != NavigationStatus.arrived &&
          session.navigationStatus != NavigationStatus.cancelled) {
        
        final isOffRoute = NavigationProgressService.checkOffRoute(
          position: event.position,
          session: session,
          threshold: 30.0,
        );

        if (isOffRoute && 
            session.navigationStatus == NavigationStatus.navigating && 
            !_isRecalculating) {
          _isRecalculating = true;
          _ttsService.speak(
            speechKey: 'off_route',
            text: 'Recalculating route',
            force: true,
          );
          positionRepository?.loadPositionPath([]);
          final endNodeId = session.route.completeRoute.last.id;
          add(CalculateRoute(endNodeId: endNodeId));
          return;
        }
        
        NavigationSessionEntity activeSession = session;
        FloorEntity visibleFloor = currentState.currentFloor;
        var visibleShops = currentState.shops;

        if (event.position.floorId != session.currentFloorId) {
          final targetSegmentIdx = session.segments.indexWhere(
            (seg) => seg.floorId == event.position.floorId,
          );

          if (targetSegmentIdx != -1 && targetSegmentIdx > session.currentSegmentIndex) {
            final floors = currentState.mapEntity.floors.map((f) => f).toList();
            final nextFloor = floors.firstWhere(
              (f) => f.id == event.position.floorId,
              orElse: () => currentState.currentFloor,
            );

            visibleFloor = nextFloor;
            visibleShops = nextFloor.shops;

            String? nextConnectorId;
            if (targetSegmentIdx < session.segments.length - 1) {
              final nextSeg = session.segments[targetSegmentIdx];
              final lastNodeId = nextSeg.nodes.last.id;
              for (final conn in nextFloor.connectors) {
                if (conn.navigationNodeId == lastNodeId) {
                  nextConnectorId = conn.id;
                  break;
                }
              }
            }

            activeSession = NavigationSessionEntity(
              destinationShopId: session.destinationShopId,
              destinationEntranceId: session.destinationEntranceId,
              route: session.route,
              segments: session.segments,
              currentSegmentIndex: targetSegmentIdx,
              currentFloorId: event.position.floorId,
              nextConnectorId: nextConnectorId,
              remainingDistance: session.remainingDistance,
              estimatedWalkingDistance: session.estimatedWalkingDistance,
              navigationStatus: NavigationStatus.navigating,
            );
          }
        }

        final result = NavigationProgressService.evaluateProgress(
          position: event.position,
          session: activeSession,
          threshold: 15.0,
        );

        NavigationSessionEntity? updatedSession = activeSession;

        if (result.hasReachedDestination) {
          updatedSession = activeSession.copyWith(
            currentRouteNodeIndex: result.currentRouteNodeIndex,
            remainingDistance: 0.0,
            navigationStatus: NavigationStatus.arrived,
          );
          _ttsService.speak(
            speechKey: 'arrived',
            text: 'You have arrived at your destination',
            force: true,
          );
        } else if (result.shouldAdvanceSegment &&
            activeSession.navigationStatus == NavigationStatus.navigating) {
          final nextSegIdx = activeSession.currentSegmentIndex + 1;
          if (nextSegIdx < activeSession.segments.length) {
            final nextSeg = activeSession.segments[nextSegIdx];
            if (nextSeg.floorId == 'transition') {
              updatedSession = activeSession.copyWith(
                currentSegmentIndex: nextSegIdx,
                currentRouteNodeIndex: result.currentRouteNodeIndex,
                currentFloorId: 'transition',
                remainingDistance: result.remainingDistance,
                navigationStatus: NavigationStatus.transitioningFloor,
              );
            } else {
              updatedSession = activeSession.copyWith(
                currentRouteNodeIndex: result.currentRouteNodeIndex,
                remainingDistance: result.remainingDistance,
                navigationStatus: NavigationStatus.waitingForConnector,
              );
            }
          } else {
            updatedSession = activeSession.copyWith(
              currentRouteNodeIndex: result.currentRouteNodeIndex,
              remainingDistance: result.remainingDistance,
              navigationStatus: NavigationStatus.waitingForConnector,
            );
          }
        } else {
          updatedSession = activeSession.copyWith(
            currentRouteNodeIndex: result.currentRouteNodeIndex,
            remainingDistance: result.remainingDistance,
          );
        }

        final updatedInstructions = NavigationInstructionService.updateInstructionProgress(
          instructions: currentState.instructions ?? [],
          nearestRouteIndex: result.nearestRouteIndex,
          currentRouteNodeIndex: result.currentRouteNodeIndex,
          position: event.position,
          route: updatedSession.route,
        );

        if (updatedInstructions.isNotEmpty) {
          final activeInstIndex = updatedInstructions.indexWhere((inst) => !inst.isCompleted);
          final activeInst = activeInstIndex != -1
              ? updatedInstructions[activeInstIndex]
              : updatedInstructions.last;
          
          if (updatedSession.navigationStatus != NavigationStatus.arrived) {
            _ttsService.speak(
              speechKey: 'inst_${activeInst.instructionId}_${activeInst.type}',
              text: activeInst.text,
            );
          }

          double distToTrigger = 0.0;
          if (activeInst.endNodeIndex < updatedSession.route.completeRoute.length) {
            final triggerNode = updatedSession.route.completeRoute[activeInst.endNodeIndex];
            final dx = event.position.x - triggerNode.x;
            final dy = event.position.y - triggerNode.y;
            distToTrigger = sqrt(dx * dx + dy * dy);
          }

          debugPrint('--------------------------------------------------');
          debugPrint('Blue Dot Position: (${event.position.x.toStringAsFixed(1)}, ${event.position.y.toStringAsFixed(1)}) on ${event.position.floorId}');
          debugPrint('Current Route Node: ${result.currentRouteNodeIndex}');
          debugPrint('Current Active Instruction Index: ${activeInstIndex != -1 ? activeInstIndex : updatedInstructions.length - 1}');
          debugPrint('Instruction: ${activeInst.text}');
          debugPrint('Instruction Type: ${activeInst.type}');
          debugPrint('Distance To Trigger Node: ${distToTrigger.toStringAsFixed(1)}');
          debugPrint('Instruction Completed: ${activeInst.isCompleted}');
          debugPrint('--------------------------------------------------');
        }

        debugPrint(
          'STATE latestPosition: ${event.position.floorId} ${event.position.x} ${event.position.y}',
        );
        print('EMITTING NEW MAPLOADED');
        emit(
          MapLoaded(
            mapEntity: currentState.mapEntity,
            currentFloor: visibleFloor,
            shops: visibleShops,
            selectedShopId: currentState.selectedShopId,
            searchResults: currentState.searchResults,
            searchQuery: currentState.searchQuery,
            activeRoute: currentState.activeRoute,
            navigationSession: updatedSession,
            latestPosition: event.position,
            instructions: updatedInstructions,
          ),
        );
        print('MAPLOADED EMITTED');
        print('EXIT UPDATE USER POSITION');
        return;
      }

      print('EMITTING NEW MAPLOADED (no session)');
      emit(currentState.copyWith(latestPosition: event.position));
      print('MAPLOADED EMITTED (no session)');
      print('EXIT UPDATE USER POSITION');
    }
  }

  void _onSelectFloor(SelectFloor event, Emitter<MapState> emit) {
    final currentState = state;
    if (currentState is MapLoaded) {
      try {
        final selectedFloor = currentState.mapEntity.floors.firstWhere(
          (f) => f.id == event.floorId,
        );
        final hasActiveSession = currentState.navigationSession != null;
        emit(
          MapLoaded(
            mapEntity: currentState.mapEntity,
            currentFloor: selectedFloor,
            shops: selectedFloor.shops,
            selectedShopId: hasActiveSession ? currentState.selectedShopId : null,
            searchResults: hasActiveSession ? currentState.searchResults : null,
            searchQuery: hasActiveSession ? currentState.searchQuery : null,
            activeRoute: currentState.activeRoute,
            navigationSession: currentState.navigationSession,
            latestPosition: currentState.latestPosition,
            instructions: currentState.instructions,
          ),
        );
      } catch (_) {
        // Floor not found, do nothing
      }
    }
  }

  void _onToggleVoiceGuidance(ToggleVoiceGuidance event, Emitter<MapState> emit) {
    final currentState = state;
    if (currentState is MapLoaded) {
      _ttsService.toggleMute();
      emit(currentState.copyWith(isVoiceMuted: _ttsService.isMuted));
    }
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _ttsService.stop();
    return super.close();
  }
}
