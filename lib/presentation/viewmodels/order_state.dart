import 'package:order_scan/data/models/order.dart';

class OrderState {
  final List<Order> orders;
  final String? error;
  final bool isPlaced;

  OrderState({this.orders = const [], this.error, this.isPlaced = false});

  OrderState copyWith({List<Order>? orders, String? error, bool? isPlaced}) {
    return OrderState(
      orders: orders ?? this.orders,
      error: error,
      isPlaced: isPlaced ?? false,
    );
  }
}
