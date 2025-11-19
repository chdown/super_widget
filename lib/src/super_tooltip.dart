import 'dart:math';

import 'package:flutter/material.dart';
import 'widgets/triangle_painter.dart';

enum TooltipPosition {
  /// 顶部
  top,

  /// 底部
  bottom,

  /// 自动
  auto,
}

class TooltipController extends ChangeNotifier {
  bool _isShow = false;

  bool get isShow => _isShow;

  void show() {
    _isShow = true;
    notifyListeners();
  }

  void dismiss([PointerDownEvent? event]) {
    _isShow = false;

    notifyListeners();
  }

  void toggle() => _isShow ? dismiss() : show();
}

class SuperTooltip extends StatefulWidget {
  const SuperTooltip({
    super.key,
    this.content,
    this.contentBuilder,
    required this.child,
    this.arrowColor = Colors.black,
    this.arrowSize = const Size(10, 10),
    this.arrowSpacing = 4,
    this.onBeforeShow,
    this.onAfterDismiss,
    this.controller,
    this.contentPadding = const EdgeInsets.all(8),
    this.contentBackgroundColor = Colors.black,
    this.contentRadius,
    this.contentDecoration,
    this.barrierColor,
    this.isLongPress = false,
    this.offsetIgnore = false,
    this.position,
  }) : assert(arrowSpacing >= 0, 'arrowSpacing must be non-negative');

  /// 消息内容
  final Widget? content;

  /// 消息内容构造器，对于需要动态处理的内容使用
  final Widget Function(TooltipController controller)? contentBuilder;

  /// 目标组件
  final Widget child;

  /// 箭头颜色
  final Color arrowColor;

  /// 箭头尺寸
  final Size arrowSize;

  /// 箭头与目标之间的间距
  final double arrowSpacing;

  /// 显示前回调
  final VoidCallback? onBeforeShow;

  /// 关闭后回调
  final VoidCallback? onAfterDismiss;

  /// 提示框控制器
  final TooltipController? controller;

  /// 内容内边距
  final EdgeInsetsGeometry contentPadding;

  /// 内容背景颜色
  final Color contentBackgroundColor;

  /// 内容圆角
  final BorderRadiusGeometry? contentRadius;

  /// 内容装饰
  final BoxDecoration? contentDecoration;

  /// 屏幕遮挡层颜色
  final Color? barrierColor;

  /// 是否长按触发
  final bool isLongPress;

  /// 忽略偏移
  final bool offsetIgnore;

  /// 提示框方向
  final TooltipPosition? position;

  @override
  State<SuperTooltip> createState() => _SuperTooltipState();
}

class _SuperTooltipState extends State<SuperTooltip> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  late final TooltipController _controller;

  final key = GlobalKey<State<StatefulWidget>>();
  final contentBoxKey = GlobalKey<State<StatefulWidget>>();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  OverlayEntry? _backgroundEntry; // 全屏背景 OverlayEntry

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _controller = widget.controller ?? TooltipController();
    _controller.addListener(listener);
    super.initState();
  }

  void listener() {
    if (_controller.isShow == true) {
      show();
    } else {
      dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 表示不启用
    if (widget.contentBuilder == null && widget.content == null) return widget.child;

    return PopScope(
      canPop: _overlayEntry == null, // 如果有 popup 显示，则不允许直接退出
      onPopInvokedWithResult: (didPop, result) {
        // 如果有 popup 显示且页面没有退出，则关闭 popup
        if (!didPop && _overlayEntry != null) {
          _controller.dismiss();
        }
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.isLongPress ? null : _controller.toggle,
          onLongPress: !widget.isLongPress ? null : _controller.toggle,
          child: SizedBox(key: key, child: widget.child),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 页面销毁时，立即清理 overlay，不播放动画
    _removeOverlays();
    _controller.removeListener(listener);
    // 只有当 controller 是内部创建时才销毁
    if (widget.controller == null) {
      _controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void show() {
    if (_animationController.isAnimating) return;

    // 如果已有 overlay 显示，先清理
    if (_overlayEntry != null) _removeOverlays();

    final resolvedPadding = widget.contentPadding.resolve(TextDirection.ltr);
    final horizontalPadding = resolvedPadding.left + resolvedPadding.right;

    Widget contentWidget = widget.contentBuilder != null ? widget.contentBuilder!(_controller) : widget.content!;

    final Widget contentBox = Material(
      type: MaterialType.transparency,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - horizontalPadding,
        ),
        child: Container(
          key: contentBoxKey,
          padding: widget.contentPadding,
          decoration: widget.contentDecoration ??
              BoxDecoration(
                color: widget.contentBackgroundColor,
                borderRadius: widget.contentRadius ?? BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
          child: contentWidget,
        ),
      ),
    );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            FadeTransition(
              opacity: _animation,
              child: contentBox,
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 检查 widget 是否已销毁
      if (!mounted) {
        _removeOverlays();
        return;
      }

      final contentBoxRenderBox = contentBoxKey.currentContext?.findRenderObject() as RenderBox?;
      final contentBoxSize = contentBoxRenderBox?.size;

      _overlayEntry?.remove();
      _overlayEntry = null;

      if (contentBoxSize == null) return;

      _overlayEntry = OverlayEntry(
        builder: (context) {
          double keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
          final builder = _builder(contentBoxSize, keyboardHeight);
          if (builder == null) return const SizedBox();

          final Widget triangle = switch (builder.targetAnchor) {
            Alignment.bottomCenter => RotatedBox(
                quarterTurns: 2,
                child: CustomPaint(
                  painter: TrianglePainter(color: widget.arrowColor),
                ),
              ),
            Alignment.topCenter => CustomPaint(
                painter: TrianglePainter(color: widget.arrowColor),
              ),
            Alignment.centerLeft => RotatedBox(
                quarterTurns: 3,
                child: CustomPaint(
                  painter: TrianglePainter(color: widget.arrowColor),
                ),
              ),
            Alignment.centerRight => RotatedBox(
                quarterTurns: 1,
                child: CustomPaint(
                  painter: TrianglePainter(color: widget.arrowColor),
                ),
              ),
            _ => const SizedBox.shrink(),
          };

          final Offset triangleOffset = switch (builder.targetAnchor) {
            Alignment.bottomCenter => Offset(0, widget.arrowSpacing),
            Alignment.topCenter => Offset(0, -(widget.arrowSpacing)),
            Alignment.centerLeft => Offset(-(widget.arrowSpacing), 0),
            Alignment.centerRight => Offset(widget.arrowSpacing, 0),
            _ => Offset.zero,
          };

          final Offset contentBoxOffset = switch (builder.targetAnchor) {
            Alignment.bottomCenter when widget.offsetIgnore => Offset(0, widget.arrowSize.height + (widget.arrowSpacing) - 1),
            Alignment.topCenter when widget.offsetIgnore => Offset(0, -widget.arrowSize.height - (widget.arrowSpacing) + 1),
            Alignment.centerLeft when widget.offsetIgnore => Offset(-(widget.arrowSpacing) - widget.arrowSize.width + 1, 0),
            Alignment.centerRight when widget.offsetIgnore => Offset((widget.arrowSpacing) + widget.arrowSize.width - 1, 0),
            Alignment.bottomCenter => Offset(builder.offset.dx, widget.arrowSize.height + (widget.arrowSpacing) - 1),
            Alignment.topCenter => Offset(builder.offset.dx, -widget.arrowSize.height - (widget.arrowSpacing) + 1),
            Alignment.centerLeft => Offset(-(widget.arrowSpacing) - widget.arrowSize.width + 1, builder.offset.dy),
            Alignment.centerRight => Offset((widget.arrowSpacing) + widget.arrowSize.width - 1, builder.offset.dy),
            _ => Offset.zero,
          };

          return FadeTransition(
            opacity: _animation,
            child: Stack(
              children: [
                const SizedBox.expand(),
                CompositedTransformFollower(
                  link: _layerLink,
                  targetAnchor: builder.targetAnchor,
                  followerAnchor: builder.followerAnchor,
                  offset: Offset(contentBoxOffset.dx, contentBoxOffset.dy + builder.dyOffset),
                  child: contentBox,
                ),
                CompositedTransformFollower(
                  link: _layerLink,
                  targetAnchor: builder.targetAnchor,
                  followerAnchor: builder.followerAnchor,
                  offset: Offset(triangleOffset.dx, triangleOffset.dy + builder.dyOffset),
                  child: SizedBox.fromSize(
                    size: widget.arrowSize,
                    child: triangle,
                  ),
                ),
              ],
            ),
          );
        },
      );

      // 插入全屏背景 OverlayEntry，用于点击关闭
      _backgroundEntry = OverlayEntry(
        builder: (context) {
          return FadeTransition(
            opacity: _animation,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _controller.dismiss,
              child: Container(
                color: widget.barrierColor ?? Colors.transparent,
                child: const SizedBox.expand(),
              ),
            ),
          );
        },
      );

      Overlay.of(context).insert(_backgroundEntry!);
      Overlay.of(context).insert(_overlayEntry!);

      _animationController.forward();
      // 更新 PopScope 状态
      _updatePopScopeState();
    });

    widget.onBeforeShow?.call();
  }

  Future<void> dismiss() async {
    if (_overlayEntry == null) return;

    // 如果 widget 已销毁，直接清理
    if (mounted) {
      // 播放反向动画
      // reverse() 会自动处理当前动画状态（即使正在 forward 也能正确 reverse）
      await _animationController.reverse();
    }

    // 动画结束后移除
    _removeOverlays();

    // 回调和状态更新
    widget.onAfterDismiss?.call();
    _updatePopScopeState();
  }

  /// 统一的 overlay 移除方法
  ///
  /// [immediate] 为 true 时立即移除，不播放动画
  void _removeOverlays() {
    if (_overlayEntry == null) return;
    // 立即停止动画并移除
    _animationController.stop();
    _overlayEntry?.remove();
    _backgroundEntry?.remove();
    _overlayEntry = null;
    _backgroundEntry = null;
  }

  /// 更新 PopScope 状态
  void _updatePopScopeState() {
    if (mounted) {
      setState(() {});
    }
  }

  /// 根据目标组件在屏幕上的位置和可用空间计算提示框的最佳位置。
  ///
  /// 此方法执行智能边缘检测并自动调整提示框位置，确保其保持在视口边界内。
  ///
  /// 返回一个记录，包含：
  /// - targetAnchor: 目标组件上的锚点
  /// - followerAnchor: 提示框上的锚点
  /// - offset: 防止边缘溢出的额外偏移
  /// - dyOffset: 当空间不足时居中显示的额外 Y 轴偏移
  ({Alignment targetAnchor, Alignment followerAnchor, Offset offset, double dyOffset})? _builder(
      Size contentBoxSize, double keyboardHeight) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      throw Exception('RenderBox is null');
    }

    // 解析 contentPadding 以便访问具体的边距值
    final resolvedPadding = widget.contentPadding.resolve(TextDirection.ltr);

    // 计算目标组件的度量信息
    final targetSize = renderBox.size;
    final targetPosition = renderBox.localToGlobal(Offset.zero);
    final targetCenterPosition = Offset(targetPosition.dx + targetSize.width / 2, targetPosition.dy + targetSize.height / 2);

    // 计算可用的屏幕高度（减去键盘高度）
    final screenHeight = MediaQuery.of(context).size.height;
    final availableScreenHeight = screenHeight - keyboardHeight;

    // 判断提示框应该显示在目标下方还是上方
    // 当目标在上半部分时，提示框显示在下方；当目标在下半部分时，提示框显示在上方
    final bool showTooltipBelow = switch (widget.position) {
      TooltipPosition.top => false, // 强制显示在上方
      TooltipPosition.bottom => true, // 强制显示在下方
      _ => targetCenterPosition.dy <= availableScreenHeight / 2, // 自动：考虑键盘后，上半部分 -> 下方
    };

    // 根据位置确定锚点
    Alignment targetAnchor = switch (widget.position) {
      TooltipPosition.top => Alignment.topCenter, // 锚点在目标顶部，提示框在上方
      TooltipPosition.bottom => Alignment.bottomCenter, // 锚点在目标底部，提示框在下方
      _ => showTooltipBelow ? Alignment.bottomCenter : Alignment.topCenter, // 自动
    };

    Alignment followerAnchor = switch (widget.position) {
      TooltipPosition.top => Alignment.bottomCenter, // 提示框的底部对齐目标的顶部
      TooltipPosition.bottom => Alignment.topCenter, // 提示框的顶部对齐目标的底部
      _ => showTooltipBelow ? Alignment.topCenter : Alignment.bottomCenter, // 自动
    };

    // 计算水平溢出和边缘距离
    final double overflowWidth = (contentBoxSize.width - targetSize.width) / 2;

    final edgeFromLeft = targetPosition.dx - overflowWidth;
    final edgeFromRight = MediaQuery.of(context).size.width - (targetPosition.dx + targetSize.width + overflowWidth);
    final edgeFromHorizontal = min(edgeFromLeft, edgeFromRight);

    // 调整水平位置以防止边缘溢出
    double dx = 0;

    if (edgeFromHorizontal < resolvedPadding.horizontal / 2) {
      // 需要调整水平位置以避免边缘溢出
      if (edgeFromLeft < edgeFromRight) {
        // 左边空间不足，向右调整
        dx = (resolvedPadding.horizontal / 2) - edgeFromHorizontal;
      } else {
        // 右边空间不足，向左调整
        dx = -(resolvedPadding.horizontal / 2) + edgeFromHorizontal;
      }
    }

    // 计算垂直溢出和边缘距离（考虑键盘高度）
    final double overflowHeight = (contentBoxSize.height - targetSize.height) / 2;

    final edgeFromTop = targetPosition.dy - overflowHeight;
    final edgeFromBottom = availableScreenHeight - (targetPosition.dy + targetSize.height + overflowHeight);
    final edgeFromVertical = min(edgeFromTop, edgeFromBottom);

    // 调整垂直位置以防止边缘溢出
    double dy = 0;

    if (edgeFromVertical < resolvedPadding.vertical / 2) {
      if (showTooltipBelow) {
        dy = MediaQuery.paddingOf(context).top + (resolvedPadding.vertical / 2) - edgeFromVertical;
      } else {
        dy = MediaQuery.paddingOf(context).bottom - (resolvedPadding.vertical / 2) + edgeFromVertical;
      }
    }

    // 额外逻辑：将提示框定位在目标组件可见区域的 Y 轴中心
    // 当目标组件在可滚动容器中且可能部分不在屏幕内时，这个功能很有用
    final screenFifth = availableScreenHeight / 5;
    double dyOffset = 0;

    final targetBottom = targetPosition.dy + targetSize.height;

    if (targetAnchor == Alignment.topCenter) {
      // 提示框将显示在目标上方（锚点在目标顶部）
      // 第一步：检查是否需要纠正 - 目标顶部距离屏幕顶部较近（< 1/5）
      final needsCorrection = targetPosition.dy < screenFifth;

      if (needsCorrection) {
        // 第二步：计算目标在屏幕上的可见区域并找到其中心
        final visibleTop = max(0.0, targetPosition.dy);
        final visibleBottom = min(availableScreenHeight, targetBottom);
        final visibleHeight = visibleBottom - visibleTop;

        // 计算偏移量，将提示框定位在可见区域中心
        // 从目标顶部到可见区域中心的偏移
        final visibleCenter = visibleTop + visibleHeight / 2;
        dyOffset = visibleCenter - targetPosition.dy;
      }
    } else if (targetAnchor == Alignment.bottomCenter) {
      // 提示框将显示在目标下方（锚点在目标底部）
      // 第一步：检查是否需要纠正 - 目标底部距离屏幕底部较近（< 1/5）
      final distanceToBottom = availableScreenHeight - targetBottom;
      final needsCorrection = distanceToBottom < screenFifth;

      if (needsCorrection) {
        // 第二步：计算目标在屏幕上的可见区域并找到其中心
        final visibleTop = max(0.0, targetPosition.dy);
        final visibleBottom = min(availableScreenHeight, targetBottom);
        final visibleHeight = visibleBottom - visibleTop;

        // 计算偏移量，将提示框定位在可见区域中心
        // 从目标底部到可见区域中心的偏移
        final visibleCenter = visibleTop + visibleHeight / 2;
        dyOffset = visibleCenter - targetBottom;
      }
    }

    return (
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      offset: Offset(dx, dy),
      dyOffset: dyOffset,
    );
  }
}
