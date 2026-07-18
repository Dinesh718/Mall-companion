import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/map_models.dart';

abstract class LocalMapDataSource {
  Future<MapModel> getMapData();
}

class LocalMapDataSourceImpl implements LocalMapDataSource {
  final AssetBundle assetBundle;

  LocalMapDataSourceImpl({required this.assetBundle});

  @override
  Future<MapModel> getMapData() async {
    final jsonString = await assetBundle.loadString(
      'assets/data/maps/ground_floor.json',
    );
    final Map<String, dynamic> decodedJson =
        json.decode(jsonString) as Map<String, dynamic>;
    final floor = FloorModel.fromJson(decodedJson);

    final firstFloorJsonString = await assetBundle.loadString(
      'assets/data/maps/first_floor.json',
    );
    final Map<String, dynamic> firstFloorDecodedJson =
        json.decode(firstFloorJsonString) as Map<String, dynamic>;
    final firstFloor = FloorModel.fromJson(firstFloorDecodedJson);

    return MapModel(id: 'mall_phoenix', floors: [floor, firstFloor]);
  }
}
