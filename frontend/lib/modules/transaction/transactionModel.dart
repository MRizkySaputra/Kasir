import 'package:kasir/modules/transaction/transactionDetailModel.dart';

class Transactionmodel {
  final int id;
  final String invoiceNumber;
  final String customerName;
  final int totalAmount;
  final String paymentStatus;
  final String paymentMethod;
  final String note;
  final DateTime createdAt;
  final List<TransactionDetail> items;

  Transactionmodel({
    required this.id,
    required this.invoiceNumber,
    required this.customerName,
    required this.totalAmount,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.note,
    required this.createdAt,
    required this.items,
  });

  factory Transactionmodel.fromJson(Map<String, dynamic> json) {
    return Transactionmodel(
      id: json['id'] ?? 0,
      invoiceNumber: json['invoice_number'] ?? '-',
      customerName: json['customer_name'] ?? '-',
      totalAmount: json['total_amount'] ?? 0,
      paymentStatus: json['payment_status'] ?? '-',
      paymentMethod: json['payment_method'] ?? '-',
      note: json['note'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      items: (json['items'] as List? ?? [])
          .map((e) => TransactionDetail.fromJson(e))
          .toList(),
    );
  }
}
