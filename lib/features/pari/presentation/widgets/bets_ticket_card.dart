import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/shared/models/bet_ticket_model.dart';

/// Kat tikè pwofesyonèl ki sanble yon bilè pari, gen ekspansyon pou detay match.
class BetsTicketCard extends StatefulWidget {
  final BetTicketModel ticket;
  final bool isActive;

  const BetsTicketCard({
    super.key,
    required this.ticket,
    required this.isActive,
  });

  @override
  State<BetsTicketCard> createState() => _BetsTicketCardState();
}

class _BetsTicketCardState extends State<BetsTicketCard> {
  bool _expanded = false;

  static String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    final d = '${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}';
    final t = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$d | $t';
  }

  static String _month(int m) {
    const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    // Kalkile rezilta ak skò simile oswa reyèl
    final calculatedTicket = ticket.withRealOrSimulatedResults();
    
    // Si calculatedTicket null, retounen yon placeholder
    if (calculatedTicket.selections == null || calculatedTicket.selections!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final actualStatus = calculatedTicket.calculateOverallStatus();
    final actualWinnings = calculatedTicket.calculateActualWinnings();
    final potentialWinnings = calculatedTicket.calculatePotentialWinnings();

    final leftLabel = 'Combiné';
    final rightLabel = actualStatus == BetTicketStatus.pending
        ? 'En cours'
        : actualStatus == BetTicketStatus.won
            ? 'Gagné'
            : 'Perdu';
    final statusColor = actualStatus == BetTicketStatus.pending
        ? Colors.amber
        : actualStatus == BetTicketStatus.won
            ? AppConstants.primaryGreen
            : Colors.red.shade400;

    // Montre kob potansyèl pou tikè an kou, kob reyèl pou tikè fini
    final isPending = actualStatus == BetTicketStatus.pending;
    final displayAmount = isPending ? potentialWinnings : actualWinnings;
    final amountLabel = isPending ? 'Gain potentiel' : 'Résultat';
    final amountColor = actualStatus == BetTicketStatus.won
        ? AppConstants.primaryGreen
        : actualStatus == BetTicketStatus.lost
            ? Colors.red.shade400
            : Colors.white70;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppConstants.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leftLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  rightLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: ${ticket.id.replaceAll('ticket_', '')}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatDate(ticket.createdAt),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Text(
                    'Détails du pari',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white54,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Cotes totales',
                  value: ticket.odds.toStringAsFixed(3),
                  valueColor: Colors.white70,
                ),
                const SizedBox(height: 6),
                _SummaryRow(
                  label: 'Mise totale',
                  value: '${ticket.betAmount.toStringAsFixed(0)} HTG',
                  valueColor: Colors.white70,
                ),
                const SizedBox(height: 6),
                _SummaryRow(
                  label: amountLabel,
                  value: '${displayAmount.toStringAsFixed(0)} HTG',
                  valueColor: amountColor,
                ),
              ],
            ),
          ),
          // Evite AnimatedCrossFade ki ka bay erè null removeChild
          // Itilize yon widget kondisyon senp
          if (_expanded)
            _ExpandedMatches(ticket: calculatedTicket)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryRow({
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
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ExpandedMatches extends StatelessWidget {
  final BetTicketModel ticket;

  const _ExpandedMatches({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final selections = ticket.displaySelections;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 14),
          ...selections.asMap().entries.map((entry) {
            final sel = entry.value;
            final isLast = entry.key == selections.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: _MatchCard(selection: sel),
            );
          }),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final BetTicketSelection selection;

  const _MatchCard({required this.selection});

  @override
  Widget build(BuildContext context) {
    // Kalkile estati seleksyon an
    final selectionStatus = selection.calculateResult();

    Color color;
    String resultLabel;
    String icon;

    switch (selectionStatus) {
      case BetTicketStatus.won:
        color = AppConstants.primaryGreen;
        resultLabel = 'Gagné';
        icon = '🟢';
        break;
      case BetTicketStatus.lost:
        color = Colors.red.shade400;
        resultLabel = 'Perdu';
        icon = '🔴';
        break;
      case BetTicketStatus.pending:
        color = Colors.amber;
        resultLabel = 'En cours';
        icon = '⏳';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selection.league.isEmpty ? '—' : selection.league,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$icon $resultLabel',
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${selection.team1} vs ${selection.team2}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Bet: ',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                selection.betLabel,
                style: const TextStyle(
                  color: AppConstants.primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Odds: ',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                selection.odds.toStringAsFixed(2),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(width: 16),
              Text(
                'Score: ',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                selection.scoreDisplay,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              if (selection.isSimulated) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'SIM',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
