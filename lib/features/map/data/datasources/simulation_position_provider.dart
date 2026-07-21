import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/position_entities.dart';
import '../../domain/services/position_provider.dart';

class SimulationPositionProvider implements IndoorPositionProvider {
  final _controller = StreamController<IndoorPositionEntity>.broadcast();
  List<Map<String, double>> _path = [];
  List<IndoorPositionEntity> _positionPath = [];
  String _floorId = '';
  int _currentIndex = 0;
  Timer? _timer;
  bool _isRunning = false;

  SimulationPositionProvider() {
    print('PROVIDER CREATED ${identityHashCode(this)}');
  }

  IndoorPositionEntity _lastKnownPosition = IndoorPositionEntity(
    id: 'sim_initial_pos',
    floorId: 'ground_floor',
    x: 1000.0,
    y: 440.0,
    accuracy: 1.0,
    timestamp: DateTime.now(),
    source: PositionSource.simulation,
  );

  @override
  Stream<IndoorPositionEntity> get positionStream => _controller.stream;

  @override
  void loadPath(List<Map<String, double>> path, {required String floorId}) {
    final wasRunning = _isRunning;
    stop();
    _path = List.from(path);
    _positionPath = [];
    _floorId = floorId;
    _currentIndex = 0;
    if (wasRunning) {
      start();
    }
  }

  @override
  void loadPositionPath(List<IndoorPositionEntity> positions) {
    final wasRunning = _isRunning;
    stop();
    _path = [];
    _positionPath = List.from(positions);
    _floorId = '';
    _currentIndex = 0;
    if (wasRunning) {
      start();
    }
  }

  @override
  void start() {
    if (_isRunning) return;
    _isRunning = true;

    // Emit initial position immediately
    _emitPosition();

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      _emitPosition();
    });
  }

  void _emitPosition() {
    if (_positionPath.isNotEmpty) {
      if (_currentIndex < _positionPath.length) {
        final position = _positionPath[_currentIndex];
        _lastKnownPosition = position;
        debugPrint(
          'EMIT POSITION ${position.floorId} (${position.x}, ${position.y})',
        );
        _controller.add(position);
        _currentIndex++;
      } else {
        _positionPath = [];
        _currentIndex = 0;
        debugPrint(
          'EMIT POSITION ${_lastKnownPosition.floorId} (${_lastKnownPosition.x}, ${_lastKnownPosition.y})',
        );
        _controller.add(_lastKnownPosition);
      }
    } else if (_path.isNotEmpty) {
      if (_currentIndex < _path.length) {
        final node = _path[_currentIndex];
        final x = node['x'] ?? 0.0;
        final y = node['y'] ?? 0.0;

        final position = IndoorPositionEntity(
          id: 'sim_pos_${_floorId}_$_currentIndex',
          floorId: _floorId,
          x: x,
          y: y,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );

        _lastKnownPosition = position;
        _controller.add(position);
        _currentIndex++;
      } else {
        _path = [];
        _currentIndex = 0;
        _controller.add(_lastKnownPosition);
      }
    } else {
      _controller.add(_lastKnownPosition);
    }
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }

  @override
  void reset() {
    stop();
    _currentIndex = 0;
    _lastKnownPosition = IndoorPositionEntity(
      id: 'sim_initial_pos',
      floorId: 'ground_floor',
      x: 1000.0,
      y: 440.0,
      accuracy: 1.0,
      timestamp: DateTime.now(),
      source: PositionSource.simulation,
    );
    if (_path.isEmpty && _positionPath.isEmpty) {
      _emitPosition();
    }
  }

  @override
  void dispose() {
    stop();
    _controller.close();
  }
}
