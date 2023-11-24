import 'package:flutter/material.dart';

class RoundedBackground extends StatelessWidget {
  final double elevation;
  final double borderRadius;
  final Color? color;
  final LinearGradient? gradient;
  final double? width;
  final double? height;
  final Widget? child;

  const RoundedBackground({
    Key? key,
    this.elevation = 0,
    this.borderRadius = 50,
    this.color = const Color.fromARGB(255, 255, 255, 255),
    this.gradient,
    this.width,
    this.height,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      clipBehavior: Clip.antiAlias,
      color: color,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: gradient
        ),
        child: child
      ),
    );
  }
}