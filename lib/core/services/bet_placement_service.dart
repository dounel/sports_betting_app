import 'dart:math';

import 'package:sports_betting_app/core/services/auth_service.dart';
import 'package:sports_betting_app/shared/models/bet_slip_item.dart';
import 'package:sports_betting_app/shared/models/bet_ticket_model.dart';

enum BetPlacementStatus {
  success,
  notLoggedIn,
  insufficientBalance,
  invalidStake,
  emptySlip,
}

class BetPlacementResult {
  final BetPlacementStatus status;
  final String message;

  const BetPlacementResult({
    required this.status,
    required this.message,
  });
}

class BetPlacementService {
  BetPlacementService._();

  static Future<BetPlacementResult> placeBet({
    required List<BetSlipItem> items,
    required double stake,
  }) async {
    if (items.isEmpty) {
      return const BetPlacementResult(
        status: BetPlacementStatus.emptySlip,
        message: 'Chwazi cote pou ajoute nan bet slip',
      );
    }
    if (stake <= 0) {
      return const BetPlacementResult(
        status: BetPlacementStatus.invalidStake,
        message: 'Mete yon montan ki pi gran pase 0.',
      );
    }

    final email = await AuthService.getCurrentUser();
    if (email == null || email.isEmpty) {
      return const BetPlacementResult(
        status: BetPlacementStatus.notLoggedIn,
        message: 'Konekte pou w ka plase yon pari.',
      );
    }

    final balance = await AuthService.getBalance();
    if (balance < stake) {
      return BetPlacementResult(
        status: BetPlacementStatus.insufficientBalance,
        message:
            'Ou pa gen ase kob sou kont ou. Balans: ${balance.toStringAsFixed(0)} HTG.',
      );
    }

    double totalOdds = 1;
    for (final item in items) {
      totalOdds *= item.odd.value;
    }

    final first = items.first;
    final possibleWin = stake * totalOdds;
    final now = DateTime.now();
    final ticketId = 'ticket_${now.millisecondsSinceEpoch}';

    final selections = items
        .map((item) {
          String betLabel = item.odd.label;
          if (betLabel == '1') betLabel = 'V1';
          if (betLabel == '2') betLabel = 'V2';

          // Eseye parse skò reyèl match la si disponib
          int? team1Score;
          int? team2Score;
          bool isSimulated = false;
          String matchStatus = 'NS';

          if (item.match.score != null && item.match.score!.isNotEmpty) {
            try {
              final cleaned = item.match.score!.replaceAll(' ', '');
              final parts = cleaned.split('-');
              if (parts.length == 2) {
                team1Score = int.tryParse(parts[0]);
                team2Score = int.tryParse(parts[1]);
              }
            } catch (_) {
              // Si gen ere, kite skò yo null
            }
          }

          // Si pa gen skò reyèl, jenere yon skò simile pou tès
          if (team1Score == null || team2Score == null) {
            final random = Random();
            team1Score = random.nextInt(6); // 0-5 gòl
            team2Score = random.nextInt(6); // 0-5 gòl
            isSimulated = true;
            matchStatus = 'FT'; // Simile tankou match fini
          } else {
            // Si gen skò reyèl, detèmine estati match la
            if (item.match.isLive) {
              matchStatus = 'LIVE';
            } else {
              matchStatus = 'FT';
            }
          }

          // Kalkile rezilta imedyatman ak skò a
          BetTicketStatus selectionStatus = BetTicketStatus.pending;
          final isHomeWin = team1Score > team2Score;
          final isDraw = team1Score == team2Score;
          final isAwayWin = team1Score < team2Score;

          final normalizedLabel = betLabel.toUpperCase().trim();
          if (normalizedLabel == 'V1' || normalizedLabel == '1') {
            selectionStatus = isHomeWin ? BetTicketStatus.won : BetTicketStatus.lost;
          } else if (normalizedLabel == 'X') {
            selectionStatus = isDraw ? BetTicketStatus.won : BetTicketStatus.lost;
          } else if (normalizedLabel == 'V2' || normalizedLabel == '2') {
            selectionStatus = isAwayWin ? BetTicketStatus.won : BetTicketStatus.lost;
          }

          return BetTicketSelection(
            league: item.match.league,
            team1: item.match.team1,
            team2: item.match.team2,
            betLabel: betLabel,
            odds: item.odd.value,
            team1Score: team1Score,
            team2Score: team2Score,
            matchStatus: matchStatus,
            isSimulated: isSimulated,
            result: selectionStatus,
          );
        })
        .toList();

    final ticket = BetTicketModel(
      id: ticketId,
      team1: first.match.team1,
      team2: first.match.team2,
      odds: totalOdds,
      betAmount: stake,
      possibleWin: possibleWin,
      status: BetTicketStatus.pending,
      selections: selections,
      createdAt: now,
    );

    await AuthService.addBetTicket(ticket);
    await AuthService.setBalance(balance - stake);

    return BetPlacementResult(
      status: BetPlacementStatus.success,
      message:
          'Pari plase! Gade nan seksyon Pari. ${items.length} match, ${stake.toStringAsFixed(0)} HTG',
    );
  }
}
