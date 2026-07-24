import 'dart:math';
import '../entities/map_entities.dart';
import '../entities/position_entities.dart';
import '../entities/navigation_instruction_entity.dart';
import 'navigation_progress_service.dart';

class NavigationInstructionService {
  static double angleAtNode(
    NavigationNodeEntity a,
    NavigationNodeEntity b,
    NavigationNodeEntity c,
  ) {
    final ux = b.x - a.x;
    final uy = b.y - a.y;
    final vx = c.x - b.x;
    final vy = c.y - b.y;

    final dot = ux * vx + uy * vy;
    final cross = ux * vy - uy * vx;

    final angleRad = atan2(cross, dot);
    return angleRad * 180.0 / pi;
  }

  static List<NavigationInstructionEntity> generateInstructions({
    required NavigationRouteEntity route,
    required List<FloorEntity> floors,
    required String destinationShopId,
  }) {
    final List<NavigationInstructionEntity> instructions = [];
    final nodes = route.completeRoute;
    if (nodes.isEmpty) return instructions;

    // Find target shop name
    String destinationShopName = '';
    for (final floor in floors) {
      for (final shop in floor.shops) {
        if (shop.id == destinationShopId) {
          destinationShopName = shop.name;
          break;
        }
      }
    }
    if (destinationShopName.isEmpty) {
      destinationShopName = "your destination";
    }

    int instructionCounter = 1;
    String nextId() => 'inst_${instructionCounter++}';

    // Build segment index ranges in completeRoute
    final List<List<int>> segmentRanges = [];
    int tracker = 0;
    for (int s = 0; s < route.segments.length; s++) {
      final seg = route.segments[s];
      final start = tracker;
      final end = tracker + seg.nodes.length - 1;
      segmentRanges.add([start, end]);
      tracker = end;
    }

    for (int s = 0; s < route.segments.length; s++) {
      final segment = route.segments[s];
      final range = segmentRanges[s];
      final segStartIdx = range[0];
      final segEndIdx = range[1];

      if (segment.floorId == 'transition') {
        // Transition Segment
        final sourceNode = segment.nodes.first;
        final targetNode = segment.nodes.last;

        // Find connector type
        String connectorType = 'lift';
        for (final floor in floors) {
          for (final conn in floor.connectors) {
            if (conn.navigationNodeId == sourceNode.id) {
              connectorType = conn.connectorType;
              break;
            }
          }
        }

        // Find target floor name
        String targetFloorName = 'Next Floor';
        for (final floor in floors) {
          if (floor.id == targetNode.floorId) {
            targetFloorName = floor.name;
            break;
          }
        }

        // Generate connector instruction
        String actionText = '';
        if (connectorType == 'lift') {
          actionText = 'Take Lift to $targetFloorName';
        } else if (connectorType == 'escalator') {
          actionText = 'Take Escalator to $targetFloorName';
        } else if (connectorType == 'stairs') {
          actionText = 'Take Stairs to $targetFloorName';
        } else {
          actionText = 'Take connector to $targetFloorName';
        }

        instructions.add(
          NavigationInstructionEntity(
            instructionId: nextId(),
            type: connectorType,
            text: actionText,
            floorId: sourceNode.floorId,
            relatedNodeId: sourceNode.id,
            distanceRemaining: 0.0,
            isCompleted: false,
            startNodeIndex: segStartIdx,
            endNodeIndex: segEndIdx,
          ),
        );

        // Generate "Exit" instruction
        String exitText = 'Exit Lift';
        if (connectorType == 'escalator') {
          exitText = 'Exit Escalator';
        } else if (connectorType == 'stairs') {
          exitText = 'Exit Stairs';
        }

        instructions.add(
          NavigationInstructionEntity(
            instructionId: nextId(),
            type: 'straight',
            text: exitText,
            floorId: targetNode.floorId,
            relatedNodeId: targetNode.id,
            distanceRemaining: 0.0,
            isCompleted: false,
            startNodeIndex: segEndIdx,
            endNodeIndex: segEndIdx,
          ),
        );
      } else {
        // Floor Walking Segment
        final segNodes = segment.nodes;
        if (segNodes.isEmpty) continue;

        if (segNodes.length == 1) {
          final node = segNodes.first;
          instructions.add(
            NavigationInstructionEntity(
              instructionId: nextId(),
              type: 'straight',
              text: instructions.isEmpty
                  ? 'Head straight'
                  : 'Continue straight',
              floorId: segment.floorId,
              relatedNodeId: node.id,
              distanceRemaining: 0.0,
              isCompleted: false,
              startNodeIndex: segStartIdx,
              endNodeIndex: segEndIdx,
            ),
          );
          continue;
        }

        // Detect turns at intermediate indices
        final List<int> turnIndices = [];
        for (int i = 1; i < segNodes.length - 1; i++) {
          final angle = angleAtNode(
            segNodes[i - 1],
            segNodes[i],
            segNodes[i + 1],
          );
          if (angle.abs() > 20.0) {
            turnIndices.add(i);
          }
        }

        final List<int> boundaries = [0, ...turnIndices, segNodes.length - 1];
        for (int b = 0; b < boundaries.length - 1; b++) {
          final startRel = boundaries[b];
          final endRel = boundaries[b + 1];

          final startGlobal = segStartIdx + startRel;
          final endGlobal = segStartIdx + endRel;

          double dist = 0.0;
          for (int i = startRel; i < endRel; i++) {
            final n1 = segNodes[i];
            final n2 = segNodes[i + 1];
            final dx = n2.x - n1.x;
            final dy = n2.y - n1.y;
            dist += sqrt(dx * dx + dy * dy);
          }

          // Check if this straight path ends at a connector node
          bool endsAtConnector = false;
          String connType = 'lift';
          if (endGlobal == segEndIdx && s < route.segments.length - 1) {
            endsAtConnector = true;
            final nextSeg = route.segments[s + 1];
            final connNode = nextSeg.nodes.first;
            for (final floor in floors) {
              for (final conn in floor.connectors) {
                if (conn.navigationNodeId == connNode.id) {
                  connType = conn.connectorType;
                  break;
                }
              }
            }
          }

          String text = instructions.isEmpty
              ? 'Head straight'
              : 'Continue straight';
          if (endsAtConnector) {
            if (connType == 'lift') {
              text = 'Proceed to Lift';
            } else if (connType == 'escalator') {
              text = 'Proceed to Escalator';
            } else if (connType == 'stairs') {
              text = 'Proceed to Stairs';
            } else {
              text = 'Proceed to connector';
            }
          }

          instructions.add(
            NavigationInstructionEntity(
              instructionId: nextId(),
              type: 'straight',
              text: text,
              floorId: segment.floorId,
              relatedNodeId: segNodes[startRel].id,
              distanceRemaining: dist,
              isCompleted: false,
              startNodeIndex: startGlobal,
              endNodeIndex: endGlobal,
            ),
          );

          if (endRel < segNodes.length - 1) {
            final angle = angleAtNode(
              segNodes[endRel - 1],
              segNodes[endRel],
              segNodes[endRel + 1],
            );
            String turnType = 'right';
            String turnText = 'Turn right';

            if (angle > 20.0 && angle <= 45.0) {
              turnType = 'slightRight';
              turnText = 'Slight right turn';
            } else if (angle > 45.0 && angle <= 135.0) {
              turnType = 'right';
              turnText = 'Turn right';
            } else if (angle > 135.0) {
              turnType = 'sharpRight';
              turnText = 'Sharp right turn';
            } else if (angle < -20.0 && angle >= -45.0) {
              turnType = 'slightLeft';
              turnText = 'Slight left turn';
            } else if (angle < -45.0 && angle >= -135.0) {
              turnType = 'left';
              turnText = 'Turn left';
            } else if (angle < -135.0) {
              turnType = 'sharpLeft';
              turnText = 'Sharp left turn';
            }

            instructions.add(
              NavigationInstructionEntity(
                instructionId: nextId(),
                type: turnType,
                text: turnText,
                floorId: segment.floorId,
                relatedNodeId: segNodes[endRel].id,
                distanceRemaining: 0.0,
                isCompleted: false,
                startNodeIndex: endGlobal,
                endNodeIndex: endGlobal,
              ),
            );
          }
        }
      }
    }

    if (instructions.isNotEmpty) {
      instructions.add(
        NavigationInstructionEntity(
          instructionId: nextId(),
          type: 'arrival',
          text: 'You have arrived at $destinationShopName',
          floorId: nodes.last.floorId,
          relatedNodeId: nodes.last.id,
          distanceRemaining: 0.0,
          isCompleted: false,
          startNodeIndex: nodes.length - 1,
          endNodeIndex: nodes.length - 1,
        ),
      );
    }

    return instructions;
  }

  static List<NavigationInstructionEntity> updateInstructionProgress({
    required List<NavigationInstructionEntity> instructions,
    required int nearestRouteIndex,
    int? currentRouteNodeIndex,
    required IndoorPositionEntity position,
    required NavigationRouteEntity route,
    double junctionThreshold = 12.0,
  }) {
    final progressIndex = currentRouteNodeIndex ?? nearestRouteIndex;

    bool previousAllCompleted = true;
    bool justCompletedInThisPass = false;
    final List<NavigationInstructionEntity> updated = [];

    for (int idx = 0; idx < instructions.length; idx++) {
      final inst = instructions[idx];
      bool isCompleted = inst.isCompleted;

      // Strict sequential rule & anti-tunneling safeguard:
      // Instruction idx can ONLY complete if all preceding instructions (0..idx-1) were already completed in a prior pass.
      if (previousAllCompleted && !isCompleted && !justCompletedInThisPass) {
        if (inst.type == 'straight' ||
            inst.type == 'lift' ||
            inst.type == 'escalator' ||
            inst.type == 'stairs') {
          if (progressIndex >= inst.endNodeIndex) {
            isCompleted = true;
            justCompletedInThisPass = true;
          } else if (progressIndex >= inst.startNodeIndex &&
              inst.endNodeIndex < route.completeRoute.length) {
            // Calculate total segment length to compute dynamic effective threshold for short corridors
            double segLength = 0.0;
            for (int i = inst.startNodeIndex; i < inst.endNodeIndex; i++) {
              final n1 = route.completeRoute[i];
              final n2 = route.completeRoute[i + 1];
              final dx = n2.x - n1.x;
              final dy = n2.y - n1.y;
              segLength += sqrt(dx * dx + dy * dy);
            }
            final effectiveThreshold = min(
              junctionThreshold,
              segLength > 0.0 ? segLength * 0.4 : junctionThreshold,
            );

            final junctionNode = route.completeRoute[inst.endNodeIndex];
            final dx = position.x - junctionNode.x;
            final dy = position.y - junctionNode.y;
            final distToJunction = sqrt(dx * dx + dy * dy);

            if (distToJunction <= effectiveThreshold) {
              isCompleted = true;
              justCompletedInThisPass = true;
            }
          }
        } else if (inst.type == 'arrival') {
          isCompleted = false;
        } else {
          // Turn instructions: completed ONLY when progressIndex > endNodeIndex or Blue Dot physically steps past turn node onto next edge (t > 0.1)
          if (progressIndex > inst.endNodeIndex) {
            isCompleted = true;
            justCompletedInThisPass = true;
          } else if (progressIndex == inst.endNodeIndex &&
              inst.endNodeIndex < route.completeRoute.length - 1) {
            final turnNode = route.completeRoute[inst.endNodeIndex];
            final nextNode = route.completeRoute[inst.endNodeIndex + 1];
            final abx = nextNode.x - turnNode.x;
            final aby = nextNode.y - turnNode.y;
            final lenSq = abx * abx + aby * aby;
            if (lenSq > 0.0) {
              final apx = position.x - turnNode.x;
              final apy = position.y - turnNode.y;
              final t = ((apx * abx + apy * aby) / lenSq).clamp(0.0, 1.0);
              if (t > 0.1) {
                isCompleted = true;
                justCompletedInThisPass = true;
              }
            }
          }
        }
      }

      if (!isCompleted) {
        previousAllCompleted = false;
      }

      double dist = 0.0;
      if (!isCompleted) {
        if (progressIndex >= inst.startNodeIndex &&
            progressIndex <= inst.endNodeIndex) {
          dist = NavigationProgressService.calculatePathRemainingDistance(
            path: route.completeRoute,
            px: position.x,
            py: position.y,
            startIndex: progressIndex,
            endIndex: inst.endNodeIndex,
          );
        } else {
          for (int i = inst.startNodeIndex; i < inst.endNodeIndex; i++) {
            final n1 = route.completeRoute[i];
            final n2 = route.completeRoute[i + 1];
            final dx = n2.x - n1.x;
            final dy = n2.y - n1.y;
            dist += sqrt(dx * dx + dy * dy);
          }
        }
      }

      updated.add(
        inst.copyWith(isCompleted: isCompleted, distanceRemaining: dist),
      );
    }

    return updated;
  }
}
