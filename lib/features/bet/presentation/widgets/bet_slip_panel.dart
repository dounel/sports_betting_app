import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/shared/models/bet_slip_item.dart';

class BetSlipPanel extends StatelessWidget {
  final List<BetSlipItem> items;
  final double stake;
  final TextEditingController stakeController;
  final ValueChanged<double> onStakeChanged;
  final VoidCallback onPlaceBet;
  final VoidCallback onRemoveItem;
  final Function(BetSlipItem) onRemoveItemAt;
  final VoidCallback? onClose;

  const BetSlipPanel({
    super.key,
    required this.items,
    required this.stake,
    required this.stakeController,
    required this.onStakeChanged,
    required this.onPlaceBet,
    required this.onRemoveItem,
    required this.onRemoveItemAt,
    this.onClose,
  });

  double get totalOdds {
    if (items.isEmpty) return 0;
    double product = 1;
    for (final item in items) {
      product *= item.odd.value;
    }
    return product;
  }

  double get potentialWin => stake * totalOdds;
  double get potentialProfit => stake > 0 ? (stake * (totalOdds - 1)) : 0;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppConstants.cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bet slip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${items.length} pari',
                      style: const TextStyle(color: Colors.white54),
                    ),
                    if (onClose != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onClose,
                        icon: const Icon(Icons.close, color: Colors.white54, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Chwazi yon cote pou ajoute nan bet slip',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bet slip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${items.length} pari',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  if (onClose != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close, color: Colors.white54, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.match.team1} vs ${item.match.team2}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${item.odd.label} @ ${item.odd.value.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppConstants.primaryGreen,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                      onPressed: () => onRemoveItemAt(item),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              )),
          const Divider(color: Colors.white24, height: 24),
          Row(
            children: [
              const Text('Total cote:', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              Text(
                totalOdds.toStringAsFixed(2),
                style: const TextStyle(
                  color: AppConstants.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: stakeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Montan (HTG)',
              labelStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: AppConstants.darkBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixText: 'HTG ',
              prefixStyle: const TextStyle(color: AppConstants.primaryGreen),
            ),
            onChanged: (v) {
              final cleaned = v.trim();
              if (cleaned.isEmpty) {
                onStakeChanged(0);
                return;
              }
              final n = double.tryParse(cleaned.replaceAll(',', '.')) ?? 0;
              onStakeChanged(n);
            },
          ),
          const SizedBox(height: 8),
          Text(
            stake > 0
                ? 'Ou ap resevwa (total): ${potentialWin.toStringAsFixed(0)} HTG'
                : 'Ou ap resevwa (total): — (mete montan an)',
            style: TextStyle(
              color: stake > 0 ? AppConstants.primaryGreen : Colors.white54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stake > 0
                ? 'Pwofi (sa w ap fè): ${potentialProfit.toStringAsFixed(0)} HTG'
                : 'Pwofi (sa w ap fè): —',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: items.isNotEmpty ? onPlaceBet : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Plase pari'),
            ),
          ),
        ],
      ),
    );
  }
}
