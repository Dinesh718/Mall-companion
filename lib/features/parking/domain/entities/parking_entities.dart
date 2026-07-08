class ParkingAvailabilityEntity {
  final int availableSpaces;
  final int totalSpaces;
  final int occupancyPercentage;
  final int entryRate;
  final int exitRate;
  final String estimatedEntryTime;

  const ParkingAvailabilityEntity({
    required this.availableSpaces,
    required this.totalSpaces,
    required this.occupancyPercentage,
    required this.entryRate,
    required this.exitRate,
    required this.estimatedEntryTime,
  });
}

class ParkingZoneEntity {
  final String id;
  final String name;
  final String status; // 'Available', 'Limited', 'Full'
  final int occupancyPercentage;
  final int availableSpaces;
  final String parkingLevel;
  final bool hasEVCharging;
  final bool hasAccessibleParking;

  const ParkingZoneEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.occupancyPercentage,
    required this.availableSpaces,
    required this.parkingLevel,
    this.hasEVCharging = false,
    this.hasAccessibleParking = false,
  });
}

class SavedVehicleEntity {
  final String zone;
  final String row;
  final String slot;
  final String level;
  final String savedTime;
  final String mallName;
  final String floorText;

  const SavedVehicleEntity({
    required this.zone,
    required this.row,
    required this.slot,
    required this.level,
    required this.savedTime,
    required this.mallName,
    required this.floorText,
  });

  SavedVehicleEntity copyWith({
    String? zone,
    String? row,
    String? slot,
    String? level,
    String? savedTime,
    String? mallName,
    String? floorText,
  }) {
    return SavedVehicleEntity(
      zone: zone ?? this.zone,
      row: row ?? this.row,
      slot: slot ?? this.slot,
      level: level ?? this.level,
      savedTime: savedTime ?? this.savedTime,
      mallName: mallName ?? this.mallName,
      floorText: floorText ?? this.floorText,
    );
  }
}

class ParkingHistoryItemEntity {
  final String id;
  final String mallName;
  final String dateText;
  final String arrivalTime;
  final String departureTime;
  final String zone;
  final String slot;
  final String durationText;
  final String vehicleType;

  const ParkingHistoryItemEntity({
    required this.id,
    required this.mallName,
    required this.dateText,
    required this.arrivalTime,
    required this.departureTime,
    required this.zone,
    required this.slot,
    required this.durationText,
    required this.vehicleType,
  });
}
