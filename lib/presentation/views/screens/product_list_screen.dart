import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_scan/core/constants/customer_type.dart';
import 'package:order_scan/presentation/viewmodels/customer_viewmodel.dart';
import 'package:order_scan/presentation/viewmodels/product_viewmodel.dart';
import 'package:order_scan/core/utils/price_calculator.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);
    final customerType = ref.watch(customerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OrderScan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Row(
            children: [
              const Text(
                'Customer: ',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              DropdownButton<CustomerType>(
                value: customerType,
                dropdownColor: Colors.blue,
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(
                    value: CustomerType.retail,
                    child: Text('Retail'),
                  ),
                  DropdownMenuItem(
                    value: CustomerType.dealer,
                    child: Text('Dealer'),
                  ),
                ],
                onChanged: (type) {
                  if (type != null) {
                    ref
                        .read(customerProvider.notifier)
                        .setCustomerType(type);
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('Error: $e'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.refresh(productProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (products) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final price = PriceCalculator.getPrice(product, customerType);

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Price: \$${price.toStringAsFixed(2)}'),
                          Text('MOQ: ${product.moq}'),
                          if (customerType == CustomerType.dealer)
                            const Text(
                              '15% dealer discount applied',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Order'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan'),
      ),
    );
  }
}