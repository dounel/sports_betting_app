import 'dart:math';

/// Yon seleksyon andan yon tikè: lig, ekip, pari chwazi, cote, skò, rezilta.
class BetTicketSelection {
  final String league;
  final String team1;
  final String team2;
  final String betLabel;
  final double odds;
  final int? team1Score;
  final int? team2Score;
  final String? matchStatus; // FT = full time, match fini
  final bool isSimulated; // true si skò a se similasyon pou tès
  final BetTicketStatus result;

  const BetTicketSelection({
    required this.league,
    required this.team1,
    required this.team2,
    required this.betLabel,
    required this.odds,
    this.team1Score,
    this.team2Score,
    this.matchStatus,
    this.isSimulated = false,
    required this.result,
  });

  Map<String, dynamic> toJson() => {
        'league': league,
        'team1': team1,
        'team2': team2,
        'betLabel': betLabel,
        'odds': odds,
        'team1Score': team1Score,
        'team2Score': team2Score,
        'matchStatus': matchStatus,
        'isSimulated': isSimulated,
        'result': result.name,
      };

  factory BetTicketSelection.fromJson(Map<String, dynamic> json) {
    final r = json['result'] as String?;
    BetTicketStatus result = BetTicketStatus.pending;
    if (r == 'won') result = BetTicketStatus.won;
    if (r == 'lost') result = BetTicketStatus.lost;
    return BetTicketSelection(
      league: json['league'] as String? ?? '',
      team1: json['team1'] as String? ?? '',
      team2: json['team2'] as String? ?? '',
      betLabel: json['betLabel'] as String? ?? '',
      odds: (json['odds'] as num?)?.toDouble() ?? 0,
      team1Score: (json['team1Score'] as num?)?.toInt(),
      team2Score: (json['team2Score'] as num?)?.toInt(),
      matchStatus: json['matchStatus'] as String?,
      isSimulated: json['isSimulated'] as bool? ?? false,
      result: result,
    );
  }

  String get scoreDisplay {
    if (team1Score != null && team2Score != null) {
      return '$team1Score - $team2Score';
    }
    return '—  —';
  }

  /// Kalkile rezilta seleksyon an dapre skò a ak pari chwazi a
  /// V1 = ekip lakay genyen, X = nil, V2 = ekip deyò genyen
  /// Fonksyonnen ak REÈL oswa SIMILASYON
  BetTicketStatus calculateResult() {
    // Si pa gen skò, retounen "An kou"
    if (team1Score == null || team2Score == null) {
      return BetTicketStatus.pending;
    }

    final bool isHomeWin = team1Score! > team2Score!;
    final bool isDraw = team1Score! == team2Score!;
    final bool isAwayWin = team1Score! < team2Score!;

    // Normalizet betLabel (V1, V2, X oswa 1, 2, X)
    final normalizedLabel = betLabel.toUpperCase().trim();

    // V1 oswa 1 = ekip lakay genyen
    if (normalizedLabel == 'V1' || normalizedLabel == '1') {
      return isHomeWin ? BetTicketStatus.won : BetTicketStatus.lost;
    }

    // X = nil
    if (normalizedLabel == 'X') {
      return isDraw ? BetTicketStatus.won : BetTicketStatus.lost;
    }

    // V2 oswa 2 = ekip deyò genyen
    if (normalizedLabel == 'V2' || normalizedLabel == '2') {
      return isAwayWin ? BetTicketStatus.won : BetTicketStatus.lost;
    }

    // Si pa gen match, retounen an kou
    return BetTicketStatus.pending;
  }

  /// Jenere yon skò simile pou tès
  /// Retounen yon nouvo seleksyon ak skò simile ak estati FT
  BetTicketSelection withSimulatedScore() {
    final random = Random();
    // Jenere skò reyalis (0-5 gòl pou chak ekip)
    final s1 = random.nextInt(6);
    final s2 = random.nextInt(6);

    final newSelection = BetTicketSelection(
      league: league,
      team1: team1,
      team2: team2,
      betLabel: betLabel,
      odds: odds,
      team1Score: s1,
      team2Score: s2,
      matchStatus: 'FT', // Simile tankou match fini
      isSimulated: true, // Make ke se similasyon
      result: result,
    );

    // Kalkile rezilta ak skò simile a
    return newSelection.copyWith(result: newSelection.calculateResult());
  }

  /// Rann yon seleksyon ak skò REÈL soti nan API a
  /// Si pa gen skò reyèl, itilize similasyon
  BetTicketSelection withRealOrSimulatedScore(String? scoreString, String? apiMatchStatus) {
    // Si API a bay yon skò ak estati FT, itilize li
    if (scoreString != null && scoreString.isNotEmpty && apiMatchStatus == 'FT') {
      try {
        final cleaned = scoreString.replaceAll(' ', '');
        final parts = cleaned.split('-');
        if (parts.length == 2) {
          final s1 = int.tryParse(parts[0]);
          final s2 = int.tryParse(parts[1]);
          if (s1 != null && s2 != null) {
            final newSelection = BetTicketSelection(
              league: league,
              team1: team1,
              team2: team2,
              betLabel: betLabel,
              odds: odds,
              team1Score: s1,
              team2Score: s2,
              matchStatus: 'FT',
              isSimulated: false, // Skò reyèl
              result: result,
            );
            return newSelection.copyWith(result: newSelection.calculateResult());
          }
        }
      } catch (_) {
        // Si gen ere nan parsing, pase nan similasyon
      }
    }

    // Si pa gen done reyèl, itilize similasyon
    return withSimulatedScore();
  }

  /// Parse yon skò string (egzanp: "2 - 1") epi retounen yon nouvo seleksyon ak skò yo
  BetTicketSelection withParsedScore(String? scoreString) {
    if (scoreString == null || scoreString.isEmpty) {
      return this;
    }

    try {
      // Netwaye string la epi separe pa tire (-)
      final cleaned = scoreString.replaceAll(' ', '');
      final parts = cleaned.split('-');
      if (parts.length == 2) {
        final s1 = int.tryParse(parts[0]);
        final s2 = int.tryParse(parts[1]);
        if (s1 != null && s2 != null) {
          final newSelection = BetTicketSelection(
            league: league,
            team1: team1,
            team2: team2,
            betLabel: betLabel,
            odds: odds,
            team1Score: s1,
            team2Score: s2,
            result: result,
          );
          // Kalkile rezilta ak nouvo skò a
          return newSelection.copyWith(result: newSelection.calculateResult());
        }
      }
    } catch (_) {
      // Si gen ere, retounen seleksyon orijinal la
    }
    return this;
  }

  BetTicketSelection copyWith({
    String? league,
    String? team1,
    String? team2,
    String? betLabel,
    double? odds,
    int? team1Score,
    int? team2Score,
    String? matchStatus,
    bool? isSimulated,
    BetTicketStatus? result,
  }) {
    return BetTicketSelection(
      league: league ?? this.league,
      team1: team1 ?? this.team1,
      team2: team2 ?? this.team2,
      betLabel: betLabel ?? this.betLabel,
      odds: odds ?? this.odds,
      team1Score: team1Score ?? this.team1Score,
      team2Score: team2Score ?? this.team2Score,
      matchStatus: matchStatus ?? this.matchStatus,
      isSimulated: isSimulated ?? this.isSimulated,
      result: result ?? this.result,
    );
  }
}

/// Yon tikè pari: match, cote, montan pari, posib genyen, ak estati (An kou / Pè / Genyen).
class BetTicketModel {
  final String id;
  final String team1;
  final String team2;
  final double odds;
  final double betAmount;
  final double possibleWin;
  final BetTicketStatus status;
  final List<BetTicketSelection>? selections;
  final DateTime? createdAt;

  const BetTicketModel({
    required this.id,
    required this.team1,
    required this.team2,
    required this.odds,
    required this.betAmount,
    required this.possibleWin,
    required this.status,
    this.selections,
    this.createdAt,
  });

  /// Match detay pou afichaj - itilize selections si genyen, sinon kreye yon sèl apati team1/team2/odds.
  List<BetTicketSelection> get displaySelections {
    if (selections != null && selections!.isNotEmpty) {
      return selections!;
    }
    return [
      BetTicketSelection(
        league: '',
        team1: team1,
        team2: team2,
        betLabel: 'Cote ${odds.toStringAsFixed(2)}',
        odds: odds,
        result: status,
      ),
    ];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'team1': team1,
        'team2': team2,
        'odds': odds,
        'betAmount': betAmount,
        'possibleWin': possibleWin,
        'status': status.name,
        'selections': selections?.map((s) => s.toJson()).toList(),
        'createdAt': createdAt?.toIso8601String(),
      };

  factory BetTicketModel.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String?;
    BetTicketStatus status = BetTicketStatus.pending;
    if (statusStr == 'won') status = BetTicketStatus.won;
    if (statusStr == 'lost') status = BetTicketStatus.lost;
    List<BetTicketSelection>? sel;
    final selList = json['selections'] as List<dynamic>?;
    if (selList != null) {
      sel = selList
          .map((e) => BetTicketSelection.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    DateTime? created;
    final createdStr = json['createdAt'] as String?;
    if (createdStr != null) {
      created = DateTime.tryParse(createdStr);
    }
    return BetTicketModel(
      id: json['id'] as String? ?? '',
      team1: json['team1'] as String? ?? '',
      team2: json['team2'] as String? ?? '',
      odds: (json['odds'] as num?)?.toDouble() ?? 0,
      betAmount: (json['betAmount'] as num?)?.toDouble() ?? 0,
      possibleWin: (json['possibleWin'] as num?)?.toDouble() ?? 0,
      status: status,
      selections: sel,
      createdAt: created,
    );
  }

  /// Kalkile estati jeneral tikè a dapre tout seleksyon yo (Lojik Pari Reèl)
  /// 
  /// Règ sportsbook:
  /// 1. Si omwen yon match pèdi → Tikè pèdi (0 HTG)
  /// 2. Si tout match fini (FT) e tout korek → Tikè genyen (Gain = stake × odds)
  /// 3. Si match yo an kou → An kou (montre kob potansyèl la)
  BetTicketStatus calculateOverallStatus() {
    final sels = displaySelections;
    if (sels.isEmpty) return status;

    bool allFinished = true;
    bool anyLost = false;
    bool allWon = true;

    for (final sel in sels) {
      final selStatus = sel.calculateResult();
      // Tcheke si match la fini (FT) - si pa FT, li an kou
      if (sel.matchStatus != 'FT') {
        allFinished = false;
      }
      if (selStatus == BetTicketStatus.lost) {
        anyLost = true;
        allWon = false;
      } else if (selStatus == BetTicketStatus.pending) {
        allWon = false;
      }
    }

    // Règ #1: Si omwen yon match pèdi → Tikè pèdi
    if (anyLost) return BetTicketStatus.lost;
    
    // Règ #2: Si tout match fini e tout korek → Tikè genyen
    if (allFinished && allWon) return BetTicketStatus.won;
    
    // Règ #3: Si match yo an kou → An kou
    return BetTicketStatus.pending;
  }

  /// Kalkile kantite kob REYÈL pou touche
  /// 
  /// - Si tikè genyen: gain = stake × total_odds
  /// - Si tikè pèdi oswa an kou: 0 HTG
  double calculateActualWinnings() {
    final overallStatus = calculateOverallStatus();
    if (overallStatus == BetTicketStatus.won) {
      return betAmount * odds;
    }
    return 0.0;
  }

  /// Kalkile kantite kob POTANSYÈL pou touche
  /// 
  /// Sa a se kob ou ta touche si tout match yo korek.
  /// Itilize sa a pou montre kob potansyèl lè tikè a an kou.
  /// gain = stake × total_odds
  double calculatePotentialWinnings() {
    return betAmount * odds;
  }

  /// Kreye yon nouvo tikè ak rezilta kalkile yo
  BetTicketModel withCalculatedResults() {
    final newSelections = selections?.map((sel) {
      return sel; // Seleksyon yo deja gen skò, rezilta kalkile nan calculateResult()
    }).toList();

    final newStatus = calculateOverallStatus();
    return BetTicketModel(
      id: id,
      team1: team1,
      team2: team2,
      odds: odds,
      betAmount: betAmount,
      possibleWin: possibleWin,
      status: newStatus,
      selections: newSelections,
      createdAt: createdAt,
    );
  }

  /// Kreye yon nouvo tikè ak skò SIMILE pou tout seleksyon yo (pou tès)
  /// Itilize sa a lè API a pa bay done reyèl
  BetTicketModel withSimulatedResults() {
    final newSelections = selections?.map((sel) {
      return sel.withSimulatedScore();
    }).toList();

    final newStatus = calculateOverallStatus();
    return BetTicketModel(
      id: id,
      team1: team1,
      team2: team2,
      odds: odds,
      betAmount: betAmount,
      possibleWin: possibleWin,
      status: newStatus,
      selections: newSelections,
      createdAt: createdAt,
    );
  }

  /// Kreye yon nouvo tikè ki itilize skò REÈL si disponib, sinon SIMILE
  /// Sa a se metod prensipal la pou jwenn rezilta tikè a
  BetTicketModel withRealOrSimulatedResults() {
    final newSelections = selections?.map((sel) {
      // Eseye jwenn skò reyèl nan API a
      // Pou kounye a, nou poko gen API konkrè, se similasyon nou ap itilize
      // Lè API a pare, chanje li pou pase skò reyèl la
      return sel.withSimulatedScore();
    }).toList();

    final newStatus = calculateOverallStatus();
    return BetTicketModel(
      id: id,
      team1: team1,
      team2: team2,
      odds: odds,
      betAmount: betAmount,
      possibleWin: possibleWin,
      status: newStatus,
      selections: newSelections,
      createdAt: createdAt,
    );
  }
}

enum BetTicketStatus {
  pending, // An kou
  won,    // Genyen
  lost,   // Pè
}

extension BetTicketStatusExtension on BetTicketStatus {
  String get label {
    switch (this) {
      case BetTicketStatus.pending:
        return 'An kou';
      case BetTicketStatus.won:
        return 'Genyen';
      case BetTicketStatus.lost:
        return 'Pè';
    }
  }
}
