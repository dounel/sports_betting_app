import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/shared/models/bet_ticket_model.dart';

class BetDetailsPage extends StatelessWidget {
  final BetTicketModel ticket;

  const BetDetailsPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isFinished = ticket.status != BetTicketStatus.pending;

    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detay pari',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppConstants.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppConstants.primaryGreen.withOpacity(0.3),
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
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              _DetailRow(
                label: 'Skò',
                value: '—  —',
                valueColor: Colors.white70,
              ),
              const SizedBox(height: 12),
              _DetailRow(
                label: 'Pari',
                value: 'Cote ${ticket.odds.toStringAsFixed(2)}',
                valueColor: AppConstants.primaryGreen,
              ),
              const SizedBox(height: 12),
              _DetailRow(
                label: 'Rezilta',
                value: ticket.status == BetTicketStatus.pending
                    ? 'Ankou'
                    : ticket.status == BetTicketStatus.won
                        ? 'Genyen'
                        : 'Pè',
                valueColor: ticket.status == BetTicketStatus.pending
                    ? Colors.amber
                    : ticket.status == BetTicketStatus.won
                        ? AppConstants.primaryGreen
                        : Colors.red.shade400,
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Montan pari:',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  Text(
                    '${ticket.betAmount.toStringAsFixed(0)} HTG',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isFinished
                        ? (ticket.status == BetTicketStatus.won
                            ? 'Genyen:'
                            : 'Pè:')
                        : 'Posib genyen:',
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  Text(
                    isFinished
                        ? (ticket.status == BetTicketStatus.won
                            ? '${ticket.possibleWin.toStringAsFixed(0)} HTG'
                            : '0 HTG')
                        : '${ticket.possibleWin.toStringAsFixed(0)} HTG',
                    style: TextStyle(
                      color: ticket.status == BetTicketStatus.won
                          ? AppConstants.primaryGreen
                          : ticket.status == BetTicketStatus.lost
                              ? Colors.red.shade400
                              : AppConstants.primaryGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
