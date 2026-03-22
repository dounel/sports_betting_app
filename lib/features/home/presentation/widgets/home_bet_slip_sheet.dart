import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';
import 'package:sports_betting_app/shared/models/match_model.dart';

class HomeBetSlipSheet extends StatefulWidget {
  final MatchModel match;
  final String? initialLabel;
  final double? initialValue;
  final List<double> fullTimeOdds;

  const HomeBetSlipSheet({
    super.key,
    required this.match,
    required this.initialLabel,
    required this.initialValue,
    required this.fullTimeOdds,
  });

  @override
  State<HomeBetSlipSheet> createState() => _HomeBetSlipSheetState();
}

class _HomeBetSlipSheetState extends State<HomeBetSlipSheet> {
  String? _selectedLabel;
  double? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedLabel = widget.initialLabel;
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      decoration: const BoxDecoration(
        color: AppConstants.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '${widget.match.team1} vs ${widget.match.team2}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _selectedLabel == null || _selectedValue == null
                    ? 'Selected bet: Pa gen seleksyon'
                    : 'Selected bet: $_selectedLabel ${_selectedValue!.toStringAsFixed(2)}',
                style: TextStyle(
                  color: _selectedLabel == null
                      ? Colors.white54
                      : AppConstants.primaryGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              _marketTitle('Full Time Result'),
              const SizedBox(height: 8),
              _optionRow([
                _SheetOption('V1', widget.fullTimeOdds[0]),
                _SheetOption('X', widget.fullTimeOdds[1]),
                _SheetOption('V2', widget.fullTimeOdds[2]),
              ]),
              const SizedBox(height: 14),
              _marketTitle('Goals Market'),
              const SizedBox(height: 8),
              _optionRow([
                _SheetOption('Over 0.5', (_selectedValue ?? 1.00) + 0.12),
                _SheetOption('Over 1.5', (_selectedValue ?? 1.00) + 0.38),
                _SheetOption('Over 2.5', (_selectedValue ?? 1.00) + 0.77),
              ]),
              const SizedBox(height: 14),
              _marketTitle('First Half Winner'),
              const SizedBox(height: 8),
              _optionRow([
                _SheetOption('V1', widget.fullTimeOdds[0] + 0.34),
                _SheetOption('X', widget.fullTimeOdds[1] - 0.25),
                _SheetOption('V2', widget.fullTimeOdds[2] + 0.41),
              ]),
              const SizedBox(height: 14),
              _marketTitle('Both Teams To Score'),
              const SizedBox(height: 8),
              _optionRow([
                _SheetOption('Yes', (_selectedValue ?? 1.00) - 0.14),
                _SheetOption('No', (_selectedValue ?? 1.00) + 0.19),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _marketTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _optionRow(List<_SheetOption> options) {
    return Row(
      children: options
          .map(
            (option) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _OptionButton(
                  option: option,
                  selected: _selectedLabel != null &&
                      _selectedValue != null &&
                      option.label == _selectedLabel &&
                      (option.value - _selectedValue!).abs() < 0.001,
                  onTap: () {
                    setState(() {
                      _selectedLabel = option.label;
                      _selectedValue = option.value;
                    });
                  },
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SheetOption {
  final String label;
  final double value;

  const _SheetOption(this.label, this.value);
}

class _OptionButton extends StatelessWidget {
  final _SheetOption option;
  final bool selected;
  final VoidCallback onTap;

  const _OptionButton({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppConstants.primaryGreen.withOpacity(0.22)
          : AppConstants.darkBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Column(
            children: [
              Text(
                option.label,
                style: TextStyle(
                  color: selected ? AppConstants.primaryGreen : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                option.value.toStringAsFixed(2),
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
