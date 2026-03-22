import 'package:flutter/material.dart';
import 'package:sports_betting_app/data/dummy/dummy_data.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/sport_matches_page.dart';

class IceHockeyPage extends StatelessWidget {
  const IceHockeyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sport = DummyData.sportById('ice_hockey');
    return SportMatchesPage(
      title: sport?.name ?? 'Ice Hockey',
      icon: sport?.icon ?? '🏒',
      matches: sport?.matches ?? const [],
    );
  }
}

