import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/core/services/bet_placement_service.dart';
import 'package:sports_betting_app/features/bet/presentation/widgets/bet_slip_panel.dart';
import 'package:sports_betting_app/shared/models/bet_slip_item.dart';
import 'package:sports_betting_app/shared/models/match_model.dart';
import 'package:sports_betting_app/shared/models/odd_model.dart';

class MatchDetailsPage extends StatefulWidget {
  final MatchModel match;
  final List<BetSlipItem> betSlipItems;
  final ValueNotifier<int> betSlipVersion;
  final void Function(MatchModel match, OddModel odd) onOddSelected;
  final String? Function(String matchId) selectedOddForMatch;
  final double stake;
  final TextEditingController stakeController;
  final void Function(double) onStakeChanged;
  final Future<void> Function() onPlaceBet;
  final VoidCallback? onBetPlaced;

  const MatchDetailsPage({
    super.key,
    required this.match,
    required this.betSlipItems,
    required this.betSlipVersion,
    required this.onOddSelected,
    required this.selectedOddForMatch,
    required this.stake,
    required this.stakeController,
    required this.onStakeChanged,
    required this.onPlaceBet,
    this.onBetPlaced,
  });

  @override
  State<MatchDetailsPage> createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  double get _totalOdds {
    if (widget.betSlipItems.isEmpty) return 0;
    double product = 1;
    for (final item in widget.betSlipItems) {
      product *= item.odd.value;
    }
    return product;
  }

  void _openExpandedBetSlip() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.25,
        maxChildSize: 0.9,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: StatefulBuilder(
            builder: (modalCtx, setModalState) {
              return Container(
                decoration: BoxDecoration(
                  color: AppConstants.cardBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: BetSlipPanel(
                  items: widget.betSlipItems,
                  stake: widget.stake,
                  stakeController: widget.stakeController,
                  onStakeChanged: (v) {
                    setModalState(() {});
                    widget.onStakeChanged(v);
                  },
                  onPlaceBet: () async {
                    Navigator.pop(ctx);
                    await widget.onPlaceBet();
                  },
                  onRemoveItem: () {},
                  onRemoveItemAt: (item) {
                    widget.betSlipItems.remove(item);
                    widget.betSlipVersion.value++;
                    setModalState(() {});
                    if (widget.betSlipItems.isEmpty) Navigator.pop(ctx);
                  },
                  onClose: () => Navigator.pop(ctx),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _selectOdd(String label, double value) {
    widget.onOddSelected(widget.match, OddModel(label: label, value: value));
    widget.betSlipVersion.value++;
  }

  bool _isSelected(String label) => widget.selectedOddForMatch(widget.match.id) == label;

  @override
  Widget build(BuildContext context) {
    final baseOdds = [3.27, 3.83, 2.12];

    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: widget.betSlipVersion,
              builder: (_, __, ___) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                    child: Text(
                      '${widget.match.team1} vs ${widget.match.team2}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                      const SizedBox(height: 24),
                      _buildMarket('Full Time Result', [
                        _OddOption('V1', baseOdds[0]),
                        _OddOption('X', baseOdds[1]),
                          _OddOption('V2', baseOdds[2]),
                      ]),
                      _buildMarket('Goals', [
                        _OddOption('Over 0.5', 1.12),
                        _OddOption('Under 0.5', 6.50),
                        _OddOption('Over 1.5', 1.45),
                        _OddOption('Under 1.5', 2.65),
                        _OddOption('Over 2.5', 1.90),
                        _OddOption('Under 2.5', 1.95),
                        _OddOption('Over 3.5', 2.70),
                          _OddOption('Under 3.5', 1.45),
                      ]),
                      _buildMarket('First Half Winner', [
                        _OddOption('FH V1', baseOdds[0] + 0.34),
                        _OddOption('FH X', baseOdds[1] - 0.25),
                          _OddOption('FH V2', baseOdds[2] + 0.41),
                      ]),
                      _buildMarket('Second Half Winner', [
                        _OddOption('SH V1', baseOdds[0] + 0.28),
                        _OddOption('SH X', baseOdds[1] - 0.20),
                          _OddOption('SH V2', baseOdds[2] + 0.35),
                      ]),
                      _buildMarket('Both Teams To Score', [
                        _OddOption('BTTS Yes', 1.75),
                          _OddOption('BTTS No', 2.10),
                      ]),
                      _buildMarket('Double Chance', [
                        _OddOption('DC 1X', 1.45),
                        _OddOption('DC 12', 1.25),
                          _OddOption('DC X2', 1.55),
                      ]),
                      _buildMarket('Total Corners', [
                        _OddOption('Corners O7.5', 1.90),
                        _OddOption('Corners U7.5', 1.95),
                      ]),
                      _buildMarket('First Half Goals', [
                        _OddOption('FH Over 0.5', 1.25),
                        _OddOption('FH Under 0.5', 3.80),
                        _OddOption('FH Over 1.5', 1.95),
                        _OddOption('FH Under 1.5', 1.90),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: widget.betSlipVersion,
            builder: (_, __, ___) {
              if (widget.betSlipItems.isEmpty) return const SizedBox.shrink();
              return SafeArea(
                top: false,
                child: Material(
                  color: AppConstants.cardBg,
                  child: InkWell(
                    onTap: _openExpandedBetSlip,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppConstants.cardBg,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bet Slip (${widget.betSlipItems.length})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Total Odds ${_totalOdds.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppConstants.primaryGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMarket(String title, List<_OddOption> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((o) => _buildOddButton(o.label, o.value)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOddButton(String label, double value) {
    final selected = _isSelected(label);
    return Material(
      color: selected
          ? AppConstants.primaryGreen.withOpacity(0.35)
          : AppConstants.cardBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => _selectOdd(label, value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: selected
                ? Border.all(color: AppConstants.primaryGreen, width: 2)
                : Border.all(color: Colors.white12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppConstants.primaryGreen : Colors.white70,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.toStringAsFixed(2),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OddOption {
  final String label;
  final double value;
  const _OddOption(this.label, this.value);
}
