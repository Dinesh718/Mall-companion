import 'dart:convert';
import 'package:flutter/services.dart';

/// Contract definition for reading raw QR-to-position mapping databases.
abstract class QrLocalDataSource {
  Future<Map<String, dynamic>?> getQrMapping(String qrId);
}

/// Implementation using the local Flutter AssetBundle.
class QrLocalDataSourceImpl implements QrLocalDataSource {
  final AssetBundle assetBundle;

  QrLocalDataSourceImpl({required this.assetBundle});

  @override
  Future<Map<String, dynamic>?> getQrMapping(String qrId) async {
    try {
      final jsonString = await assetBundle.loadString(
        'assets/data/maps/qr_mappings.json',
      );
      final Map<String, dynamic> data =
          json.decode(jsonString) as Map<String, dynamic>;
      if (data.containsKey(qrId)) {
        return data[qrId] as Map<String, dynamic>;
      }
    } catch (_) {
      // Gracefully yield null on read exceptions
    }
    return null;
  }
}
