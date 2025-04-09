import 'package:flutter/material.dart';
import 'package:super_widget/src/config/super_widget_config.dart';
import 'package:super_widget/src/widget_utils.dart';

/// @author : ch
/// @date 2024-03-08 16:52:29
/// @description test
///
///
enum ButtonType { filled, outlined, outlinedPrimary, text, textPrimary }

class SuperButton extends StatelessWidget {
  /// 按钮显示的文案
  final ButtonType type;

  /// 按钮显示的文案
  final String text;

  /// 按钮点击的回调
  final VoidCallback onTap;

  /// 按钮的文字颜色
  final Color? textColor;

  /// 按钮的文字大小
  final double? textSize;

  /// 按钮加粗
  final FontWeight? fontWeight;

  /// 按钮的文本显示样式 优先级高于[textColor]、[textSize]等属性
  final TextStyle? textStyle;

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 自定义左侧Widget
  final double widgetMarginHorizontal;
  final Widget? prefixWidget;
  final Widget? suffixWidget;

  /// 按钮背景色
  final Color? backgroundColor;

  /// 按钮外边距
  final EdgeInsetsGeometry? margin;

  /// 按钮内边距
  final EdgeInsetsGeometry? padding;
  final double paddingHorizontal;
  final double paddingVertical;

  /// 按钮的内部对齐 默认为null
  final Alignment? alignment;

  /// 按钮圆角大小,
  final double? borderRadius;
  final double? topBorderRadius;
  final double? topBorderLeftRadius;
  final double? topBorderRightRadius;
  final double? bottomBorderRadius;
  final double? bottomBorderLeftRadius;
  final double? bottomBorderRightRadius;

  /// 按钮边框颜色，borderWidth不能为空生效
  /// [ButtonType.outlinedPrimary]默认为主题色
  final Color? borderColor;

  /// 按钮边框宽度，borderColor不能为空生效
  final double? borderWidth;

  /// 按钮是否可用 默认是 [true]
  final bool enabled;

  /// 防抖：[debounceTime]未0时，禁用防抖，否则未防丢时间
  final int? debounceTime;

  const SuperButton({
    super.key,
    required this.type,
    required this.text,
    required this.onTap,
    this.textColor,
    this.textSize,
    this.fontWeight,
    this.textStyle,
    this.width,
    this.height,
    this.widgetMarginHorizontal = 4,
    this.prefixWidget,
    this.suffixWidget,
    this.backgroundColor,
    this.margin,
    this.padding,
    this.paddingHorizontal = 8,
    this.paddingVertical = 6,
    this.alignment,
    this.borderRadius,
    this.topBorderRadius,
    this.topBorderLeftRadius,
    this.topBorderRightRadius,
    this.bottomBorderRadius,
    this.bottomBorderLeftRadius,
    this.bottomBorderRightRadius,
    this.borderWidth,
    this.borderColor,
    this.enabled = true,
    this.debounceTime,
  });

  @override
  Widget build(BuildContext context) {
    OutlinedBorder border = RoundedRectangleBorder(
      borderRadius: buildBorderRadius(
        topBorderRadius,
        bottomBorderRadius,
        topBorderLeftRadius,
        topBorderRightRadius,
        bottomBorderLeftRadius,
        bottomBorderRightRadius,
        borderRadius ?? SuperWidgetConfig.btnBorderRadius,
      ),
    );
    EdgeInsetsGeometry padding = this.padding ?? EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal);
    Color? textColor = getTextColor(Theme.of(context).primaryColor);
    Widget buttonWidget = const SizedBox.shrink();

    var tmpOnTap = debounceTime == null ? onTap : SuperWidgetConfig.onDebounceTap(onTap, debounceTime ?? SuperWidgetConfig.debounceTime);

    if (type == ButtonType.filled) {
      buttonWidget = FilledButton(
        onPressed: enabled ? tmpOnTap : null,
        child: getChildren(textColor),
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: alignment,
          shape: border,
          side: borderWidth != null && borderColor != null ? BorderSide(width: borderWidth!, color: borderColor!) : null,
        ),
      );
    } else if (type == ButtonType.outlined || type == ButtonType.outlinedPrimary) {
      buttonWidget = OutlinedButton(
        onPressed: enabled ? tmpOnTap : null,
        child: getChildren(textColor),
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: alignment,
          shape: border,
          side: enabled && ((borderWidth != null || borderColor != null) || type == ButtonType.outlinedPrimary)
              ? BorderSide(width: borderWidth ?? 1, color: borderColor ?? Theme.of(context).primaryColor)
              : null,
        ),
      );
    } else if (type == ButtonType.text || type == ButtonType.textPrimary) {
      buttonWidget = TextButton(
        onPressed: enabled ? tmpOnTap : null,
        child: getChildren(textColor),
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: alignment,
          shape: border,
          side: borderWidth != null && borderColor != null ? BorderSide(width: borderWidth!, color: borderColor!) : null,
        ),
      );
    }
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: buttonWidget,
    );
  }

  getChildren(Color? textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (prefixWidget != null) prefixWidget!,
        if (prefixWidget != null) SizedBox(width: widgetMarginHorizontal),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: textStyle?.copyWith(color: textColor, fontSize: textSize ?? SuperWidgetConfig.defaultTextSize, fontWeight: fontWeight) ??
                TextStyle(color: textColor, fontSize: textSize ?? SuperWidgetConfig.defaultTextSize, fontWeight: fontWeight),
            textAlign: TextAlign.center,
          ),
        ),
        if (suffixWidget != null) SizedBox(width: widgetMarginHorizontal),
        if (suffixWidget != null) suffixWidget!,
      ],
    );
  }

  Color? getTextColor(Color primaryColor) {
    if (!enabled) return null;
    Color? textColor = this.textColor ?? textStyle?.color;
    if (type == ButtonType.outlined || type == ButtonType.text) {
      textColor = textColor ?? SuperWidgetConfig.btnTextColor;
    }
    return textColor;
  }
}
