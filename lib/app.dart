import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/core/services/auth_service.dart';
import 'package:sports_betting_app/core/widgets/app_header.dart';
import 'package:sports_betting_app/features/home/presentation/pages/home_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/sport_page.dart';
import 'package:sports_betting_app/features/pari/presentation/pages/bets_page.dart';
import 'package:sports_betting_app/features/bet/presentation/pages/bet_page.dart';
import 'package:sports_betting_app/features/account/presentation/pages/account_page.dart';
import 'package:sports_betting_app/features/account/presentation/pages/deposit_page.dart';
import 'package:sports_betting_app/features/account/presentation/pages/withdraw_page.dart';
import 'package:sports_betting_app/features/auth/presentation/pages/login_page.dart';
import 'package:sports_betting_app/features/auth/presentation/pages/register_page.dart';
import 'package:sports_betting_app/shared/models/payment_transaction.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;
  double _balance = 0;

  List<Widget> get _pages => [
    HomePage(onBetPlaced: _loadAuthState),
    const SportPage(),
    BetsPage(currentTabIndex: _currentIndex),
    BetPage(onBetPlaced: _loadAuthState),
    AccountPage(onLogout: _loadAuthState),
  ];

  Future<void> _loadAuthState() async {
    final email = await AuthService.getCurrentUser();
    final loggedIn = email != null && email.isNotEmpty;
    final balance = await AuthService.getBalance();
    if (!mounted) return;
    setState(() {
      _isLoggedIn = loggedIn;
      _balance = balance;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAuthState();
  }

  Future<void> _onLoginTap() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    if (result == true) await _loadAuthState();
  }

  Future<void> _onRegisterTap() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
    if (result == true) await _loadAuthState();
  }

  Future<void> _onDepositTap() async {
    final result = await Navigator.push<double>(
      context,
      MaterialPageRoute(builder: (_) => const DepositPage()),
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
    }
  }

  Future<void> _onWithdrawTap() async {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: double.infinity,
          child: AppHeader(
            isLoggedIn: _isLoggedIn,
            balance: _balance,
            onLoginTap: _onLoginTap,
            onRegisterTap: _onRegisterTap,
            onDepositTap: _onDepositTap,
            onWithdrawTap: _onWithdrawTap,
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppConstants.navBarColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home'),
                _buildNavItem(1, Icons.sports_soccer_rounded, 'Sport'),
                _buildNavItem(2, Icons.receipt_long_rounded, 'Pari'),
                _buildNavItem(3, Icons.live_tv_rounded, 'See Match'),
                _buildNavItem(4, Icons.person_rounded, 'Account'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryGreen.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? AppConstants.primaryGreen
                  : Colors.white54,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? AppConstants.primaryGreen
                    : Colors.white54,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
