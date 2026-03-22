import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/data/dummy/dummy_data.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/basketball_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/baseball_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/boxing_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/cricket_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/esports_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/football_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/formula1_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/golf_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/ice_hockey_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/mma_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/rugby_page.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/tennis_page.dart';

class SportPage extends StatelessWidget {
  const SportPage({super.key});

  Widget _pageForSport(String id) {
    switch (id) {
      case 'football':
        return const FootballPage();
      case 'basketball':
        return const BasketballPage();
      case 'tennis':
        return const TennisPage();
      case 'boxing':
        return const BoxingPage();
      case 'mma':
        return const MMAPage();
      case 'baseball':
        return const BaseballPage();
      case 'ice_hockey':
        return const IceHockeyPage();
      case 'formula_1':
        return const Formula1Page();
      case 'cricket':
        return const CricketPage();
      case 'golf':
        return const GolfPage();
      case 'rugby':
        return const RugbyPage();
      case 'esports':
        return const EsportsPage();
      default:
        return const FootballPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: DummyData.sports.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          thickness: 1,
          color: Colors.white12,
        ),
        itemBuilder: (_, i) {
          final sport = DummyData.sports[i];
          return ListTile(
            dense: true,
            visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            leading: Text(
              sport.icon,
              style: const TextStyle(fontSize: 22),
            ),
            title: Text(
              sport.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => _pageForSport(sport.id)),
            ),
          );
        },
      ),
    );
  }
}
