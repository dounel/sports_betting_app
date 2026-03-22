import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/shared/models/match_model.dart';
import 'package:sports_betting_app/shared/models/odd_model.dart';

class MatchOddsCard extends StatelessWidget {
  final MatchModel match;
  final List<OddModel> odds;
  final String? selectedOddLabel;
  final ValueChanged<OddModel> onOddSelected;

  const MatchOddsCard({
    super.key,
    required this.match,
    required this.odds,
    this.selectedOddLabel,
    required this.onOddSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.primaryGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            match.league,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  match.team1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                match.time,
                style: const TextStyle(
                  color: AppConstants.primaryGreen,
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: Text(
                  match.team2,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: odds.map((odd) {
              final isSelected = selectedOddLabel == odd.label;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: isSelected
                        ? AppConstants.primaryGreen.withOpacity(0.3)
                        : AppConstants.darkBg,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () => onOddSelected(odd),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Text(
                              odd.label,
                              style: TextStyle(
                                color: isSelected
                                    ? AppConstants.primaryGreen
                                    : Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              odd.value.toStringAsFixed(2),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppConstants.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
