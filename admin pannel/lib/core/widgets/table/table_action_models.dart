import 'package:flutter/material.dart';

class TableBulkAction {
  final String label;
  final IconData icon;
  final Function(List<dynamic> selectedItems) onAction;
  final bool isDestructive;

  const TableBulkAction({
    required this.label,
    required this.icon,
    required this.onAction,
    this.isDestructive = false,
  });
}

class TableRowAction<T> {
  final String label;
  final IconData icon;
  final Function(T item) onAction;
  final bool isDestructive;

  const TableRowAction({
    required this.label,
    required this.icon,
    required this.onAction,
    this.isDestructive = false,
  });
}
