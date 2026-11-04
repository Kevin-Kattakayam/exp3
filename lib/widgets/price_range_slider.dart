import 'package:flutter/material.dart';

/// A reusable widget that shows a price range slider for filtering.
class PriceRangeSlider extends StatelessWidget {
  final RangeValues currentRange;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  const PriceRangeSlider({
    super.key,
    required this.currentRange,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Price Range',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '\$${currentRange.start.toStringAsFixed(0)} – \$${currentRange.end.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[700],
              ),
            ),
          ],
        ),
        RangeSlider(
          values: currentRange,
          min: min,
          max: max,
          divisions: ((max - min) / 5).round(),
          activeColor: Colors.indigo,
          labels: RangeLabels(
            '\$${currentRange.start.toStringAsFixed(0)}',
            '\$${currentRange.end.toStringAsFixed(0)}',
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

