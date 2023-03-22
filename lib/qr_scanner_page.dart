import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'database.dart';
import 'home_page.dart';

class QRScannerPage extends StatefulWidget {
  final bool isInbound;

  QRScannerPage({required this.isInbound});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  QRViewController? _controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Timer? _timer;
  bool _isQRCodeDetected = false;

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!_isQRCodeDetected && scanData.code != null) {
        _isQRCodeDetected = true;
        _controller?.pauseCamera();
        processQRCode(scanData.code!, widget.isInbound);
      }
    });
  }

  Future<void> processQRCode(String code, bool isInbound) async {
    if (isInbound) {
      // Add or update item in the database
      await addOrUpdateItem(code);
    } else {
      // Set item as "출하" in the database
      await setItemAsOutbound(code);
    }

    setState(() {
      _timer = Timer(const Duration(seconds: 1), () {
        _isQRCodeDetected = false;
        _controller?.resumeCamera();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isQRCodeDetected ? Colors.green : Colors.white,
                  width: 5.0,
                ),
              ),
              child: _isQRCodeDetected
                  ? const SpinKitRing(
                color: Colors.green,
                lineWidth: 4,
                size: 100,
              )
                  : null,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller?.toggleFlash();
        },
        child: const Icon(Icons.flash_on),
      ),
    );
  }
}
