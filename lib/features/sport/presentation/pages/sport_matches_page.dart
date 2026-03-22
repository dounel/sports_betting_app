import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/features/home/presentation/pages/match_details_page.dart';
import 'package:sports_betting_app/features/home/presentation/widgets/todays_matches_section.dart';
import 'package:sports_betting_app/shared/models/bet_slip_item.dart';
import 'package:sports_betting_app/shared/models/match_model.dart';
import 'package:sports_betting_app/shared/models/odd_model.dart';

class SportMatchesPage extends StatefulWidget {
  final String title;
  final String icon;
  final List<MatchModel> matches;

  const SportMatchesPage({
    super.key,
    required this.title,
    required this.icon,
    required this.matches,
  });

  @override
  State<SportMatchesPage> createState() => _SportMatchesPageState();
}

class _SportMatchesPageState extends State<SportMatchesPage> {
  final List<BetSlipItem> _betSlipItems = [];
  final ValueNotifier<int> _betSlipVersion = ValueNotifier(0);
  final TextEditingController _stakeController = TextEditingController();
  double _stake = 0;

  @override
  void dispose() {
    _betSlipVersion.dispose();
    _stakeController.dispose();
    super.dispose();
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
          onPlaceBet: () async {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBg,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${widget.icon} ${widget.title}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: widget.matches.isEmpty
          ? const Center(
              child: Text(
                'Pa gen match pou lig sa a kounye a.',
                style: TextStyle(color: Colors.white54, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : TodaysMatchesSection(
              matches: widget.matches,
              selectedOddForMatch: _selectedOddForMatch,
              onOddSelected: _onOddSelected,
              onMatchTap: _onMatchTap,
            ),
    );
  }
}

