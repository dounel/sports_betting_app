import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/core/services/auth_service.dart';
import 'package:sports_betting_app/shared/models/bet_ticket_model.dart';
import 'package:sports_betting_app/features/pari/presentation/widgets/bet_ticket_card.dart';

class PariPage extends StatefulWidget {
  final int currentTabIndex;

  const PariPage({super.key, required this.currentTabIndex});

  static const int pariTabIndex = 2;

  @override
  State<PariPage> createState() => _PariPageState();
}

class _PariPageState extends State<PariPage> {
  List<BetTicketModel> _tickets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  @override
  void didUpdateWidget(covariant PariPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTabIndex == PariPage.pariTabIndex &&
        oldWidget.currentTabIndex != PariPage.pariTabIndex) {
      _loadTickets();
    }
  }

  Future<void> _loadTickets() async {
    setState(() => _loading = true);
    final list = await AuthService.getBetTickets();
    if (!mounted) return;
    setState(() {
      _tickets = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppConstants.primaryGreen),
            )
          : _tickets.isEmpty
              ? const Center(
                  child: Text(
                    'Pa gen tikè pari toujou. Fè yon pari nan ekran Bet.',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTickets,
                  color: AppConstants.primaryGreen,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _tickets.length,
                    itemBuilder: (_, index) {
                      return BetTicketCard(ticket: _tickets[index]);
                    },
                  ),
                ),
    );
  }
}
