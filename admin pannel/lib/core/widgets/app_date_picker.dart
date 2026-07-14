import 'package:flutter/material.dart';

class AppDatePicker extends StatelessWidget {
  final String? label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;

  const AppDatePicker({
    super.key,
    this.label,
    this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final text = selectedDate != null 
        ? "\${selectedDate!.year}-\${selectedDate!.month.toString().padLeft(2, '0')}-\${selectedDate!.day.toString().padLeft(2, '0')}"
        : "Select Date";

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today, size: 20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selectedDate != null ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
