import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/core/services/auth_service.dart';
import 'package:sports_betting_app/shared/models/payment_transaction.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  List<PaymentTransaction> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    final list = await AuthService.getPaymentHistory();
    if (!mounted) return;
    setState(() {
      _history = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBg,
        elevation: 0,
        title: const Text(
          'Istwa peman',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loading ? null : _loadHistory,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppConstants.primaryGreen),
            )
          : _history.isEmpty
              ? const Center(
                  child: Text(
                    'Pa gen tranzaksyon',
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadHistory,
                  color: AppConstants.primaryGreen,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _history.length,
                    itemBuilder: (_, i) {
                      final t = _history[i];
                      return _TransactionTile(transaction: t);
                    },
                  ),
                ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final PaymentTransaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.type == 'deposit';
    final dateStr =
        '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isDeposit
                ? AppConstants.primaryGreen.withOpacity(0.2)
                : Colors.orange.withOpacity(0.2),
            child: Icon(
              isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
              color: isDeposit ? AppConstants.primaryGreen : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDeposit ? 'Depo' : 'Retrait',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  dateStr,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${isDeposit ? '+' : '-'}${transaction.amount.toStringAsFixed(0)} HTG',
            style: TextStyle(
              color: isDeposit ? AppConstants.primaryGreen : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
