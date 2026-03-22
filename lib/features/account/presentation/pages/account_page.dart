import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/core/services/auth_service.dart';
import 'package:sports_betting_app/features/account/presentation/widgets/account_menu_tile.dart';
import 'package:sports_betting_app/features/account/presentation/pages/wallet_page.dart';
import 'package:sports_betting_app/features/account/presentation/pages/payment_history_page.dart';
import 'package:sports_betting_app/features/account/presentation/pages/profile_page.dart';
import 'package:sports_betting_app/features/account/presentation/pages/terms_and_conditions_page.dart';
import 'package:sports_betting_app/features/account/presentation/pages/contact_us_page.dart';

class AccountPage extends StatelessWidget {
  final VoidCallback? onLogout;

  const AccountPage({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            AccountMenuTile(
              icon: Icons.person_outline,
              title: 'Profil',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              ),
            ),
            const SizedBox(height: 12),
            AccountMenuTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Wallet',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletPage()),
              ),
            ),
            const SizedBox(height: 12),
            AccountMenuTile(
              icon: Icons.history,
              title: 'Istwa peman',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentHistoryPage()),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 20),
            AccountMenuTile(
              icon: Icons.description_outlined,
              title: 'Tèm ak Kondisyon',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TermsAndConditionsPage()),
              ),
            ),
            const SizedBox(height: 12),
            AccountMenuTile(
              icon: Icons.contact_support_outlined,
              title: 'Kontakte Nou',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactUsPage()),
              ),
            ),
            const SizedBox(height: 12),
            AccountMenuTile(
              icon: Icons.logout,
              title: 'Dekonekte',
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConstants.cardBg,
        title: const Text('Dekonekte', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Ou vle dekonekte?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Anile', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Dekonekte', style: TextStyle(color: AppConstants.primaryGreen)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await AuthService.logout();
      onLogout?.call();
    }
  }
}
