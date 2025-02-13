import 'package:flutter/widgets.dart';

BorderRadius buildBorderRadius(
  double? topBorderRadius,
  double? bottomBorderRadius,
  double? topBorderLeftRadius,
  double? topBorderRightRadius,
  double? bottomBorderLeftRadius,
  double? bottomBorderRightRadius,
  double borderRadius,
) {
  return BorderRadius.only(
    topLeft: Radius.circular(topBorderRadius ?? topBorderLeftRadius ?? borderRadius),
    topRight: Radius.circular(topBorderRadius ?? topBorderRightRadius ?? borderRadius),
    bottomLeft: Radius.circular(bottomBorderRadius ?? bottomBorderLeftRadius ?? borderRadius),
    bottomRight: Radius.circular(bottomBorderRadius ?? bottomBorderRightRadius ?? borderRadius),
  );
}
