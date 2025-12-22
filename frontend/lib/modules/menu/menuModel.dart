class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final int stok;
  final String status;
  final String unit;
  final String? image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stok,
    required this.status,
    required this.unit,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name_product'],
      description: json['description'],
      price: json['price'],
      stok: json['stok'],
      status: json['status'],
      unit: json['unit'],
      image: json['image'],
    );
  }
}
