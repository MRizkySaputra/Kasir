class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageAsset;

  Product(this.id, this.name, this.price, this.category, this.imageAsset);
}

class OrderItem {
  final Product product;
  int quantity;
  String note;

  OrderItem({required this.product, this.quantity = 1, this.note = ''});

  double get total => product.price * quantity;
}