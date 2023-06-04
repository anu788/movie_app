import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Widget to display shimmer effect on top of any widget
class ShimmerWidget extends StatelessWidget {
  final Widget child;
  const ShimmerWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: child,
    );
  }
}
