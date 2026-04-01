import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_scan/core/constants/customer_type.dart';

class CustomerNotifier extends Notifier<CustomerType> {
  @override
  CustomerType build() => CustomerType.retail;

  void setCustomerType(CustomerType type) => state = type;
}

final customerProvider = NotifierProvider<CustomerNotifier, CustomerType>(
  CustomerNotifier.new,
);