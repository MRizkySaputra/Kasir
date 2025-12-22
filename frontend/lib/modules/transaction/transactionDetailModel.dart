class TransactionDetail {
  final int id;
  final int qty;
  final int price;
  final int subtotal;
  final int productId;

  TransactionDetail({
    required this.id,
    required this.qty,
    required this.price,
    required this.subtotal,
    required this.productId,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      id: json['id'],
      qty: json['qty'],
      price: json['price'],
      subtotal: json['subtotal'],
      productId: json['product_id'],
    );
  }
}
