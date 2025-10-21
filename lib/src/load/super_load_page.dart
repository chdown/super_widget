import 'dart:async';

import 'package:flutter/widgets.dart';

/// 缺省页View需要混入的类
/// 仅支持混入[Widget]
mixin SuperLoadPage on Widget {
  /// 点击事件
  FutureOr Function(Map<String, String>? params)? onTap;

  /// 自定义参数
  Map<String, dynamic>? params;

  /// 快速创建一个缺省页
  static SuperLoadPage fast(Widget child) {
    return _LoadPage(child: child);
  }

  /// 快速创建一个List缺省页
  static SuperLoadPage fastList(Widget child, {Widget Function(Widget widget)? childBuilder, int itemCount = 10, bool shrinkWrap = true}) {
    Widget widget = ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: (context, index) => child,
    );
    return _LoadPage(
      child: childBuilder == null ? widget : childBuilder.call(widget),
    );
  }
}

@immutable
class _LoadPage extends StatelessWidget with SuperLoadPage {
  final Widget child;

  _LoadPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
