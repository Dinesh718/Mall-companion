import 'package:equatable/equatable.dart';

/// Domain entity representing a scanned QR code payload.
class QrScanResult extends Equatable {
  final String rawValue;

  const QrScanResult({required this.rawValue});

  @override
  List<Object?> get props => [rawValue];
}
