import 'package:flutter/material.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

class CustomSingleSlider extends StatefulWidget {
  final double min;
  final double max;
  final int divisions;
  final double initialValue;
  final Function(double) onChanged; // رقم واحد بس
  final Color activeColor;
  final Color? inactiveColor;
  final String Function(double)? labelFormatter;

  const CustomSingleSlider({
    super.key,
    required this.min,
    required this.max,
    required this.initialValue,
    required this.onChanged,
    this.divisions = 10,
    this.activeColor = AppPalette.primary,
    this.inactiveColor,
    this.labelFormatter,
  });

  @override
  State<CustomSingleSlider> createState() => _CustomSingleSliderState();
}

class _CustomSingleSliderState extends State<CustomSingleSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            // حجم الدائرة
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            trackHeight: 4,
          ),
          child: Slider(
            value: _currentValue,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            activeColor: widget.activeColor,
            inactiveColor: widget.inactiveColor ?? Colors.grey[300],
            onChanged: (value) {
              setState(() => _currentValue = value);
              widget.onChanged(value);
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.labelFormatter != null
              ? "${widget.labelFormatter!(_currentValue)} hours"
              : "${_currentValue.round()} hours",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}