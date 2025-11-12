import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:super_widget/src/widgets/triangle_painter.dart';

enum _ArrowDirection { top, bottom }

enum PopupPosition { auto, top, bottom }

class SuperPopup extends StatefulWidget {
  /// 锚点的全局 Key，用于获取目标组件的位置。如果为 null，则使用当前 context
  final GlobalKey? anchorKey;

  /// 弹窗内容
  final Widget content;

  /// 触发弹窗的目标组件
  final Widget child;

  /// 是否长按触发弹窗（true: 长按触发，false: 点击触发）
  final bool isLongPress;

  /// 箭头颜色
  final Color arrowColor;

  /// 屏幕遮挡层颜色。为 null 时使用默认半透明黑色
  final Color? barrierColor;

  /// 是否显示箭头指示器
  final bool showArrow;

  /// 内容内边距
  final EdgeInsets contentPadding;

  /// 内容背景颜色
  final Color contentBackgroundColor;

  /// 内容圆角。为 null 时使用默认 10
  final BorderRadiusGeometry? contentRadius;

  /// 内容装饰。优先级最高，如果设置则覆盖其他装饰配置
  final BoxDecoration? contentDecoration;

  /// 弹窗显示前的回调
  final VoidCallback? onBeforePopup;

  /// 弹窗关闭后的回调
  final VoidCallback? onAfterPopup;

  /// 是否使用根 Navigator。true 时弹窗会覆盖整个应用
  final bool rootNavigator;

  /// 弹窗显示位置（top: 目标上方，bottom: 目标下方，auto: 自动选择）
  final PopupPosition position;

  /// 动画持续时间
  final Duration animationDuration;

  /// 动画曲线
  final Curve animationCurve;

  /// 边缘阈值高度（固定像素值）。优先级高于 edgeThresholdRatio
  final double? edgeThresholdHeight;

  /// 边缘阈值比例（屏幕高度的比例，默认 0.2 即 1/5）。当目标接近屏幕边缘时调整弹窗位置
  final double edgeThresholdRatio;

  const SuperPopup({
    super.key,
    required this.content,
    required this.child,
    this.anchorKey,
    this.isLongPress = false,
    this.contentBackgroundColor = Colors.black,
    this.arrowColor = Colors.black,
    this.showArrow = true,
    this.barrierColor,
    this.contentPadding = const EdgeInsets.all(8),
    this.contentRadius,
    this.contentDecoration,
    this.onBeforePopup,
    this.onAfterPopup,
    this.rootNavigator = false,
    this.position = PopupPosition.auto,
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
    this.edgeThresholdHeight,
    this.edgeThresholdRatio = 0.2,
  });

  @override
  State<SuperPopup> createState() => SuperPopupState();
}

class SuperPopupState extends State<SuperPopup> {
  void show() {
    final anchor = widget.anchorKey?.currentContext ?? context;
    final renderBox = anchor.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final offset = renderBox.localToGlobal(renderBox.paintBounds.topLeft);

    widget.onBeforePopup?.call();

    Navigator.of(context, rootNavigator: widget.rootNavigator)
        .push(
          _PopupRoute(
            targetRect: offset & renderBox.paintBounds.size,
            backgroundColor: widget.contentBackgroundColor,
            arrowColor: widget.arrowColor,
            showArrow: widget.showArrow,
            barriersColor: widget.barrierColor,
            contentPadding: widget.contentPadding,
            contentRadius: widget.contentRadius,
            contentDecoration: widget.contentDecoration,
            position: widget.position,
            animationDuration: widget.animationDuration,
            animationCurve: widget.animationCurve,
            edgeThresholdHeight: widget.edgeThresholdHeight,
            edgeThresholdRatio: widget.edgeThresholdRatio,
            child: widget.content,
          ),
        )
        .then((value) => widget.onAfterPopup?.call());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: widget.isLongPress ? () => show() : null,
      onTapUp: !widget.isLongPress ? (_) => show() : null,
      child: widget.child,
    );
  }
}

class _PopupContent extends StatelessWidget {
  final Widget child;
  final GlobalKey childKey;
  final GlobalKey arrowKey;
  final _ArrowDirection arrowDirection;
  final double arrowHorizontal;
  final Color? backgroundColor;
  final Color arrowColor;
  final bool showArrow;
  final EdgeInsets contentPadding;
  final BorderRadiusGeometry? contentRadius;
  final BoxDecoration? contentDecoration;

  const _PopupContent({
    Key? key,
    required this.child,
    required this.childKey,
    required this.arrowKey,
    required this.arrowHorizontal,
    required this.showArrow,
    this.arrowDirection = _ArrowDirection.top,
    this.backgroundColor,
    required this.arrowColor,
    this.contentRadius,
    required this.contentPadding,
    this.contentDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          key: childKey,
          padding: contentPadding,
          margin: const EdgeInsets.symmetric(vertical: 10).copyWith(
            top: arrowDirection == _ArrowDirection.bottom ? 0 : null,
            bottom: arrowDirection == _ArrowDirection.top ? 0 : null,
          ),
          constraints: const BoxConstraints(minWidth: 50),
          decoration: contentDecoration ??
              BoxDecoration(
                color: backgroundColor ?? Colors.white,
                borderRadius: contentRadius ?? BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
          child: child,
        ),
        Positioned(
          top: arrowDirection == _ArrowDirection.top ? 2 : null,
          bottom: arrowDirection == _ArrowDirection.bottom ? 2 : null,
          left: arrowHorizontal,
          child: RotatedBox(
            key: arrowKey,
            quarterTurns: arrowDirection == _ArrowDirection.top ? 2 : 4,
            child: CustomPaint(
              size: showArrow ? const Size(16, 8) : Size.zero,
              painter: TrianglePainter(color: arrowColor),
            ),
          ),
        ),
      ],
    );
  }
}

class _PopupRoute extends PopupRoute<void> {
  final Rect targetRect;
  final PopupPosition position;
  final Widget child;
  final Duration animationDuration;
  final Curve animationCurve;
  final double? edgeThresholdHeight;
  final double edgeThresholdRatio;

  static const double _margin = 10;

  static MediaQueryData get mediaQuery => MediaQueryData.fromView(PlatformDispatcher.instance.views.first);
  static final Rect _viewportRect = Rect.fromLTWH(
    _margin,
    mediaQuery.padding.top + _margin,
    mediaQuery.size.width - _margin * 2,
    mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom - _margin * 2,
  );

  final GlobalKey _childKey = GlobalKey();
  final GlobalKey _arrowKey = GlobalKey();
  final Color backgroundColor;
  final Color arrowColor;
  final bool showArrow;
  final Color? barriersColor;
  final EdgeInsets contentPadding;
  final BorderRadiusGeometry? contentRadius;
  final BoxDecoration? contentDecoration;

  double _maxHeight = _viewportRect.height;
  _ArrowDirection _arrowDirection = _ArrowDirection.top;
  double _arrowHorizontal = 0;
  double _scaleAlignDx = 0.5;
  double _scaleAlignDy = 0.5;
  double? _bottom;
  double? _top;
  double? _left;
  double? _right;

  _PopupRoute({
    RouteSettings? settings,
    ImageFilter? filter,
    TraversalEdgeBehavior? traversalEdgeBehavior,
    required this.child,
    required this.targetRect,
    required this.backgroundColor,
    required this.arrowColor,
    required this.showArrow,
    this.barriersColor,
    required this.contentPadding,
    this.contentRadius,
    this.contentDecoration,
    this.position = PopupPosition.auto,
    required this.animationDuration,
    this.animationCurve = Curves.easeInOut,
    this.edgeThresholdHeight,
    this.edgeThresholdRatio = 0.2,
  }) : super(
          settings: settings,
          filter: filter,
          traversalEdgeBehavior: traversalEdgeBehavior,
        );

  @override
  Color? get barrierColor => barriersColor ?? Colors.black.withValues(alpha: 0.1);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Popup';

  @override
  TickerFuture didPush() {
    super.offstage = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final childRect = _getRect(_childKey);
      final arrowRect = _getRect(_arrowKey);
      _calculateArrowOffset(arrowRect, childRect);
      _calculateChildOffset(childRect);
      super.offstage = false;
    });
    return super.didPush();
  }

  Rect? _getRect(GlobalKey key) {
    final currentContext = key.currentContext;
    final renderBox = currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || currentContext == null) return null;
    final offset = renderBox.localToGlobal(renderBox.paintBounds.topLeft);
    var rect = offset & renderBox.paintBounds.size;

    if (Directionality.of(currentContext) == TextDirection.rtl) {
      rect = Rect.fromLTRB(0, rect.top, rect.right - rect.left, rect.bottom);
    }

    return rect;
  }

  // Calculate the horizontal position of the arrow
  void _calculateArrowOffset(Rect? arrowRect, Rect? childRect) {
    if (childRect == null || arrowRect == null) return;
    // Calculate the distance from the left side of the screen based on the middle position of the target and the popover layer
    var leftEdge = targetRect.center.dx - childRect.center.dx;
    final rightEdge = leftEdge + childRect.width;
    leftEdge = leftEdge < _viewportRect.left ? _viewportRect.left : leftEdge;
    // If it exceeds the screen, subtract the excess part
    if (rightEdge > _viewportRect.right) {
      leftEdge -= rightEdge - _viewportRect.right;
    }
    final center = targetRect.center.dx - leftEdge - arrowRect.center.dx;
    // Prevent the arrow from extending beyond the padding of the popover
    if (center + arrowRect.center.dx > childRect.width - 15) {
      _arrowHorizontal = center - 15;
    } else if (center < 15) {
      _arrowHorizontal = 15;
    } else {
      _arrowHorizontal = center;
    }

    _scaleAlignDx = (_arrowHorizontal + arrowRect.center.dx) / childRect.width;
  }

  // Calculate the position of the popover
  void _calculateChildOffset(Rect? childRect) {
    if (childRect == null) return;

    final topHeight = targetRect.top - _viewportRect.top;
    final bottomHeight = _viewportRect.bottom - targetRect.bottom;
    final maximum = max(topHeight, bottomHeight);
    _maxHeight = childRect.height > maximum ? maximum : childRect.height;

    // 先判断弹窗展示方向
    final bool showOnTop = position == PopupPosition.top || (position == PopupPosition.auto && _maxHeight > bottomHeight);

    // 计算阈值：优先使用固定高度，否则使用百分比
    final threshold = edgeThresholdHeight ?? (_viewportRect.height * edgeThresholdRatio);

    // 获取控件可见区域（targetRect与viewport的交集）
    final visibleRect = targetRect.intersect(_viewportRect);

    // 默认使用原始的targetRect
    Rect adjustedTargetRect = targetRect;

    // 检查是否需要调整定位点到可见区域中心
    bool needAdjustToCenter = false;

    if (showOnTop) {
      // 向上展示时：检查控件顶部是否超出屏幕 或 距离顶部小于1/5
      if (targetRect.top < _viewportRect.top || topHeight < threshold) {
        needAdjustToCenter = true;
      }
    } else {
      // 向下展示时：检查控件底部是否超出屏幕 或 距离底部小于1/5
      if (targetRect.bottom > _viewportRect.bottom || bottomHeight < threshold) {
        needAdjustToCenter = true;
      }
    }

    // 如果需要调整，将定位点修改为可见区域中心
    if (needAdjustToCenter && visibleRect.width > 0 && visibleRect.height > 0) {
      final centerY = visibleRect.center.dy;
      adjustedTargetRect = Rect.fromCenter(
        center: Offset(targetRect.center.dx, centerY),
        width: targetRect.width,
        height: 0,
      );

      // 重新计算调整后的可用高度（根据已确定的展示方向）
      final adjustedAvailableHeight = showOnTop ? (adjustedTargetRect.top - _viewportRect.top) : (_viewportRect.bottom - adjustedTargetRect.bottom);
      _maxHeight = childRect.height > adjustedAvailableHeight ? adjustedAvailableHeight : childRect.height;
    }

    if (showOnTop) {
      _bottom = mediaQuery.size.height - adjustedTargetRect.top;
      _arrowDirection = _ArrowDirection.bottom;
      _scaleAlignDy = 1;
    } else {
      _top = adjustedTargetRect.bottom;
      _arrowDirection = _ArrowDirection.top;
      _scaleAlignDy = 0;
    }

    final left = targetRect.center.dx - childRect.center.dx;
    final right = left + childRect.width;
    if (right > _viewportRect.right) {
      _right = _margin;
    } else {
      _left = left < _margin ? _margin : left;
    }
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return child;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    child = _PopupContent(
      childKey: _childKey,
      arrowKey: _arrowKey,
      arrowHorizontal: _arrowHorizontal,
      arrowDirection: _arrowDirection,
      backgroundColor: backgroundColor,
      arrowColor: arrowColor,
      showArrow: showArrow,
      contentPadding: contentPadding,
      contentRadius: contentRadius,
      contentDecoration: contentDecoration,
      child: child,
    );
    if (!animation.isCompleted) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: animationCurve,
      );
      child = FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          alignment: FractionalOffset(_scaleAlignDx, _scaleAlignDy),
          scale: curvedAnimation,
          child: child,
        ),
      );
    }
    return Stack(
      children: [
        Positioned(
          left: _left,
          right: _right,
          top: _top,
          bottom: _bottom,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _viewportRect.width,
              maxHeight: _maxHeight,
            ),
            child: Material(
              color: Colors.transparent,
              type: MaterialType.transparency,
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Duration get transitionDuration => animationDuration;
}
