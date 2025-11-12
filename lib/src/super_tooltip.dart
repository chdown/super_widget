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
    required this.content,
    required this.child,
    this.triangleColor = Colors.black,
    this.triangleSize = const Size(10, 10),
    this.targetPadding = 4,
    this.triangleRadius = 2,
    this.onShow,
    this.onDismiss,
    this.controller,
    this.padding = const EdgeInsets.all(16),
    this.axis = Axis.vertical,
    this.isLongPress = false,
    this.offsetIgnore = false,
    this.position,
  })  : assert(targetPadding >= 0, 'targetPadding must be non-negative'),
        assert(triangleRadius >= 0, 'triangleRadius must be non-negative');

  /// 消息内容
  final Widget content;

  /// 目标组件
  final Widget child;

  /// 三角形颜色
  final Color triangleColor;

  /// 三角形尺寸
  final Size triangleSize;

  /// 目标与提示框之间的间距
  final double targetPadding;

  /// 三角形圆角
  final double triangleRadius;

  /// 显示回调
  final VoidCallback? onShow;

  /// 关闭回调
  final VoidCallback? onDismiss;

  /// 提示框控制器
  final TooltipController? controller;

  /// 消息框内边距
  final EdgeInsetsGeometry padding;

  /// 轴向
  final Axis axis;

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

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _controller = widget.controller ?? TooltipController();
    _controller.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    dismiss();
    _controller.removeListener(listener);
    if (widget.controller == null) {
      _controller.dispose();
    }

    _overlayEntry?.remove();
    _animationController.dispose();

    super.dispose();
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
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.isLongPress ? null : _controller.toggle,
        onLongPress: !widget.isLongPress ? null : _controller.toggle,
        child: SizedBox(key: key, child: widget.child),
      ),
    );
  }

  void show() {
    if (_animationController.isAnimating) return;

    final resolvedPadding = widget.padding.resolve(TextDirection.ltr);
    final horizontalPadding = resolvedPadding.left + resolvedPadding.right;

    final Widget contentBox = Material(
      type: MaterialType.transparency,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - horizontalPadding,
        ),
        child: Container(
          key: contentBoxKey,
          child: widget.content,
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
      final contentBoxRenderBox = contentBoxKey.currentContext?.findRenderObject() as RenderBox?;
      final contentBoxSize = contentBoxRenderBox?.size;

      _overlayEntry?.remove();
      _overlayEntry = null;

      if (contentBoxSize == null) return;

      final builder = _builder(contentBoxSize);
      if (builder == null) return;

      final Widget triangle = switch (builder.targetAnchor) {
        Alignment.bottomCenter => RotatedBox(
            quarterTurns: 2,
            child: CustomPaint(
              painter: TrianglePainter(color: widget.triangleColor),
            ),
          ),
        Alignment.topCenter => CustomPaint(
            painter: TrianglePainter(color: widget.triangleColor),
          ),
        Alignment.centerLeft => RotatedBox(
            quarterTurns: 3,
            child: CustomPaint(
              painter: TrianglePainter(color: widget.triangleColor),
            ),
          ),
        Alignment.centerRight => RotatedBox(
            quarterTurns: 1,
            child: CustomPaint(
              painter: TrianglePainter(color: widget.triangleColor),
            ),
          ),
        _ => const SizedBox.shrink(),
      };

      final Offset triangleOffset = switch (builder.targetAnchor) {
        Alignment.bottomCenter => Offset(0, widget.targetPadding),
        Alignment.topCenter => Offset(0, -(widget.targetPadding)),
        Alignment.centerLeft => Offset(-(widget.targetPadding), 0),
        Alignment.centerRight => Offset(widget.targetPadding, 0),
        _ => Offset.zero,
      };

      final Offset contentBoxOffset = switch (builder.targetAnchor) {
        Alignment.bottomCenter when widget.offsetIgnore => Offset(0, widget.triangleSize.height + (widget.targetPadding) - 1),
        Alignment.topCenter when widget.offsetIgnore => Offset(0, -widget.triangleSize.height - (widget.targetPadding) + 1),
        Alignment.centerLeft when widget.offsetIgnore => Offset(-(widget.targetPadding) - widget.triangleSize.width + 1, 0),
        Alignment.centerRight when widget.offsetIgnore => Offset((widget.targetPadding) + widget.triangleSize.width - 1, 0),
        Alignment.bottomCenter => Offset(builder.offset.dx, widget.triangleSize.height + (widget.targetPadding) - 1),
        Alignment.topCenter => Offset(builder.offset.dx, -widget.triangleSize.height - (widget.targetPadding) + 1),
        Alignment.centerLeft => Offset(-(widget.targetPadding) - widget.triangleSize.width + 1, builder.offset.dy),
        Alignment.centerRight => Offset((widget.targetPadding) + widget.triangleSize.width - 1, builder.offset.dy),
        _ => Offset.zero,
      };

      _overlayEntry = OverlayEntry(
        builder: (context) {
          return FadeTransition(
            opacity: _animation,
            child: TapRegion(
              onTapOutside: _controller.dismiss,
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
                      size: widget.triangleSize,
                      child: triangle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      Overlay.of(context).insert(_overlayEntry!);

      _animationController.forward();
    });

    widget.onShow?.call();
  }

  Future<void> dismiss() async {
    if (_overlayEntry != null) {
      await _animationController.reverse();
      _overlayEntry?.remove();
      _overlayEntry = null;
      widget.onDismiss?.call();
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
  ({Alignment targetAnchor, Alignment followerAnchor, Offset offset, double dyOffset})? _builder(Size contentBoxSize) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      throw Exception('RenderBox is null');
    }

    // 计算目标组件的度量信息
    final targetSize = renderBox.size;
    final targetPosition = renderBox.localToGlobal(Offset.zero);
    final targetCenterPosition = Offset(targetPosition.dx + targetSize.width / 2, targetPosition.dy + targetSize.height / 2);

    final bool targetInLeftHalf = targetCenterPosition.dx <= MediaQuery.of(context).size.width / 2;
    final bool targetInRightHalf = targetCenterPosition.dx > MediaQuery.of(context).size.width / 2;

    // 判断提示框应该显示在目标下方还是上方
    // 当目标在上半部分时，提示框显示在下方；当目标在下半部分时，提示框显示在上方
    final bool showTooltipBelow = switch (widget.position) {
      TooltipPosition.top => false,      // 强制显示在上方
      TooltipPosition.bottom => true,    // 强制显示在下方
      _ => targetCenterPosition.dy <= MediaQuery.of(context).size.height / 2,  // 自动：上半部分 -> 下方
    };

    final bool showTooltipAbove = switch (widget.position) {
      TooltipPosition.top => true,       // 强制显示在上方
      TooltipPosition.bottom => false,   // 强制显示在下方
      _ => targetCenterPosition.dy > MediaQuery.of(context).size.height / 2,   // 自动：下半部分 -> 上方
    };

    // 根据轴向和位置确定锚点
    Alignment targetAnchor = switch (widget.axis) {
      Axis.horizontal when targetInRightHalf => Alignment.centerLeft,
      Axis.horizontal when targetInLeftHalf => Alignment.centerRight,
      Axis.vertical when showTooltipBelow => Alignment.bottomCenter,  // 锚点在目标底部，提示框在下方
      Axis.vertical when showTooltipAbove => Alignment.topCenter,     // 锚点在目标顶部，提示框在上方
      _ => Alignment.center,
    };

    Alignment followerAnchor = switch (widget.axis) {
      Axis.horizontal when targetInRightHalf => Alignment.centerRight,
      Axis.horizontal when targetInLeftHalf => Alignment.centerLeft,
      Axis.vertical when showTooltipBelow => Alignment.topCenter,     // 提示框的顶部对齐目标的底部
      Axis.vertical when showTooltipAbove => Alignment.bottomCenter,  // 提示框的底部对齐目标的顶部
      _ => Alignment.center,
    };

    // 计算水平溢出和边缘距离
    final double overflowWidth = (contentBoxSize.width - targetSize.width) / 2;

    final edgeFromLeft = targetPosition.dx - overflowWidth;
    final edgeFromRight = MediaQuery.of(context).size.width - (targetPosition.dx + targetSize.width + overflowWidth);
    final edgeFromHorizontal = min(edgeFromLeft, edgeFromRight);

    // 调整水平位置以防止边缘溢出
    double dx = 0;

    if (edgeFromHorizontal < widget.padding.horizontal / 2) {
      if (targetInLeftHalf) {
        dx = (widget.padding.horizontal / 2) - edgeFromHorizontal;
      } else if (targetInRightHalf) {
        dx = -(widget.padding.horizontal / 2) + edgeFromHorizontal;
      }
    }

    // 计算垂直溢出和边缘距离
    final double overflowHeight = (contentBoxSize.height - targetSize.height) / 2;

    final edgeFromTop = targetPosition.dy - overflowHeight;
    final edgeFromBottom = MediaQuery.of(context).size.height - (targetPosition.dy + targetSize.height + overflowHeight);
    final edgeFromVertical = min(edgeFromTop, edgeFromBottom);

    // 调整垂直位置以防止边缘溢出
    double dy = 0;

    if (edgeFromVertical < widget.padding.vertical / 2) {
      if (showTooltipBelow) {
        dy = MediaQuery.of(context).padding.top + (widget.padding.vertical / 2) - edgeFromVertical;
      } else if (showTooltipAbove) {
        dy = MediaQuery.of(context).padding.bottom - (widget.padding.vertical / 2) + edgeFromVertical;
      }
    }

    // 额外逻辑：将提示框定位在目标组件可见区域的 Y 轴中心
    // 当目标组件在可滚动容器中且可能部分不在屏幕内时，这个功能很有用
    final screenHeight = MediaQuery.of(context).size.height;
    final screenFifth = screenHeight / 5;
    double dyOffset = 0;

    if (widget.axis == Axis.vertical) {
      final targetBottom = targetPosition.dy + targetSize.height;

      if (targetAnchor == Alignment.topCenter) {
        // 提示框将显示在目标上方（锚点在目标顶部）
        // 第一步：检查是否需要纠正 - 目标顶部距离屏幕顶部较近（< 1/5）
        final needsCorrection = targetPosition.dy < screenFifth;

        if (needsCorrection) {
          // 第二步：计算目标在屏幕上的可见区域并找到其中心
          final visibleTop = max(0.0, targetPosition.dy);
          final visibleBottom = min(screenHeight, targetBottom);
          final visibleHeight = visibleBottom - visibleTop;

          // 计算偏移量，将提示框定位在可见区域中心
          // 从目标顶部到可见区域中心的偏移
          final visibleCenter = visibleTop + visibleHeight / 2;
          dyOffset = visibleCenter - targetPosition.dy;
        }
      } else if (targetAnchor == Alignment.bottomCenter) {
        // 提示框将显示在目标下方（锚点在目标底部）
        // 第一步：检查是否需要纠正 - 目标底部距离屏幕底部较近（< 1/5）
        final distanceToBottom = screenHeight - targetBottom;
        final needsCorrection = distanceToBottom < screenFifth;

        if (needsCorrection) {
          // 第二步：计算目标在屏幕上的可见区域并找到其中心
          final visibleTop = max(0.0, targetPosition.dy);
          final visibleBottom = min(screenHeight, targetBottom);
          final visibleHeight = visibleBottom - visibleTop;

          // 计算偏移量，将提示框定位在可见区域中心
          // 从目标底部到可见区域中心的偏移
          final visibleCenter = visibleTop + visibleHeight / 2;
          dyOffset = visibleCenter - targetBottom;
        }
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
