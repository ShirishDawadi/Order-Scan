import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_scan/core/utils/price_calculator.dart';
import 'package:order_scan/data/models/order.dart';
import 'package:order_scan/data/models/product.dart';
import 'package:order_scan/presentation/viewmodels/customer_viewmodel.dart';
import 'package:order_scan/presentation/viewmodels/order_state.dart';

class OrderNotifier extends Notifier<OrderState> {
  @override
  OrderState build() => OrderState();

  void placeOrder(Product product, int quantity) {
    if (quantity <= 0) {
      state = state.copyWith(error: "Invalid quantity", isPlaced: false);
      return;
    }

    if (quantity < product.moq) {
      state = state.copyWith(
        error: "Minimum order quantity is ${product.moq}",
        isPlaced: false,
      );
      return;
    }

    final customerType = ref.read(customerProvider);
    final price = PriceCalculator.getPrice(product, customerType);
    final total = price * quantity;

    final newOrder = Order(
      product: product,
      quantity: quantity,
      totalPrice: total,
    );

    state = state.copyWith(
      orders: [...state.orders, newOrder],
      error: null,
      isPlaced: true,
    );
  }

  void clearStatus() {
    state = state.copyWith(error: null, isPlaced: false);
  }

  double calculateTotal(Product product, int quantity) {
    final customerType = ref.read(customerProvider);
    final price = PriceCalculator.getPrice(product, customerType);
    return price * quantity;
  }
}

final orderProvider = NotifierProvider.autoDispose<OrderNotifier, OrderState>(
  OrderNotifier.new,
);
