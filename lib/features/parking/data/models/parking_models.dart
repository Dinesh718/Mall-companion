import '../../domain/entities/parking_entities.dart';

class ParkingAvailabilityModel extends ParkingAvailabilityEntity {
  const ParkingAvailabilityModel({
    required super.availableSpaces,
    required super.totalSpaces,
    required super.occupancyPercentage,
    required super.entryRate,
    required super.exitRate,
    required super.estimatedEntryTime,
  });

  factory ParkingAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return ParkingAvailabilityModel(
      availableSpaces: json['availableSpaces'] as int,
      totalSpaces: json['totalSpaces'] as int,
      occupancyPercentage: json['occupancyPercentage'] as int,
      entryRate: json['entryRate'] as int,
      exitRate: json['exitRate'] as int,
      estimatedEntryTime: json['estimatedEntryTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableSpaces': availableSpaces,
      'totalSpaces': totalSpaces,
      'occupancyPercentage': occupancyPercentage,
      'entryRate': entryRate,
      'exitRate': exitRate,
      'estimatedEntryTime': estimatedEntryTime,
    };
  }
}

class ParkingZoneModel extends ParkingZoneEntity {
  const ParkingZoneModel({
    required super.id,
    required super.name,
    required super.status,
    required super.occupancyPercentage,
    required super.availableSpaces,
    required super.parkingLevel,
    super.hasEVCharging = false,
    super.hasAccessibleParking = false,
  });

  factory ParkingZoneModel.fromJson(Map<String, dynamic> json) {
    return ParkingZoneModel(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      occupancyPercentage: json['occupancyPercentage'] as int,
      availableSpaces: json['availableSpaces'] as int,
      parkingLevel: json['parkingLevel'] as String,
      hasEVCharging: json['hasEVCharging'] as bool? ?? false,
      hasAccessibleParking: json['hasAccessibleParking'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'occupancyPercentage': occupancyPercentage,
      'availableSpaces': availableSpaces,
      'parkingLevel': parkingLevel,
      'hasEVCharging': hasEVCharging,
      'hasAccessibleParking': hasAccessibleParking,
    };
  }
}

class SavedVehicleModel extends SavedVehicleEntity {
  const SavedVehicleModel({
    required super.zone,
    required super.row,
    required super.slot,
    required super.level,
    required super.savedTime,
    required super.mallName,
    required super.floorText,
  });

  factory SavedVehicleModel.fromEntity(SavedVehicleEntity entity) {
    return SavedVehicleModel(
      zone: entity.zone,
      row: entity.row,
      slot: entity.slot,
      level: entity.level,
      savedTime: entity.savedTime,
      mallName: entity.mallName,
      floorText: entity.floorText,
    );
  }

  factory SavedVehicleModel.fromJson(Map<String, dynamic> json) {
    return SavedVehicleModel(
      zone: json['zone'] as String,
      row: json['row'] as String,
      slot: json['slot'] as String,
      level: json['level'] as String,
      savedTime: json['savedTime'] as String,
      mallName: json['mallName'] as String,
      floorText: json['floorText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zone': zone,
      'row': row,
      'slot': slot,
      'level': level,
      'savedTime': savedTime,
      'mallName': mallName,
      'floorText': floorText,
    };
  }
}

class ParkingHistoryItemModel extends ParkingHistoryItemEntity {
  const ParkingHistoryItemModel({
    required super.id,
    required super.mallName,
    required super.dateText,
    required super.arrivalTime,
    required super.departureTime,
    required super.zone,
    required super.slot,
    required super.durationText,
    required super.vehicleType,
  });

  factory ParkingHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return ParkingHistoryItemModel(
      id: json['id'] as String,
      mallName: json['mallName'] as String,
      dateText: json['dateText'] as String,
      arrivalTime: json['arrivalTime'] as String,
      departureTime: json['departureTime'] as String,
      zone: json['zone'] as String,
      slot: json['slot'] as String,
      durationText: json['durationText'] as String,
      vehicleType: json['vehicleType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mallName': mallName,
      'dateText': dateText,
      'arrivalTime': arrivalTime,
      'departureTime': departureTime,
      'zone': zone,
      'slot': slot,
      'durationText': durationText,
      'vehicleType': vehicleType,
    };
  }
}
