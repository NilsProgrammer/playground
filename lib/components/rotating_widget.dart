import 'package:flutter/material.dart';

class RotatingWidget extends StatefulWidget {
  final Widget? child;

  const RotatingWidget({
    Key? key,
    this.child
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends State<RotatingWidget> with TickerProviderStateMixin{
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
      child: widget.child
    );
  }
}