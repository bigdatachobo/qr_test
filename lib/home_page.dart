import 'package:flutter/material.dart';
import 'qr_scanner_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code App'),
      ),
      body: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerPage(isInbound: true),
                  ),
                );
              },
              child: Container(
                color: Colors.blue,
                child: Center(child: Text('입고', style: TextStyle(fontSize: 24))),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerPage(isInbound: false),
                  ),
                );
              },
              child: Container(
                color: Colors.green,
                child: Center(child: Text('출하', style: TextStyle(fontSize: 24))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
