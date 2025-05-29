library super_widget;

import 'dart:ui';

class SuperWidgetConfig {
  SuperWidgetConfig._();

  /// 默认字体大小
  static double defaultTextSize = 14;

  /// 输入边框
  static Color etBorderColor = const Color(0xFFEDEDED);

  /// 按钮默认色
  static Color btnTextColor = const Color(0xFF333333);

  /// 按钮默认圆角
  static double btnBorderRadius = 6;

  /// 输入框是否默认有清除按钮
  static bool textFiledClear = false;

  /// 默认driverColor
  static Color driverColor = const Color(0xFFEDEDED);

  /// 防抖默认时间
  static int debounceTime = 500;
}
