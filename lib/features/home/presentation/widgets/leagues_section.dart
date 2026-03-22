import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';

class LeaguesSection extends StatelessWidget {
  final List<String> leagues;

  const LeaguesSection({super.key, required this.leagues});

  @override
  Widget build(BuildContext context) {
    if (leagues.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Lig foutbòl',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: leagues
                .map(
                  (name) => Chip(
                    label: Text(
                      name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppConstants.cardBg,
                    side: BorderSide(
                      color: AppConstants.primaryGreen.withOpacity(0.5),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
