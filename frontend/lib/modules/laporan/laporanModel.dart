class Laporan {
  final int id;
  final DateTime createdAt;
  final String invoiceNumber;
  final String customerName;
  final String paymentMethod;
  final String paymentStatus;
  final String note;
  final double totalAmount;

  Laporan({
    required this.id,
    required this.createdAt,
    required this.invoiceNumber,
    required this.customerName,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.note,
    required this.totalAmount,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      invoiceNumber: json['invoice_number'],
      customerName: json['customer_name'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      note: json['note'],
      totalAmount: (json['total_amount'] as num).toDouble(),
    );
  }
}

class LaporanResult {
  final DateTime startWeek;
  final DateTime endWeek;
  final int totalTransaction;
  final double totalIncome;
  final List<Laporan> data;

  LaporanResult({
    required this.startWeek,
    required this.endWeek,
    required this.totalTransaction,
    required this.totalIncome,
    required this.data,
  });

  factory LaporanResult.fromJson(Map<String, dynamic> json) {
    return LaporanResult(
      startWeek: DateTime.parse(json['startWeek']),
      endWeek: DateTime.parse(json['endWeek']),
      totalTransaction: json['totalTransaction'],
      totalIncome: (json['totalIncome'] as num).toDouble(),
      data: (json['data'] as List).map((e) => Laporan.fromJson(e)).toList(),
    );
  }
}
