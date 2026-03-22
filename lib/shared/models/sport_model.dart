import 'package:sports_betting_app/shared/models/match_model.dart';

class SportModel {
  final String id;
  final String name;
  final String icon;
  final List<MatchModel> matches;

  const SportModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.matches,
  });
}
