import 'package:flutter/material.dart';
import 'package:bluesky_project/utils/constants.dart';

class BorderIcon extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double width, height;
  final Color color;

  const BorderIcon(
      {Key key,
      @required this.child,
      this.padding,
      this.width,
      this.height,
      this.color,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(color: purpleColor.withAlpha(50), width: 2)),
        padding: padding ?? const EdgeInsets.all(12.0),
        child: Center(child: child)
    );
  }
}
