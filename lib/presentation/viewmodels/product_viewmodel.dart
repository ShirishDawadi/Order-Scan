import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product.dart';
import '../../data/services/api_service.dart';

final productProvider = FutureProvider<List<Product>>((ref) async {
  return await ApiService().fetchProducts();
});