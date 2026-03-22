/// Yon tranzaksyon (depo oswa retrait) pou istwa bous.
class PaymentTransaction {
  final String id;
  final String type; // 'deposit' | 'withdraw'
  final double amount;
  final DateTime date;
  final String status; // 'completed' | 'pending'

  const PaymentTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.status = 'completed',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'date': date.toIso8601String(),
        'status': status,
      };

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    final date = json['date'];
    return PaymentTransaction(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'deposit',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: date is String ? DateTime.tryParse(date) ?? DateTime.now() : DateTime.now(),
      status: json['status'] as String? ?? 'completed',
    );
  }
}
