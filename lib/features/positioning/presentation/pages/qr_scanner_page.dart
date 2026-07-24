import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Presentation page that handles QR barcode scanning with active camera feed and flash toggling.
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  late final MobileScannerController _controller;
  bool _isFlashOn = false;
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Detect testing or headless execution modes
    final isTestOrSim =
        kIsWeb || Platform.environment.containsKey('FLUTTER_TEST');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera preview or simulator panel fallback
          if (isTestOrSim)
            _buildSimulatorPreview()
          else
            MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                if (_isPopped) return;
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? codeValue = barcodes.first.rawValue;
                  if (codeValue != null && codeValue.isNotEmpty) {
                    _isPopped = true;
                    Navigator.pop(context, codeValue);
                  }
                }
              },
            ),

          // 2. Scan overlay framing elements
          if (!isTestOrSim) IgnorePointer(child: _buildScannerOverlay()),

          // 3. Camera exit control
          Positioned(
            top: 40.0,
            left: 20.0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28.0),
              onPressed: () {
                if (!_isPopped) {
                  _isPopped = true;
                  Navigator.pop(context);
                }
              },
            ),
          ),

          // 4. Torch/Flash control
          if (!isTestOrSim)
            Positioned(
              top: 40.0,
              right: 20.0,
              child: IconButton(
                icon: Icon(
                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 28.0,
                ),
                onPressed: () {
                  _controller.toggleTorch();
                  setState(() {
                    _isFlashOn = !_isFlashOn;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSimulatorPreview() {
    final textController = TextEditingController();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              size: 80.0,
              color: Color(0xFF6100D6),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Camera Scanner Simulator',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Enter QR code ID below to mock scan result (e.g., QR_001, QR_002, QR_003):',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'QR_001',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFF1D1B20),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6100D6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6100D6), width: 2.0),
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Plus Jakarta Sans',
              ),
              onSubmitted: (val) {
                final code = val.trim().isEmpty ? 'QR_001' : val.trim();
                Navigator.pop(context, code);
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6100D6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
              ),
              onPressed: () {
                final code = textController.text.trim().isEmpty
                    ? 'QR_001'
                    : textController.text.trim();
                Navigator.pop(context, code);
              },
              child: const Text('Simulate Scan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            height: 250.0,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF6100D6), width: 3.0),
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Align QR Code within the frame',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.0,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
