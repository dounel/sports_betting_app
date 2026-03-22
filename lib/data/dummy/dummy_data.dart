import 'package:sports_betting_app/shared/models/bet_ticket_model.dart';
import 'package:sports_betting_app/shared/models/match_model.dart';
import 'package:sports_betting_app/shared/models/odd_model.dart';
import 'package:sports_betting_app/shared/models/payment_transaction.dart';
import 'package:sports_betting_app/shared/models/sport_model.dart';

class DummyData {
  static List<MatchModel> get liveMatches => [
    const MatchModel(
      id: 'live1',
      team1: 'Brazil',
      team2: 'Argentina',
      league: 'FIFA World Cup',
      time: '45\'',
      isLive: true,
      score: '1 - 0',
    ),
    const MatchModel(
      id: 'live2',
      team1: 'Real Madrid',
      team2: 'Barcelona',
      league: 'La Liga',
      time: '67\'',
      isLive: true,
      score: '2 - 1',
    ),
  ];

  static List<MatchModel> get todaysMatches => [
    const MatchModel(
      id: 't1',
      team1: 'Chelsea',
      team2: 'Liverpool',
      league: 'Premier League',
      time: '15:00',
      isLive: false,
    ),
    const MatchModel(
      id: 't2',
      team1: 'PSG',
      team2: 'Marseille',
      league: 'Ligue 1',
      time: '21:00',
      isLive: false,
    ),
    const MatchModel(
      id: 't3',
      team1: 'Bayern',
      team2: 'Dortmund',
      league: 'Bundesliga',
      time: '18:30',
      isLive: false,
    ),
  ];

  /// Match upcoming ki pa jodi a (pita) pou seksyon "Tout".
  static List<MatchModel> get laterMatches => [
    const MatchModel(
      id: 'l1',
      team1: 'Inter',
      team2: 'Milan',
      league: 'Serie A',
      time: '20:00',
      isLive: false,
    ),
    const MatchModel(
      id: 'l2',
      team1: 'Ajax',
      team2: 'PSV',
      league: 'Eredivisie',
      time: '21:30',
      isLive: false,
    ),
  ];

  static List<String> get footballLeagues => [
    'UEFA Champions League',
    'Europa League',
    'World Cup',
    'Premier League',
    'FA Cup',
    'La Liga',
    'Copa del Rey',
    'Ligue 1',
    'Bundesliga',
  ];

  static List<SportModel> get sports => [
        SportModel(
          id: 'football',
          name: 'Football',
          icon: '⚽',
          matches: [
            ...todaysMatches,
            const MatchModel(
              id: 'f1',
              team1: 'Man City',
              team2: 'Arsenal',
              league: 'Premier League',
              time: '17:30',
              isLive: false,
            ),
          ],
        ),
        SportModel(
          id: 'basketball',
          name: 'Basketball',
          icon: '🏀',
          matches: const [
            MatchModel(
              id: 'b1',
              team1: 'Lakers',
              team2: 'Celtics',
              league: 'NBA',
              time: '20:00',
              isLive: false,
            ),
            MatchModel(
              id: 'b2',
              team1: 'Heat',
              team2: 'Bucks',
              league: 'NBA',
              time: '22:00',
              isLive: false,
            ),
          ],
        ),
        SportModel(
          id: 'tennis',
          name: 'Tennis',
          icon: '🎾',
          matches: const [
            MatchModel(
              id: 'tn1',
              team1: 'Djokovic',
              team2: 'Alcaraz',
              league: 'ATP',
              time: '19:00',
              isLive: false,
            ),
            MatchModel(
              id: 'tn2',
              team1: 'SwIATEK',
              team2: 'Gauff',
              league: 'WTA',
              time: '13:30',
              isLive: false,
            ),
          ],
        ),
        SportModel(
          id: 'boxing',
          name: 'Boxing',
          icon: '🥊',
          matches: const [
            MatchModel(
              id: 'bx1',
              team1: 'Fighter A',
              team2: 'Fighter B',
              league: 'Main Card',
              time: '21:00',
              isLive: false,
            ),
          ],
        ),
        SportModel(
          id: 'mma',
          name: 'MMA',
          icon: '🥋',
          matches: const [
            MatchModel(
              id: 'mma1',
              team1: 'Fighter X',
              team2: 'Fighter Y',
              league: 'UFC',
              time: '23:00',
              isLive: false,
            ),
          ],
        ),
        SportModel(
          id: 'baseball',
          name: 'Baseball',
          icon: '⚾',
          matches: const [
            MatchModel(
              id: 'bb1',
              team1: 'Yankees',
              team2: 'Red Sox',
              league: 'MLB',
              time: '19:10',
              isLive: false,
            ),
          ],
        ),
        SportModel(
          id: 'ice_hockey',
          name: 'Ice Hockey',
          icon: '🏒',
          matches: const [
            MatchModel(
              id: 'ih1',
              team1: 'Maple Leafs',
              team2: 'Canadiens',
              league: 'NHL',
              time: '20:30',
              isLive: false,
            ),
          ],
        ),
        SportModel(
          id: 'formula_1',
          name: 'Formula 1',
          icon: '🏎️',
          matches: const [
            MatchModel(
              id: 'f11',
              team1: 'Verstappen',
              team2: 'Hamilton',
              league: 'Grand Prix',
              time: '14:00',
              isLive: false,
            ),
          ],
        ),
        SportModel(
          id: 'cricket',
          name: 'Cricket',
          icon: '🏏',
          matches: const [
            MatchModel(
              id: 'cr1',
              team1: 'India',
              team2: 'Australia',
              league: 'ODI',
              time: '10:00',
              isLive: false,
            ),
          ],
        ),
        SportModel(
          id: 'golf',
          name: 'Golf',
          icon: '⛳',
          matches: const [
            MatchModel(
              id: 'gf1',
              team1: 'Player 1',
              team2: 'Player 2',
              league: 'PGA',
              time: '09:00',
              isLive: false,
            ),
          ],
        ),
        SportModel(
          id: 'rugby',
          name: 'Rugby',
          icon: '🏉',
          matches: const [
            MatchModel(
              id: 'rg1',
              team1: 'Team Red',
              team2: 'Team Blue',
              league: 'League',
              time: '16:00',
              isLive: false,
            ),
          ],
        ),
        SportModel(
          id: 'esports',
          name: 'eSports',
          icon: '🎮',
          matches: const [
            MatchModel(
              id: 'es1',
              team1: 'Team Alpha',
              team2: 'Team Omega',
              league: 'Tournament',
              time: '18:00',
              isLive: false,
            ),
          ],
        ),
      ];

  static SportModel? sportById(String id) {
    for (final s in sports) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Match pou chak lig football (dummy pou demo).
  static List<MatchModel> matchesForLeague(String league) {
    switch (league) {
      case 'UEFA Champions League':
        return const [
          MatchModel(
            id: 'ucl1',
            team1: 'Real Madrid',
            team2: 'Man City',
            league: 'UEFA Champions League',
            time: '15:00',
            isLive: false,
          ),
          MatchModel(
            id: 'ucl2',
            team1: 'Bayern',
            team2: 'PSG',
            league: 'UEFA Champions League',
            time: '20:00',
            isLive: false,
          ),
        ];
      case 'Europa League':
        return const [
          MatchModel(
            id: 'uel1',
            team1: 'Arsenal',
            team2: 'Roma',
            league: 'Europa League',
            time: '18:45',
            isLive: false,
          ),
        ];
      case 'World Cup':
        return const [
          MatchModel(
            id: 'wc1',
            team1: 'Brazil',
            team2: 'France',
            league: 'World Cup',
            time: '21:00',
            isLive: false,
          ),
        ];
      case 'Premier League':
        return const [
          MatchModel(
            id: 'epl1',
            team1: 'Chelsea',
            team2: 'Liverpool',
            league: 'Premier League',
            time: '15:00',
            isLive: false,
          ),
          MatchModel(
            id: 'epl2',
            team1: 'Man City',
            team2: 'Arsenal',
            league: 'Premier League',
            time: '17:30',
            isLive: false,
          ),
        ];
      case 'FA Cup':
        return const [
          MatchModel(
            id: 'fac1',
            team1: 'Man United',
            team2: 'Newcastle',
            league: 'FA Cup',
            time: '19:00',
            isLive: false,
          ),
        ];
      case 'La Liga':
        return const [
          MatchModel(
            id: 'll1',
            team1: 'Barcelona',
            team2: 'Real Madrid',
            league: 'La Liga',
            time: '16:15',
            isLive: false,
          ),
        ];
      case 'Copa del Rey':
        return const [
          MatchModel(
            id: 'cdr1',
            team1: 'Sevilla',
            team2: 'Atletico Madrid',
            league: 'Copa del Rey',
            time: '20:30',
            isLive: false,
          ),
        ];
      case 'Ligue 1':
        return const [
          MatchModel(
            id: 'l1_1',
            team1: 'PSG',
            team2: 'Marseille',
            league: 'Ligue 1',
            time: '21:00',
            isLive: false,
          ),
        ];
      case 'Bundesliga':
        return const [
          MatchModel(
            id: 'buli1',
            team1: 'Bayern',
            team2: 'Dortmund',
            league: 'Bundesliga',
            time: '18:30',
            isLive: false,
          ),
        ];
      default:
        return const [];
    }
  }

  static List<MatchModel> get betMatches => [
    const MatchModel(
      id: 'bt1',
      team1: 'Chelsea',
      team2: 'Liverpool',
      league: 'Premier League',
      time: '15:00',
    ),
    const MatchModel(
      id: 'bt2',
      team1: 'PSG',
      team2: 'Marseille',
      league: 'Ligue 1',
      time: '21:00',
    ),
  ];

  static List<OddModel> oddsForMatch(String matchId) => [
    const OddModel(label: '1', value: 2.10),
    const OddModel(label: 'X', value: 3.40),
    const OddModel(label: '2', value: 3.20),
  ];

  static List<BetTicketModel> get betTickets => [
    // Tikè ki an kou (san skò, match poko fini)
    const BetTicketModel(
      id: 'tk1',
      team1: 'Barcelona',
      team2: 'Real Madrid',
      odds: 2.10,
      betAmount: 100,
      possibleWin: 210,
      status: BetTicketStatus.pending,
      selections: [
        BetTicketSelection(
          league: 'La Liga',
          team1: 'Barcelona',
          team2: 'Real Madrid',
          betLabel: 'V1',
          odds: 2.10,
          matchStatus: 'NS', // Match poko kòmanse
          result: BetTicketStatus.pending,
        ),
      ],
    ),
    // Tikè ki genyen: Chelsea 2 - 1 Liverpool, pari V1 (Chelsea genyen), match fini (FT)
    const BetTicketModel(
      id: 'tk2',
      team1: 'Chelsea',
      team2: 'Liverpool',
      odds: 3.40,
      betAmount: 500,
      possibleWin: 1700,
      status: BetTicketStatus.won,
      selections: [
        BetTicketSelection(
          league: 'Premier League',
          team1: 'Chelsea',
          team2: 'Liverpool',
          betLabel: 'V1',
          odds: 3.40,
          team1Score: 2,
          team2Score: 1,
          matchStatus: 'FT', // Match fini
          result: BetTicketStatus.won,
        ),
      ],
    ),
    // Tikè ki pèdi: PSG 1 - 2 Marseille, pari V1 (PSG pèdi), match fini (FT)
    const BetTicketModel(
      id: 'tk3',
      team1: 'PSG',
      team2: 'Marseille',
      odds: 2.50,
      betAmount: 200,
      possibleWin: 500,
      status: BetTicketStatus.lost,
      selections: [
        BetTicketSelection(
          league: 'Ligue 1',
          team1: 'PSG',
          team2: 'Marseille',
          betLabel: 'V1',
          odds: 2.50,
          team1Score: 1,
          team2Score: 2,
          matchStatus: 'FT', // Match fini
          result: BetTicketStatus.lost,
        ),
      ],
    ),
    // Tikè ki genyen ak nil: Bayern 2 - 2 Dortmund, pari X (nil), match fini (FT)
    const BetTicketModel(
      id: 'tk4',
      team1: 'Bayern',
      team2: 'Dortmund',
      odds: 1.85,
      betAmount: 1000,
      possibleWin: 1850,
      status: BetTicketStatus.won,
      selections: [
        BetTicketSelection(
          league: 'Bundesliga',
          team1: 'Bayern',
          team2: 'Dortmund',
          betLabel: 'X',
          odds: 1.85,
          team1Score: 2,
          team2Score: 2,
          matchStatus: 'FT', // Match fini
          result: BetTicketStatus.won,
        ),
      ],
    ),
    // Tikè kombine ki genyen - tout match fini (FT)
    const BetTicketModel(
      id: 'tk5',
      team1: 'Man City',
      team2: 'Arsenal',
      odds: 4.20,
      betAmount: 100,
      possibleWin: 420,
      status: BetTicketStatus.won,
      selections: [
        BetTicketSelection(
          league: 'Premier League',
          team1: 'Man City',
          team2: 'Arsenal',
          betLabel: 'V1',
          odds: 2.10,
          team1Score: 3,
          team2Score: 0,
          matchStatus: 'FT', // Match fini
          result: BetTicketStatus.won,
        ),
        BetTicketSelection(
          league: 'La Liga',
          team1: 'Real Madrid',
          team2: 'Barcelona',
          betLabel: 'V2',
          odds: 2.00,
          team1Score: 1,
          team2Score: 2,
          matchStatus: 'FT', // Match fini
          result: BetTicketStatus.won,
        ),
      ],
    ),
  ];

  static List<PaymentTransaction> get paymentHistory => [
    PaymentTransaction(
      id: 'ph1',
      type: 'deposit',
      amount: 50.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'completed',
    ),
    PaymentTransaction(
      id: 'ph2',
      type: 'withdraw',
      amount: 25.00,
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'completed',
    ),
    PaymentTransaction(
      id: 'ph3',
      type: 'deposit',
      amount: 100.00,
      date: DateTime.now().subtract(const Duration(days: 10)),
      status: 'completed',
    ),
  ];
}
