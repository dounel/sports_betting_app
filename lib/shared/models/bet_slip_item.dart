import 'package:sports_betting_app/shared/models/match_model.dart';
import 'package:sports_betting_app/shared/models/odd_model.dart';

/// Yon pari chwazi nan bet slip la: match + cote (1, X, 2).
class BetSlipItem {
  final MatchModel match;
  final OddModel odd;

  const BetSlipItem({required this.match, required this.odd});
}
