import 'package:flutter/material.dart';
import 'package:sports_betting_app/data/dummy/dummy_data.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/sport_matches_page.dart';

class TennisPage extends StatelessWidget {
  const TennisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sport = DummyData.sportById('tennis');
    return SportMatchesPage(
      title: sport?.name ?? 'Tennis',
      icon: sport?.icon ?? '🎾',
      matches: sport?.matches ?? const [],
    );
  }
}

