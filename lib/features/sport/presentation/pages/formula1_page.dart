import 'package:flutter/material.dart';
import 'package:sports_betting_app/data/dummy/dummy_data.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/sport_matches_page.dart';

class Formula1Page extends StatelessWidget {
  const Formula1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final sport = DummyData.sportById('formula_1');
    return SportMatchesPage(
      title: sport?.name ?? 'Formula 1',
      icon: sport?.icon ?? '🏎️',
      matches: sport?.matches ?? const [],
    );
  }
}

