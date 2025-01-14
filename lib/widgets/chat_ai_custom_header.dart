import 'dart:math' as math;
import 'package:flutter/material.dart';

class ImageAnimateRotate extends StatefulWidget {
  final Widget child;
  const ImageAnimateRotate({Key? key, required this.child}) : super(key: key);

  @override
  State<ImageAnimateRotate> createState() => _ImageAnimateRotateState();
}

class _ImageAnimateRotateState extends State<ImageAnimateRotate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
