class Product {
  final int id;
  final String name;
  final double price;
  final int moq;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.moq,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'],
      price: (json['price'] as num).toDouble(),
      moq: (json['minimumOrderQuantity'] ?? 1),
    );
  }
}