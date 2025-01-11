library super_widget;

import 'dart:async';

class SuperWidgetConfig {
  /// 缺省页配置
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
