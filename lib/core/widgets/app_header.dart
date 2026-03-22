import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';

/// Header aplikasyon an.
/// Si itilizatè pa konekte: Li Facil | Login | Register.
/// Si itilizatè konekte: Li Facil | balans HTG + bouton "+".
class AppHeader extends StatelessWidget {
  final bool isLoggedIn;
  final double balance;
  final VoidCallback? onLoginTap;
  final VoidCallback? onRegisterTap;
  final VoidCallback? onDepositTap;
  final VoidCallback? onWithdrawTap;

  const AppHeader({
    super.key,
    required this.isLoggedIn,
    this.balance = 0,
    this.onLoginTap,
    this.onRegisterTap,
    this.onDepositTap,
    this.onWithdrawTap,
  });

  void _showWalletModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppConstants.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppConstants.primaryGreen,
                    child: Icon(Icons.add, color: Colors.white, size: 22),
                  ),
                  title: const Text(
                    'Deposit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: const Text(
                    'Mete lajan nan bous ou',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onDepositTap?.call();
                  },
                ),
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.shade700,
                    child: const Icon(Icons.remove, color: Colors.white, size: 22),
                  ),
                  title: const Text(
                    'Withdraw',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: const Text(
                    'Retire lajan nan bous ou',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onWithdrawTap?.call();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppConstants.appName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isLoggedIn)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${balance.toStringAsFixed(0)} HTG',
                style: const TextStyle(
                  color: AppConstants.primaryGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppConstants.primaryGreen,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () => _showWalletModal(context),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: onLoginTap,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: AppConstants.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Text(
                '|',
                style: TextStyle(color: Colors.white54),
              ),
              TextButton(
                onPressed: onRegisterTap,
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: AppConstants.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
