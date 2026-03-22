import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/core/services/bet_placement_service.dart';
import 'package:sports_betting_app/core/services/football_api_service.dart';
import 'package:sports_betting_app/data/dummy/dummy_data.dart';
import 'package:sports_betting_app/features/bet/presentation/widgets/bet_slip_panel.dart';
import 'package:sports_betting_app/features/home/presentation/pages/match_details_page.dart';
import 'package:sports_betting_app/features/home/presentation/widgets/live_matches_section.dart';
import 'package:sports_betting_app/features/home/presentation/widgets/todays_matches_section.dart';
import 'package:sports_betting_app/features/home/presentation/widgets/leagues_section.dart';
import 'package:sports_betting_app/shared/models/bet_slip_item.dart';
import 'package:sports_betting_app/shared/models/match_model.dart';
import 'package:sports_betting_app/shared/models/odd_model.dart';

enum _HomeMatchFilter {
  all,
  live,
}

class HomePage extends StatefulWidget {
  final VoidCallback? onBetPlaced;

  const HomePage({super.key, this.onBetPlaced});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomeMatchFilter _selectedFilter = _HomeMatchFilter.all;
  final List<BetSlipItem> _betSlipItems = [];
  final ValueNotifier<int> _betSlipVersion = ValueNotifier(0);
  final TextEditingController _stakeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  double _stake = 0;

  // Done API pou match yo
  List<MatchModel> _allMatches = [];
  List<MatchModel> _liveMatches = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  /// Chaje match yo nan API a ak limit pou evite pwoblèm pèfòmans
  Future<void> _loadMatches() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Chaje match tout (maksimòm 50) e match an dirèk (maksimòm 50)
      final results = await Future.wait([
        FootballApiService.fetchFixtures(limit: 50),
        FootballApiService.fetchLiveFixtures(limit: 50),
      ]);

      if (!mounted) return;

      setState(() {
        _allMatches = results[0];
        _liveMatches = results[1];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Erè lè chaje match yo';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _betSlipVersion.dispose();
    _stakeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  static bool _matchPassesSearch(MatchModel m, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final t1 = m.team1.toLowerCase();
    final t2 = m.team2.toLowerCase();
    final lg = m.league.toLowerCase();
    return t1.contains(q) || t2.contains(q) || lg.contains(q);
  }

  List<MatchModel> get _allMatchesForHome => _allMatches;

  List<MatchModel> get _filteredAllMatches {
    final q = _searchController.text;
    return _allMatchesForHome.where((m) => _matchPassesSearch(m, q)).toList();
  }

  List<MatchModel> get _filteredLiveMatches {
    final q = _searchController.text;
    return _liveMatches.where((m) => _matchPassesSearch(m, q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final showAllMatches = _selectedFilter == _HomeMatchFilter.all;

    // Si match yo ap chaje, montre yon loading indicator
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppConstants.darkBg,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppConstants.primaryGreen,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      cursorColor: AppConstants.primaryGreen,
                      decoration: InputDecoration(
                        hintText: 'Search team or league',
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white54,
                          size: 22,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white54, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppConstants.cardBg,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppConstants.primaryGreen, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _FilterPillButton(
                            label: 'Tout',
                            selected: _selectedFilter == _HomeMatchFilter.all,
                            onTap: () {
                              if (!showAllMatches) {
                                setState(() => _selectedFilter = _HomeMatchFilter.all);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _FilterPillButton(
                            label: 'Match an dirèk',
                            selected: _selectedFilter == _HomeMatchFilter.live,
                            customLabel: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  color: _selectedFilter == _HomeMatchFilter.live
                                      ? AppConstants.primaryGreen
                                      : Colors.white54,
                                  fontWeight: _selectedFilter == _HomeMatchFilter.live
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  fontSize: 12,
                                ),
                                children: [
                                  const TextSpan(text: '🔴 '),
                                  TextSpan(
                                    text: 'LIVE ',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: _selectedFilter == _HomeMatchFilter.live
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const TextSpan(text: 'Match an dirèk'),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              if (showAllMatches) {
                                setState(() => _selectedFilter = _HomeMatchFilter.live);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (showAllMatches) ...[
                    if (_filteredAllMatches.isEmpty &&
                        _searchController.text.trim().isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child: Center(
                          child: Text(
                            'Pa gen match ki koresponn ak rechèch ou a.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                        ),
                      )
                    else
                      TodaysMatchesSection(
                        matches: _filteredAllMatches,
                        selectedOddForMatch: _selectedOddForMatch,
                        onOddSelected: _onOddSelected,
                        onMatchTap: _onMatchTap,
                      ),
                  ],
                  if (!showAllMatches) ...[
                    if (_filteredLiveMatches.isEmpty &&
                        _searchController.text.trim().isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child: Center(
                          child: Text(
                            'Pa gen match ki koresponn ak rechèch ou a.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                        ),
                      )
                    else
                      LiveMatchesSection(
                        matches: _filteredLiveMatches,
                        selectedOddForMatch: _selectedOddForMatch,
                        onOddSelected: _onOddSelected,
                        onMatchTap: _onMatchTap,
                      ),
                  ],

                  LeaguesSection(leagues: DummyData.footballLeagues),
                ],
              ),
            ),
          ),
          if (_betSlipItems.isNotEmpty) _buildBottomBetSlip(),
        ],
      ),
    );
  }

  String? _selectedOddForMatch(String matchId) {
    final found = _betSlipItems.where((e) => e.match.id == matchId);
    return found.isEmpty ? null : found.first.odd.label;
  }

  void _onOddSelected(MatchModel match, OddModel odd) {
    setState(() {
      final existingIndex = _betSlipItems.indexWhere((e) => e.match.id == match.id);
      if (existingIndex >= 0) {
        if (_betSlipItems[existingIndex].odd.label == odd.label) {
          _betSlipItems.removeAt(existingIndex);
        } else {
          _betSlipItems[existingIndex] = BetSlipItem(match: match, odd: odd);
        }
      } else {
        _betSlipItems.add(BetSlipItem(match: match, odd: odd));
      }
      _betSlipVersion.value++;
    });
  }

  void _onMatchTap(MatchModel match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MatchDetailsPage(
          match: match,
          betSlipItems: _betSlipItems,
          betSlipVersion: _betSlipVersion,
          onOddSelected: _onOddSelected,
          selectedOddForMatch: _selectedOddForMatch,
          stake: _stake,
          stakeController: _stakeController,
          onStakeChanged: (v) => setState(() => _stake = v),
          onPlaceBet: _placeBet,
          onBetPlaced: widget.onBetPlaced,
        ),
      ),
    );
  }

  double get _totalOdds {
    if (_betSlipItems.isEmpty) return 0;
    double product = 1;
    for (final item in _betSlipItems) {
      product *= item.odd.value;
    }
    return product;
  }

  void _openExpandedBetSlip() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.25,
        maxChildSize: 0.9,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: StatefulBuilder(
            builder: (modalCtx, setModalState) {
              return Container(
                decoration: BoxDecoration(
                  color: AppConstants.cardBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: BetSlipPanel(
                  items: _betSlipItems,
                  stake: _stake,
                  stakeController: _stakeController,
                  onStakeChanged: (v) {
                    setModalState(() {});
                    setState(() => _stake = v);
                  },
                  onPlaceBet: () {
                    Navigator.pop(ctx);
                    _placeBet();
                  },
                  onRemoveItem: () {},
                  onRemoveItemAt: (item) {
                    setState(() => _betSlipItems.remove(item));
                    setModalState(() {});
                    if (_betSlipItems.isEmpty) Navigator.pop(ctx);
                  },
                  onClose: () => Navigator.pop(ctx),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBetSlip() {
    return SafeArea(
      top: false,
      child: Material(
        color: AppConstants.cardBg,
        child: InkWell(
          onTap: _openExpandedBetSlip,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppConstants.cardBg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bet Slip (${_betSlipItems.length})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Total Odds ${_totalOdds.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppConstants.primaryGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _placeBet() async {
    final result = await BetPlacementService.placeBet(
      items: _betSlipItems,
      stake: _stake,
    );
    if (!mounted) return;
    switch (result.status) {
      case BetPlacementStatus.success:
        widget.onBetPlaced?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: AppConstants.primaryGreen,
          ),
        );
        setState(() {
          _betSlipItems.clear();
          _stake = 0;
          _stakeController.clear();
          _betSlipVersion.value++;
        });
        break;
      case BetPlacementStatus.notLoggedIn:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.orange,
          ),
        );
        break;
      case BetPlacementStatus.insufficientBalance:
      case BetPlacementStatus.invalidStake:
      case BetPlacementStatus.emptySlip:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
          ),
        );
        break;
    }
  }
}

class _FilterPillButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? customLabel;

  const _FilterPillButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? AppConstants.primaryGreen.withOpacity(0.2)
        : AppConstants.cardBg;
    final fg = selected ? AppConstants.primaryGreen : Colors.white54;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Center(
            child: customLabel ??
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: fg,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
