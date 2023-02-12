import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmerEffectUI extends StatelessWidget {
  final double width;
  final double height;
  final Color? baseColor;
  final Color? highlightColor;
  final ShapeBorder shapeBorder;
  final int? seconds;

  const MyShimmerEffectUI.rectangular({
    this.width = double.infinity,
    required this.height,
    this.baseColor,
    this.highlightColor,
    this.seconds,
  }) : this.shapeBorder = const RoundedRectangleBorder();

  const MyShimmerEffectUI.circular(
      {this.width = double.infinity,
      required this.height,
      this.baseColor,
      this.highlightColor,
      this.seconds})
      : this.shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: baseColor ?? Colors.grey.shade100,
        highlightColor: highlightColor ?? Colors.grey.shade300,
        period: Duration(seconds: seconds ?? 2),
        child: Container(
           width: 100,
           height: height,
          decoration: ShapeDecoration(
            color: Colors.grey,
            shape: shapeBorder,
          ),
        ),
      );
}
