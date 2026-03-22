import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/shared/models/bet_ticket_model.dart';

class BetTicketCard extends StatelessWidget {
  final BetTicketModel ticket;

  const BetTicketCard({super.key, required this.ticket});

  Color _statusColor() {
    switch (ticket.status) {
      case BetTicketStatus.pending:
        return Colors.amber;
      case BetTicketStatus.won:
        return AppConstants.primaryGreen;
      case BetTicketStatus.lost:
        return Colors.red.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _statusColor().withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${ticket.team1} vs ${ticket.team2}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Odds:',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              Text(
                ticket.odds.toStringAsFixed(2),
                style: const TextStyle(
                  color: AppConstants.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pari:',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              Text(
                '${ticket.betAmount.toStringAsFixed(0)} HTG',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Posib genyen:',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              Text(
                '${ticket.possibleWin.toStringAsFixed(0)} HTG',
                style: const TextStyle(
                  color: AppConstants.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ticket.status.label,
                  style: TextStyle(
                    color: _statusColor(),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
