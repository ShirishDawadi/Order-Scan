import 'package:order_scan/data/models/product.dart';

class Order {
  final Product product;
  final int quantity;
  final double totalPrice;

  Order({
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });
}