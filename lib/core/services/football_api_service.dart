import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sports_betting_app/data/dummy/dummy_data.dart';
import 'package:sports_betting_app/shared/models/match_model.dart';

/// Sèvis pou jwenn done match foutbòl nan API a
/// Limite kantite match pou evite pwoblèm pèfòmans
class FootballApiService {
  // URL Vercel proxy - RANPLASE AK URL OU A apre deploy
  static const String _vercelProxyUrl = 'https://sports-betting-api.vercel.app';
  static const String _baseUrl = 'https://api.football-data.org/v4';
  static const String _apiKey = '396b03798bb52ede1863990b1fe633b3';

  /// Jwenn match pou jodi a ak yon limit
  /// [limit] - kantite match maksimòm pou jwenn (default: 50)
  static Future<List<MatchModel>> fetchFixtures({int limit = 50}) async {
    // Eseye Vercel proxy an premye (pou Web)
    try {
      final proxyUri = Uri.parse('$_vercelProxyUrl/api/matches').replace(queryParameters: {
        'type': 'all',
        'limit': limit.toString(),
      });

      final response = await http.get(proxyUri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final matches = _parseMatches(data['matches'] ?? []);
        return matches.take(limit).toList();
      }
    } catch (e) {
      print('Vercel proxy pa disponib: $e');
    }

    // Eseye API dirèk (pou Mobile)
    try {
      final uri = Uri.parse('$_baseUrl/matches').replace(queryParameters: {
        'status': 'SCHEDULED,LIVE,FINISHED',
        'limit': limit.toString(),
      });

      final response = await http.get(
        uri,
        headers: {
          'X-Auth-Token': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final matches = _parseMatches(data['matches'] ?? []);
        return matches.take(limit).toList();
      }
    } catch (e) {
      print('API dirèk pa disponib: $e');
    }

    // Fallback sou dummy data
    print('API pa disponib, itilize dummy data');
    return DummyData.todaysMatches.take(limit).toList();
  }

  /// Jwenn match ki an dirèk (Live) ak yon limit
  /// [limit] - kantite match maksimòm pou jwenn (default: 50)
  static Future<List<MatchModel>> fetchLiveFixtures({int limit = 50}) async {
    // Eseye Vercel proxy an premye (pou Web)
    try {
      final proxyUri = Uri.parse('$_vercelProxyUrl/api/matches').replace(queryParameters: {
        'type': 'live',
        'limit': limit.toString(),
      });

      final response = await http.get(proxyUri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final matches = _parseMatches(data['matches'] ?? []);
        return matches.take(limit).toList();
      }
    } catch (e) {
      print('Vercel proxy pa disponib: $e');
    }

    // Eseye API dirèk (pou Mobile)
    try {
      final uri = Uri.parse('$_baseUrl/matches').replace(queryParameters: {
        'status': 'LIVE,IN_PLAY',
        'limit': limit.toString(),
      });

      final response = await http.get(
        uri,
        headers: {
          'X-Auth-Token': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final matches = _parseMatches(data['matches'] ?? []);
        return matches.take(limit).toList();
      }
    } catch (e) {
      print('API dirèk pa disponib: $e');
    }

    // Fallback sou dummy data
    print('API pa disponib, itilize dummy data');
    return DummyData.liveMatches.take(limit).toList();
  }

  /// Konvèti done JSON an MatchModel
  static List<MatchModel> _parseMatches(List<dynamic> matchesJson) {
    return matchesJson.map((json) {
      final homeTeam = json['homeTeam']?['name'] ?? 'Ekip 1';
      final awayTeam = json['awayTeam']?['name'] ?? 'Ekip 2';
      final league = json['competition']?['name'] ?? 'Lig';
      final status = json['status'] ?? 'SCHEDULED';
      final utcDate = json['utcDate'] ?? '';
      
      // Parse skò si disponib
      String? score;
      final homeScore = json['score']?['fullTime']?['home'];
      final awayScore = json['score']?['fullTime']?['away'];
      if (homeScore != null && awayScore != null) {
        score = '$homeScore - $awayScore';
      }

      // Kalkile lè match la
      String time = _formatTime(utcDate);
      
      // Detèmine si match la an dirèk
      bool isLive = status == 'LIVE' || status == 'IN_PLAY';

      return MatchModel(
        id: json['id']?.toString() ?? '',
        team1: homeTeam,
        team2: awayTeam,
        league: league,
        time: time,
        score: score,
        isLive: isLive,
      );
    }).toList();
  }

  /// Fòmate dat UTC an lè lokal
  static String _formatTime(String utcDate) {
    try {
      final dateTime = DateTime.parse(utcDate).toLocal();
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--';
    }
  }
}
