import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';

class WalletTopBar extends StatelessWidget {
  final double balance;
  final VoidCallback? onDeposit;
  final VoidCallback? onWithdraw;

  const WalletTopBar({
    super.key,
    this.balance = AppConstants.defaultBalance,
    this.onDeposit,
    this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${balance.toStringAsFixed(0)} HTG',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryGreen,
            ),
          ),
          Material(
            color: AppConstants.primaryGreen,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppConstants.cardBg,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (ctx) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.add_circle_outline,
                              color: AppConstants.primaryGreen,
                            ),
                            title: const Text(
                              'Deposit',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              onDeposit?.call();
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.remove_circle_outline,
                              color: AppConstants.primaryGreen,
                            ),
                            title: const Text(
                              'Withdraw',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              onWithdraw?.call();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
