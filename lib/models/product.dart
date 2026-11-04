/// Model class representing a Product.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String emoji;
  final double rating;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.emoji,
    required this.rating,
    required this.inStock,
  });
}

