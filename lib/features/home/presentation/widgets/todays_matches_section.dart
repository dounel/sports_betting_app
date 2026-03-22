import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/data/dummy/dummy_data.dart';
import 'package:sports_betting_app/shared/models/match_model.dart';
import 'package:sports_betting_app/shared/models/odd_model.dart';

class TodaysMatchesSection extends StatelessWidget {
  final List<MatchModel> matches;
  final String? Function(String matchId)? selectedOddForMatch;
  final void Function(MatchModel match, OddModel odd)? onOddSelected;
  final void Function(MatchModel match)? onMatchTap;

  const TodaysMatchesSection({
    super.key,
    required this.matches,
    this.selectedOddForMatch,
    this.onOddSelected,
    this.onMatchTap,
  });

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) return const SizedBox.shrink();
    final groupedMatches = _groupByLeague(matches);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: groupedMatches.length,
          itemBuilder: (_, i) {
            final league = groupedMatches.keys.elementAt(i);
            final leagueMatches = groupedMatches[league]!;
            return Padding(
              padding: EdgeInsets.only(bottom: i == groupedMatches.length - 1 ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                    child: Text(
                      _leagueHeader(league),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: leagueMatches.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (_, index) {
                      final match = leagueMatches[index];
                      final odds = DummyData.oddsForMatch(match.id);
                      return _MatchCard(
                        match: match,
                        odds: odds,
                        selectedOddLabel: selectedOddForMatch?.call(match.id),
                        onOddSelected: onOddSelected,
                        onMatchTap: onMatchTap,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Map<String, List<MatchModel>> _groupByLeague(List<MatchModel> input) {
    final grouped = <String, List<MatchModel>>{};
    for (final match in input) {
      grouped.putIfAbsent(match.league, () => <MatchModel>[]).add(match);
    }
    return grouped;
  }

  String _leagueHeader(String league) {
    switch (league) {
      case 'Premier League':
        return 'Football. England. Premier League';
      case 'Ligue 1':
        return 'Football. France. Ligue 1';
      case 'Bundesliga':
        return 'Football. Germany. Bundesliga';
      case 'Serie A':
        return 'Football. Italy. Serie A';
      case 'Eredivisie':
        return 'Football. Netherlands. Eredivisie';
      default:
        return 'Football. $league';
    }
  }
}

class _MatchCard extends StatelessWidget {
  final MatchModel match;
  final List<OddModel> odds;
  final String? selectedOddLabel;
  final void Function(MatchModel match, OddModel odd)? onOddSelected;
  final void Function(MatchModel match)? onMatchTap;

  const _MatchCard({
    required this.match,
    required this.odds,
    this.selectedOddLabel,
    this.onOddSelected,
    this.onMatchTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDateTime = _formatMatchDateTime(match);
    return _InteractiveMatchCard(
      match: match,
      odds: odds,
      formattedDateTime: formattedDateTime,
      selectedOddLabel: selectedOddLabel,
      onOddSelected: onOddSelected,
      onMatchTap: onMatchTap,
    );
  }

  String _formatMatchDateTime(MatchModel m) {
    final dayById = <String, String>{
      't1': '20 Mar',
      't2': '21 Mar',
      't3': '21 Mar',
      'l1': '22 Mar',
      'l2': '23 Mar',
    };
    final day = dayById[m.id] ?? '21 Mar';
    return '$day / ${_toAmPm(m.time)}';
  }

  String _toAmPm(String time24h) {
    final parts = time24h.split(':');
    if (parts.length != 2) return time24h;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return time24h;

    final period = hour >= 12 ? 'pm' : 'am';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteText = minute.toString().padLeft(2, '0');
    return '${hour12.toString().padLeft(2, '0')}:$minuteText $period';
  }

}

class _InteractiveMatchCard extends StatefulWidget {
  final MatchModel match;
  final List<OddModel> odds;
  final String formattedDateTime;
  final String? selectedOddLabel;
  final void Function(MatchModel match, OddModel odd)? onOddSelected;
  final void Function(MatchModel match)? onMatchTap;

  const _InteractiveMatchCard({
    required this.match,
    required this.odds,
    required this.formattedDateTime,
    this.selectedOddLabel,
    this.onOddSelected,
    this.onMatchTap,
  });

  @override
  State<_InteractiveMatchCard> createState() => _InteractiveMatchCardState();
}

class _InteractiveMatchCardState extends State<_InteractiveMatchCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppConstants.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: widget.onMatchTap != null
                  ? () => widget.onMatchTap!(widget.match)
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.match.team1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.match.team2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.formattedDateTime,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              _OddPill(
                label: 'V1',
                odd: widget.odds.isNotEmpty ? widget.odds[0].value : 0,
                selected: widget.selectedOddLabel == 'V1',
                onTap: () => _emitOddSelection('V1'),
              ),
              const SizedBox(width: 6),
              _OddPill(
                label: 'X',
                odd: widget.odds.length > 1 ? widget.odds[1].value : 0,
                selected: widget.selectedOddLabel == 'X',
                onTap: () => _emitOddSelection('X'),
              ),
              const SizedBox(width: 6),
              _OddPill(
                label: 'V2',
                odd: widget.odds.length > 2 ? widget.odds[2].value : 0,
                selected: widget.selectedOddLabel == 'V2',
                onTap: () => _emitOddSelection('V2'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _emitOddSelection(String label) {
    if (widget.onOddSelected == null) return;
    final double value = label == 'V1'
        ? (widget.odds.isNotEmpty ? widget.odds[0].value : 0.0)
        : label == 'X'
            ? (widget.odds.length > 1 ? widget.odds[1].value : 0.0)
            : (widget.odds.length > 2 ? widget.odds[2].value : 0.0);
    widget.onOddSelected!(widget.match, OddModel(label: label, value: value));
  }
}

class _OddPill extends StatelessWidget {
  final String label;
  final double odd;
  final bool selected;
  final VoidCallback onTap;

  const _OddPill({
    required this.label,
    required this.odd,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 60,
      child: Material(
        color: selected
            ? AppConstants.primaryGreen.withOpacity(0.35)
            : AppConstants.darkBg,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: selected
                  ? Border.all(color: AppConstants.primaryGreen, width: 2)
                  : Border.all(color: Colors.white12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppConstants.primaryGreen : Colors.white54,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  odd.toStringAsFixed(2),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
