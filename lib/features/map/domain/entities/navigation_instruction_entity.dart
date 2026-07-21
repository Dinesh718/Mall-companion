import 'package:equatable/equatable.dart';

class NavigationInstructionEntity extends Equatable {
  final String instructionId;
  final String type; // straight, slightLeft, left, sharpLeft, slightRight, right, sharpRight, lift, stairs, escalator, arrival
  final String text;
  final String floorId;
  final String relatedNodeId;
  final double distanceRemaining;
  final bool isCompleted;
  
  // Meta fields to map instruction progress to route nodes
  final int startNodeIndex;
  final int endNodeIndex;

  const NavigationInstructionEntity({
    required this.instructionId,
    required this.type,
    required this.text,
    required this.floorId,
    required this.relatedNodeId,
    required this.distanceRemaining,
    required this.isCompleted,
    required this.startNodeIndex,
    required this.endNodeIndex,
  });

  NavigationInstructionEntity copyWith({
    String? instructionId,
    String? type,
    String? text,
    String? floorId,
    String? relatedNodeId,
    double? distanceRemaining,
    bool? isCompleted,
    int? startNodeIndex,
    int? endNodeIndex,
  }) {
    return NavigationInstructionEntity(
      instructionId: instructionId ?? this.instructionId,
      type: type ?? this.type,
      text: text ?? this.text,
      floorId: floorId ?? this.floorId,
      relatedNodeId: relatedNodeId ?? this.relatedNodeId,
      distanceRemaining: distanceRemaining ?? this.distanceRemaining,
      isCompleted: isCompleted ?? this.isCompleted,
      startNodeIndex: startNodeIndex ?? this.startNodeIndex,
      endNodeIndex: endNodeIndex ?? this.endNodeIndex,
    );
  }

  @override
  List<Object?> get props => [
        instructionId,
        type,
        text,
        floorId,
        relatedNodeId,
        distanceRemaining,
        isCompleted,
        startNodeIndex,
        endNodeIndex,
      ];
}
