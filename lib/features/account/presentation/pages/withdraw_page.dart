import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/core/services/auth_service.dart';

class WithdrawPage extends StatefulWidget {
  final double? balance;

  const WithdrawPage({super.key, this.balance});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final _amountController = TextEditingController();
  double _amount = 0;
  double _balance = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.balance != null) {
      _balance = widget.balance!;
      _loading = false;
    } else {
      AuthService.getBalance().then((b) {
        if (!mounted) return;
        setState(() {
          _balance = b;
          _loading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canWithdraw = _amount > 0 && _amount <= _balance;
    if (_loading) {
      return Scaffold(
        backgroundColor: AppConstants.darkBg,
        appBar: AppBar(
          backgroundColor: AppConstants.darkBg,
          title: const Text('Withdraw', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppConstants.primaryGreen),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBg,
        elevation: 0,
        title: const Text(
          'Withdraw',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Balans disponib',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    '${_balance.toStringAsFixed(0)} HTG',
                    style: const TextStyle(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Montan pou retire',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                prefixText: 'HTG ',
                prefixStyle: const TextStyle(
                  color: AppConstants.primaryGreen,
                  fontSize: 20,
                ),
                filled: true,
                fillColor: AppConstants.cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) {
                setState(() => _amount = double.tryParse(v.replaceAll(',', '.')) ?? 0);
              },
            ),
            if (_amount > _balance)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Balans ou pa sifi',
                  style: TextStyle(color: Colors.red.shade300, fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [10, 25, 50, 100].where((p) => p <= _balance).map((preset) {
                return ActionChip(
                  label: Text('$preset HTG'),
                  backgroundColor: AppConstants.cardBg,
                  side: BorderSide(color: AppConstants.primaryGreen.withOpacity(0.5)),
                  onPressed: () {
                    _amountController.text = preset.toString();
                    setState(() => _amount = preset.toDouble());
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: canWithdraw ? () => Navigator.pop(context, _amount) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Konfime retrait'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
