import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/core/services/bet_placement_service.dart';
import 'package:sports_betting_app/features/bet/presentation/widgets/bet_slip_panel.dart';
import 'package:sports_betting_app/shared/models/bet_slip_item.dart';
import 'package:sports_betting_app/shared/models/match_model.dart';
import 'package:sports_betting_app/shared/models/odd_model.dart';

Future<void> showHomeBetSlipUsingBetPanel({
  required BuildContext context,
  required MatchModel match,
  required List<double> fullTimeOdds,
  required String? selectedLabel,
  required VoidCallback? onBetPlaced,
}) async {
  final stakeController = TextEditingController();
  double stake = 0;

  final items = <BetSlipItem>[];
  if (selectedLabel != null) {
    final value = selectedLabel == 'V1'
        ? fullTimeOdds[0]
        : selectedLabel == 'X'
            ? fullTimeOdds[1]
            : fullTimeOdds[2];
    items.add(
      BetSlipItem(
        match: match,
        odd: OddModel(label: selectedLabel, value: value),
      ),
    );
  }

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      builder: (_, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: StatefulBuilder(
          builder: (modalContext, setModalState) {
            return BetSlipPanel(
              items: items,
              stake: stake,
              stakeController: stakeController,
              onStakeChanged: (v) {
                setModalState(() => stake = v);
              },
              onPlaceBet: () async {
                final result = await BetPlacementService.placeBet(
                  items: items,
                  stake: stake,
                );
                if (!ctx.mounted) return;

                switch (result.status) {
                  case BetPlacementStatus.success:
                    onBetPlaced?.call();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.message),
                        backgroundColor: AppConstants.primaryGreen,
                      ),
                    );
                    break;
                  case BetPlacementStatus.notLoggedIn:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.message),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    break;
                  case BetPlacementStatus.insufficientBalance:
                  case BetPlacementStatus.invalidStake:
                  case BetPlacementStatus.emptySlip:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                    break;
                }
              },
              onRemoveItem: () {},
              onRemoveItemAt: (item) {
                items.remove(item);
                setModalState(() {});
              },
            );
          },
        ),
      ),
    ),
  ).whenComplete(stakeController.dispose);
}
