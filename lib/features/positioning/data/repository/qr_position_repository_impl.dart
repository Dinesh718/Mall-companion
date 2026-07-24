import '../../../map/domain/entities/position_entities.dart';
import '../../../map/domain/repositories/map_repository.dart';
import '../../domain/repositories/qr_position_repository.dart';
import '../datasource/qr_local_datasource.dart';

/// Implementation of QrPositionRepository resolving QR codes through MapRepository nodes.
class QrPositionRepositoryImpl implements QrPositionRepository {
  final QrLocalDataSource localDataSource;
  final MapRepository mapRepository;

  QrPositionRepositoryImpl({
    required this.localDataSource,
    required this.mapRepository,
  });

  @override
  Future<IndoorPositionEntity?> getPositionByQrId(String qrId) async {
    final mapping = await localDataSource.getQrMapping(qrId);
    if (mapping == null) return null;

    final navigationNodeId = mapping['navigationNodeId'] as String?;
    if (navigationNodeId == null || navigationNodeId.isEmpty) return null;

    print('Resolved Navigation Node: $navigationNodeId');
    return mapRepository.resolveNavigationNode(navigationNodeId);
  }
}
