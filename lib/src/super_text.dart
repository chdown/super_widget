import 'package:flutter/material.dart';
import 'package:super_widget/src/config/super_widget_config.dart';

/// @author : ch
/// @description 文本加载组件
///
class SuperText extends StatelessWidget {
  /// 文字字符串
  final String text;

  /// 颜色
  final Color? color;

  /// 大小
  final double? fontSize;

  /// 样式
  final TextStyle? textStyle;

  /// 重量
  final FontWeight? fontWeight;

  /// 行数
  final int? maxLines;

  /// 自动换行
  final bool? softWrap;

  /// 溢出
  final TextOverflow? overflow;

  /// 对齐方式
  final TextAlign? textAlign;

  const SuperText(
    this.text, {
    super.key,
    this.textStyle,
    this.maxLines,
    this.softWrap,
    this.overflow,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    if (text == "") {
      return const SizedBox();
    }
    return Text(
      text,
      style: textStyle?.copyWith(color: color, fontSize: fontSize ?? SuperWidgetConfig.defaultTextSize, fontWeight: fontWeight) ??
          TextStyle(
            color: color,
            fontSize: fontSize ?? SuperWidgetConfig.defaultTextSize,
            fontWeight: fontWeight,
          ),
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textAlign: textAlign,
    );
  }
}
