import 'package:flutter/material.dart';

/// A reusable widget that provides a checkbox to toggle stock filter.
class StockFilterCheckbox extends StatelessWidget {
  final bool showInStockOnly;
  final ValueChanged<bool> onChanged;

  const StockFilterCheckbox({
    super.key,
    required this.showInStockOnly,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: showInStockOnly,
            activeColor: Colors.indigo,
            onChanged: (value) => onChanged(value ?? false),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => onChanged(!showInStockOnly),
          child: Text(
            'In stock only',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

