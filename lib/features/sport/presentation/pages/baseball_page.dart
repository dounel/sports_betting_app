import 'package:flutter/material.dart';
import 'package:sports_betting_app/data/dummy/dummy_data.dart';
import 'package:sports_betting_app/features/sport/presentation/pages/sport_matches_page.dart';

class BaseballPage extends StatelessWidget {
  const BaseballPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sport = DummyData.sportById('baseball');
    return SportMatchesPage(
      title: sport?.name ?? 'Baseball',
      icon: sport?.icon ?? '⚾',
      matches: sport?.matches ?? const [],
    );
  }
}

