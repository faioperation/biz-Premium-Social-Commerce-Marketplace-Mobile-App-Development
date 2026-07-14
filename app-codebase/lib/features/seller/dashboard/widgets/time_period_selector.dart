import 'package:flutter/material.dart';

class TimePeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onChanged;

  const TimePeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final periods = ['7 Days', '30 Days', '90 Days'];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: periods.map((period) {
        final isSelected = period == selectedPeriod;
        return Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: () => onChanged(period),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : (isDark ? const Color(0xFF1E1E2A) : Colors.transparent),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : (isDark ? const Color(0xFF2A2A3C) : Colors.transparent),
                ),
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
