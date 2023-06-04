import 'package:flutter/material.dart';
import 'package:yolo_movies_app/services/size_config.dart';

// Widget to show a capsule shaped badge with given label.
class CustomBadge extends StatelessWidget {
  final String? label;
  final Color? backgroundColor;

  const CustomBadge({
    this.backgroundColor,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (label == null) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.withWidthFactor,
        vertical: 4.withHeightFactor,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade600,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        label!,
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}
