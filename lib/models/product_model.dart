class Product {
  final int id;
  final String name;
  final String image;
  final double price;
  final String category;
  final int discount;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    required this.discount,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      discount: json['discount'] ?? 0,
      description: json['description'] ?? '',
    );
  }
}
