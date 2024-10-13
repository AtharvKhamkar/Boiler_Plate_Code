import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget child;

  const ResponsiveWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.isTablet ? 100 : 0),
          child: child,
        );
      },
    );
  }
}
