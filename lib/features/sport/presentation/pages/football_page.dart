import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/data/dummy/dummy_data.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/sport_matches_page.dart';

class FootballPage extends StatelessWidget {
  const FootballPage({super.key});

  static const _sections = [
    'International',
    'England',
    'Spain',
    'France',
    'Germany',
  ];

  static const Map<String, List<String>> _leaguesBySection = {
    'International': [
      'UEFA Champions League',
      'Europa League',
      'World Cup',
    ],
    'England': [
      'Premier League',
      'FA Cup',
    ],
    'Spain': [
      'La Liga',
      'Copa del Rey',
    ],
    'France': [
      'Ligue 1',
    ],
    'Germany': [
      'Bundesliga',
    ],
  };

  void _openLeague(BuildContext context, String leagueName) {
    final matches = DummyData.matchesForLeague(leagueName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SportMatchesPage(
          title: leagueName,
          icon: '⚽',
          matches: matches,
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
        title: const Text(
          '⚽ Football - Lig yo',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _sections.length,
        itemBuilder: (context, index) {
          final section = _sections[index];
          final leagues = _leaguesBySection[section] ?? const [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 16),
              Text(
                section,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              ...leagues.map(
                (league) => ListTile(
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -3),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  leading: const Icon(
                    Icons.sports_soccer_rounded,
                    color: AppConstants.primaryGreen,
                    size: 18,
                  ),
                  title: Text(
                    league,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white38,
                    size: 18,
                  ),
                  onTap: () => _openLeague(context, league),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

