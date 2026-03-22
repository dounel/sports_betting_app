import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final _amountController = TextEditingController();
  double _amount = 0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBg,
        elevation: 0,
        title: const Text(
          'Deposit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Antre montan ou vle depoze',
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
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [10, 25, 50, 100, 200].map((preset) {
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
                onPressed: _amount > 0
                    ? () => Navigator.pop(context, _amount)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Konfime depo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
