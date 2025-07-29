class Product {
  final String id;
  final String code;
  final String name;
  final String description;
  final bool isBatchProduct;

  Product({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.isBatchProduct,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      description: map['description'] ?? '',
      isBatchProduct: map['is_batch_product'] ?? false,
    );
  }
}