import 'package:order_scan/core/constants/customer_type.dart';
import 'package:order_scan/data/models/product.dart';

class PriceCalculator {
  static double getPrice(Product product, CustomerType customerType) {
    return customerType == CustomerType.dealer
        ? product.price * 0.85
        : product.price;
  }
}