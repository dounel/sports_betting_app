class MatchModel {
  final String id;
  final String team1;
  final String team2;
  final String league;
  final String time;
  final bool isLive;
  final String? score;

  const MatchModel({
    required this.id,
    required this.team1,
    required this.team2,
    required this.league,
    required this.time,
    this.isLive = false,
    this.score,
  });
}
