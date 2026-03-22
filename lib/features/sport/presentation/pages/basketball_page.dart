import 'package:flutter/material.dart';
import 'package:sports_betting_app/data/dummy/dummy_data.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/sport_matches_page.dart';

class BasketballPage extends StatelessWidget {
  const BasketballPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sport = DummyData.sportById('basketball');
    return SportMatchesPage(
      title: sport?.name ?? 'Basketball',
      icon: sport?.icon ?? '🏀',
      matches: sport?.matches ?? const [],
    );
  }
}

