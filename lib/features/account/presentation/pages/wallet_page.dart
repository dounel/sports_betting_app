import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/core/services/auth_service.dart';
import 'package:sports_betting_app/shared/models/payment_transaction.dart';
import 'package:sports_betting_app/features/account/presentation/pages/deposit_page.dart';
import 'package:sports_betting_app/features/account/presentation/pages/withdraw_page.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double _balance = 0;
  List<PaymentTransaction> _history = [];

  @override
  void initState() {
    super.initState();
    _loadBalance();
    _loadHistory();
  }

  Future<void> _loadBalance() async {
    final b = await AuthService.getBalance();
    if (!mounted) return;
    setState(() => _balance = b);
  }

  Future<void> _loadHistory() async {
    final list = await AuthService.getPaymentHistory();
    if (!mounted) return;
    setState(() => _history = list);
  }

  @override
  Widget build(BuildContext context) {
    final history = _history;

    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBg,
        elevation: 0,
        title: const Text(
          'Wallet',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppConstants.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppConstants.primaryGreen.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Balans disponib',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_balance.toStringAsFixed(0)} HTG',
                    style: const TextStyle(
                      color: AppConstants.primaryGreen,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push<double>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DepositPage(),
                              ),
                            );
                            if (result != null && result > 0) {
                              final newBalance = _balance + result;
                              await AuthService.setBalance(newBalance);
                              await AuthService.addTransaction(PaymentTransaction(
                                id: 'dep_${DateTime.now().millisecondsSinceEpoch}',
                                type: 'deposit',
                                amount: result,
                                date: DateTime.now(),
                              ));
                              if (!mounted) return;
                              setState(() => _balance = newBalance);
                              _loadHistory();
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Deposit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push<double>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WithdrawPage(balance: _balance),
                              ),
                            );
                            if (result != null && result > 0) {
                              final newBalance = _balance - result;
                              await AuthService.setBalance(newBalance);
                              await AuthService.addTransaction(PaymentTransaction(
                                id: 'wit_${DateTime.now().millisecondsSinceEpoch}',
                                type: 'withdraw',
                                amount: result,
                                date: DateTime.now(),
                              ));
                              if (!mounted) return;
                              setState(() => _balance = newBalance);
                              _loadHistory();
                            }
                          },
                          icon: const Icon(Icons.remove),
                          label: const Text('Withdraw'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstants.primaryGreen,
                            side: const BorderSide(color: AppConstants.primaryGreen),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Istwa peman',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (history.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Pa gen tranzaksyon toujou',
                  style: TextStyle(color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...history.map((t) => _TransactionTile(transaction: t)),
          ],
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
