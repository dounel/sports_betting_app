import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/core/services/auth_service.dart';
import 'package:sports_betting_app/shared/models/bet_ticket_model.dart';
import 'package:sports_betting_app/features/pari/presentation/widgets/bets_ticket_card.dart';

class BetsPage extends StatefulWidget {
  final int currentTabIndex;

  const BetsPage({super.key, required this.currentTabIndex});

  static const int betsTabIndex = 2;

  @override
  State<BetsPage> createState() => _BetsPageState();
}

class _BetsPageState extends State<BetsPage>
    with SingleTickerProviderStateMixin {
  List<BetTicketModel> _tickets = [];
  bool _loading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTickets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BetsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTabIndex == BetsPage.betsTabIndex &&
        oldWidget.currentTabIndex != BetsPage.betsTabIndex) {
      _loadTickets();
    }
  }

  Future<void> _loadTickets() async {
    setState(() => _loading = true);
    final list = await AuthService.getBetTickets();
    if (!mounted) return;
    
    // Kalkile estati reyèl pou chak tikè ak mete ajou sa yo ki fini
    final updatedList = await _updateAndSaveFinishedTickets(list);
    
    setState(() {
      _tickets = updatedList;
      _loading = false;
    });
  }

  /// Kalkile estati reyèl tikè yo epi sere sa yo ki fini nan memwa
  Future<List<BetTicketModel>> _updateAndSaveFinishedTickets(List<BetTicketModel> tickets) async {
    final List<BetTicketModel> updatedTickets = [];
    bool hasChanges = false;

    for (final ticket in tickets) {
      // Kalkile rezilta ak skò simile oswa reyèl
      final calculatedTicket = ticket.withRealOrSimulatedResults();
      final calculatedStatus = calculatedTicket.calculateOverallStatus();
      
      // Si estati a chanje (pase soti nan pending), mete ajou tikè a
      if (ticket.status == BetTicketStatus.pending && calculatedStatus != BetTicketStatus.pending) {
        // Tikè fini - mete ajou estati a
        final updatedTicket = BetTicketModel(
          id: ticket.id,
          team1: ticket.team1,
          team2: ticket.team2,
          odds: ticket.odds,
          betAmount: ticket.betAmount,
          possibleWin: ticket.possibleWin,
          status: calculatedStatus,
          selections: calculatedTicket.selections,
          createdAt: ticket.createdAt,
        );
        updatedTickets.add(updatedTicket);
        hasChanges = true;
      } else {
        // Tikè pa chanje, kenbe li jan li ye a
        updatedTickets.add(ticket);
      }
    }

    // Si gen chanjman, sere tout tikè yo nan memwa
    if (hasChanges) {
      await _saveAllTickets(updatedTickets);
    }

    return updatedTickets;
  }

  /// Sere tout tikè yo nan memwa
  Future<void> _saveAllTickets(List<BetTicketModel> tickets) async {
    final email = await AuthService.getCurrentUser();
    if (email == null || email.isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    final key = 'li_facil_bet_tickets_$email';
    final jsonList = tickets.map((t) => t.toJson()).toList();
    await prefs.setString(key, jsonEncode(jsonList));
  }

  List<BetTicketModel> get _activeTickets =>
      _tickets.where((t) => t.status == BetTicketStatus.pending).toList();

  List<BetTicketModel> get _finishedTickets => _tickets
      .where((t) =>
          t.status == BetTicketStatus.won || t.status == BetTicketStatus.lost)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      body: Column(
        children: [
          Container(
            color: AppConstants.darkBg,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppConstants.primaryGreen,
              indicatorWeight: 3,
              labelColor: AppConstants.primaryGreen,
              unselectedLabelColor: Colors.white54,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Ankou'),
                Tab(text: 'Pase'),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.primaryGreen,
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _TabContent(
                        tickets: _activeTickets,
                        emptyMessage:
                            'Pa gen pari ankou. Fè yon pari nan ekran Bet.',
                        onRefresh: _loadTickets,
                        isActive: true,
                      ),
                      _TabContent(
                        tickets: _finishedTickets,
                        emptyMessage:
                            'Pa gen pari ki fini toujou.',
                        onRefresh: _loadTickets,
                        isActive: false,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

}

class _TabContent extends StatelessWidget {
  final List<BetTicketModel> tickets;
  final String emptyMessage;
  final VoidCallback onRefresh;
  final bool isActive;

  const _TabContent({
    required this.tickets,
    required this.emptyMessage,
    required this.onRefresh,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => onRefresh(),
        color: AppConstants.primaryGreen,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  emptyMessage,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: AppConstants.primaryGreen,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tickets.length,
        itemBuilder: (_, index) {
          final ticket = tickets[index];
          return BetsTicketCard(
            ticket: ticket,
            isActive: isActive,
          );
        },
      ),
    );
  }
}
