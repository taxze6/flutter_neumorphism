import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StyleListController extends StatelessWidget {
  final String leading;
  final double min;
  final double max;
  final double value;
  final String trailing;
  final Function(double) onChanged;
  final Color lineColor;

  const StyleListController({
    super.key,
    required this.leading,
    required this.min,
    required this.max,
    required this.value,
    required this.trailing,
    required this.onChanged,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        leading,
        style: const TextStyle(color: Colors.white),
      ),
      title: Slider(
        min: min,
        max: max,
        value: value,
        label: value.toString(),
        activeColor: lineColor,
        inactiveColor: Colors.white70,
        onChanged: onChanged,
      ),
      trailing: Text(
        trailing,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
