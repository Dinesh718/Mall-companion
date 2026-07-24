import '../../../map/domain/entities/position_entities.dart';

/// Contract definition for translating QR code identifiers to physical coordinate positions.
abstract class QrPositionRepository {
  Future<IndoorPositionEntity?> getPositionByQrId(String qrId);
}
