import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/core/theme/app_palette.dart';

class PriceFilterSection extends StatefulWidget {
  final double min;
  final double max;
  final Function(double start, double end) onChanged;

  const PriceFilterSection({
    super.key,
    this.min = 0,
    this.max = 20,
    required this.onChanged,
  });

  @override
  State<PriceFilterSection> createState() => _PriceFilterSectionState();
}

class _PriceFilterSectionState extends State<PriceFilterSection> {
  late RangeValues priceRange;

  @override
  void initState() {
    super.initState();
    priceRange = RangeValues(widget.min, widget.min);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "price_range".tr,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: width * 0.02),
        RangeSlider(
          values: priceRange,
          min: widget.min,
          max: widget.max,
          divisions: 10,
          activeColor: AppPalette.primary,
          inactiveColor: Colors.grey[300],
          labels: RangeLabels(
            "${priceRange.start.round()}",
            "${priceRange.end.round()}",
          ),
          onChanged: (values) {
            setState(() => priceRange = values);
            widget.onChanged(values.start, values.end);
          },
        ),
        SizedBox(height: width * 0.01),
        Row(
          children: [
            Expanded(child: priceBox("min".tr, priceRange.start)),
            SizedBox(width: width * 0.04),
            Expanded(child: priceBox("max".tr, priceRange.end)),
          ],
        ),
      ],
    );
  }

  Widget priceBox(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            color: Theme.of(context).cardColor,
          ),
          child: Text(
            "\$${value.round()}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
