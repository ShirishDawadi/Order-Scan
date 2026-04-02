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
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Info',
                         style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                         )
                         ),
                      const SizedBox(height: 10,),

                      Text('Name: ${scannerState.productName}'),
                      const SizedBox(height: 8,),
                      Text('Scanned Barcode: ${scannerState.barcode}'),
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          Text('Status:'),
                          SizedBox(width: 8,),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: scannerState.status == 'Valid'
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              scannerState.status,
                              style: TextStyle(
                                color: scannerState.status == 'Valid'
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () => scannerVM.clear(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Clear'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
