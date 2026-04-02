import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:order_scan/presentation/viewmodels/scanner_viewmodel.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(scannerProvider);
    final scannerVM = ref.read(scannerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: MobileScanner(
                controller: cameraController,
                onDetect: (capture) {
                  final barcode = capture.barcodes.first.rawValue ?? '';
                  if (barcode.isNotEmpty) {
                    scannerVM.updateBarcode(barcode);
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            if (scannerState.barcode.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Scanned Barcode: ${scannerState.barcode}'),
                  Text('Product Name: ${scannerState.productName}'),
                  Text('Status: ${scannerState.status}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => scannerVM.clear(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Clear'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
