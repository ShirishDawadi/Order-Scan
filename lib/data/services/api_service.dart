import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:order_scan/core/constants/api_constants.dart';
import 'package:order_scan/data/models/product.dart';

class ApiService {
  final String _baseUrl = ApiConstants.baseUrl;
  final String _productUrl = ApiConstants.products;

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl$_productUrl'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    }
    throw Exception('Failed to load products');
  }
}