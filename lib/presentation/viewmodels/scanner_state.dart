class ScannerState {
  final String barcode;
  final String productName;
  final String status;

  ScannerState({
    this.barcode = '',
    this.productName = '',
    this.status = '',
  });

  ScannerState copyWith({
    String? barcode,
    String? productName,
    String? status,
  }) {
    return ScannerState(
      barcode: barcode ?? this.barcode,
      productName: productName ?? this.productName,
      status: status ?? this.status,
    );
  }
}