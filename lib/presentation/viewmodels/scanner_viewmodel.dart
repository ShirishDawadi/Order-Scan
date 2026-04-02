import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'scanner_state.dart';

class ScannerViewModel extends Notifier<ScannerState> {
  @override
  ScannerState build() => ScannerState();

  String getProductName(String barcode) {
    final mapping = {
      '6281006409569': 'Dove Body Love',
      '086702767342': 'Steve Madden Watch',
    };
    return mapping[barcode] ?? 'Unknown Product';
  }

  void updateBarcode(String barcodeScanResult) {
    final productName = getProductName(barcodeScanResult);

    String status;
    final lastDigit = int.tryParse(barcodeScanResult[barcodeScanResult.length - 1]);
    if (lastDigit != null) {
      status = lastDigit % 2 == 0 ? 'Valid' : 'Invalid';
    } else {
      status = 'Invalid';
    }

    state = state.copyWith(
      barcode: barcodeScanResult,
      productName: productName,
      status: status,
    );
  }

  void clear() {
    state = ScannerState();
  }
}

final scannerProvider =
    NotifierProvider<ScannerViewModel, ScannerState>(ScannerViewModel.new);