library super_widget;

import 'dart:async';
import 'dart:ui';

class SuperWidgetConfig {
  SuperWidgetConfig._();

  /// 按钮默认色
  static Color btnDefTextColor = const Color(0xFF333333);

  /// 按钮默认加粗设置
  static FontWeight? btnDefTextWeight;

  /// 按钮默认圆角
  static double btnBorderRadius = 6;

  /// 防重复点击
  static Function()? Function(Function()? onTap, int milliseconds) onDebounceTap = (onTap, milliseconds) {
    if (onTap == null) return null;
    Timer? debounceTimer;
    return () {
      if (debounceTimer == null || !debounceTimer!.isActive) {
        onTap();
        debounceTimer = Timer(Duration(milliseconds: milliseconds), () => debounceTimer?.cancel());
      } else {
        debounceTimer = Timer(Duration(milliseconds: milliseconds), () => debounceTimer?.cancel());
      }
    };
  };
}
