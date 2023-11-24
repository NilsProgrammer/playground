import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playground/globals/style.dart';

class GradientCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final List<Color>? gradientColors;
  final double strokeWidth;

  const GradientCircularProgressIndicator({
    Key? key, 
    this.radius = 20,
    this.gradientColors,
    this.strokeWidth = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius),
      painter: GradientCircularProgressPainter(
        radius: radius,
        gradientColors: gradientColors ?? Style.gradient.colors,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double radius;
  List<Color> gradientColors;
  double strokeWidth;

  GradientCircularProgressPainter({
    this.radius = 10,
    this.gradientColors = const [Colors.white],
    this.strokeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    size = Size.fromRadius(radius);
    double offset = strokeWidth / 2;
    Rect rect = Offset(offset, offset) & Size(size.width - strokeWidth, size.height - strokeWidth);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    paint.shader =
        SweepGradient(
          colors: gradientColors, startAngle: 0.0, endAngle: 2 * pi
        )
            .createShader(rect);
    canvas.drawArc(rect, 0.0, 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}