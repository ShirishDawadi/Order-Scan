import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_scan/core/constants/customer_type.dart';
import 'package:order_scan/core/utils/price_calculator.dart';
import 'package:order_scan/data/models/product.dart';
import 'package:order_scan/presentation/viewmodels/customer_viewmodel.dart';
import 'package:order_scan/presentation/viewmodels/order_viewmodel.dart';

class OrderScreen extends ConsumerStatefulWidget {
  final Product product;

  const OrderScreen({super.key, required this.product});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;

    ref.read(orderProvider.notifier).placeOrder(widget.product, quantity);
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final customerType = ref.watch(customerProvider);

    final quantity = int.tryParse(_quantityController.text) ?? 0;

    final total = ref
        .watch(orderProvider.notifier)
        .calculateTotal(widget.product, quantity);

    final price = PriceCalculator.getPrice(widget.product, customerType);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Placement'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Price: \$${price.toStringAsFixed(2)}'),
                      const SizedBox(height: 4),
                      Text('MOQ: ${widget.product.moq}'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: customerType == CustomerType.dealer
                              ? Colors.green.shade100
                              : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          customerType == CustomerType.dealer
                              ? 'Dealer Price (15% off)'
                              : 'Retail Price',
                          style: TextStyle(
                            fontSize: 12,
                            color: customerType == CustomerType.dealer
                                ? Colors.green.shade800
                                : Colors.blue.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Enter Quantity',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),

            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                errorText: orderState.error,
              ),
              onChanged: (_) {
                ref.read(orderProvider.notifier).clearStatus();
              },
            ),

            const SizedBox(height: 16),

            if (quantity > 0)
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: orderState.isPlaced ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            if (orderState.isPlaced)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Order placed successfully',
                  style: TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
