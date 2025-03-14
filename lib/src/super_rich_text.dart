import 'package:flutter/material.dart';
import 'package:super_widget/super_widget.dart';

/// @author : ch
/// @description 文本加载组件
///
class SuperRichText extends StatelessWidget {
  /// 文字字符串
  final String? title;

  /// 颜色
  final Color? titleColor;

  /// 大小
  final double? titleFontSize;

  /// 样式
  final TextStyle? titleStyle;

  /// 重量
  final FontWeight? titleFontWeight;

  /// title右边距
  final double? titleEndSpace;

  /// 文字字符串
  final String? text;

  /// 颜色
  final Color? color;

  /// 大小
  final double? fontSize;

  /// 样式
  final TextStyle? textStyle;

  /// 重量
  final FontWeight? fontWeight;

  /// text右边距
  final double? textEndSpace;

  /// 文字字符串
  final String? suffixText;

  /// 颜色
  final Color? suffixColor;

  /// 大小
  final double? suffixFontSize;

  /// 样式
  final TextStyle? suffixStyle;

  /// suffix右边距
  final double? suffixEndSpace;

  /// 重量
  final FontWeight? suffixFontWeight;

  /// 行数
  final int? maxLines;

  /// 自动换行
  final bool softWrap;

  /// 溢出
  final TextOverflow overflow;

  /// 对齐方式
  final TextAlign textAlign;

  /// 扩展类型
  final List<TextSpan> spanList;

  const SuperRichText({
    super.key,
    this.title,
    this.titleColor,
    this.titleFontSize,
    this.titleStyle,
    this.titleFontWeight,
    this.titleEndSpace,
    this.text,
    this.color,
    this.fontSize,
    this.textStyle,
    this.fontWeight,
    this.textEndSpace,
    this.suffixText,
    this.suffixColor,
    this.suffixFontSize,
    this.suffixStyle,
    this.suffixFontWeight,
    this.suffixEndSpace,
    this.maxLines,
    this.softWrap = true,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start,
    this.spanList = const [],
  });

  @override
  Widget build(BuildContext context) {
    if ((title == null || title == '') && (text == null || text == '') && (suffixText == null || suffixText == '')) {
      return const SizedBox();
    }
    return RichText(
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textAlign: textAlign,
      text: TextSpan(
        text: title,
        style: titleStyle?.copyWith(color: titleColor, fontSize: titleFontSize ?? SuperWidgetConfig.defaultTextSize, fontWeight: titleFontWeight) ??
            TextStyle(color: titleColor, fontSize: titleFontSize ?? SuperWidgetConfig.defaultTextSize, fontWeight: titleFontWeight),
        children: [
          if (titleEndSpace != null) WidgetSpan(child: SizedBox(width: titleEndSpace)),
          TextSpan(
            text: text,
            style: textStyle?.copyWith(color: color, fontSize: fontSize ?? SuperWidgetConfig.defaultTextSize, fontWeight: fontWeight) ??
                TextStyle(color: color, fontSize: fontSize ?? SuperWidgetConfig.defaultTextSize, fontWeight: fontWeight),
          ),
          if (textEndSpace != null) WidgetSpan(child: SizedBox(width: textEndSpace)),
          TextSpan(
            text: suffixText,
            style: suffixStyle?.copyWith(color: suffixColor, fontSize: suffixFontSize ?? SuperWidgetConfig.defaultTextSize, fontWeight: suffixFontWeight) ??
                TextStyle(color: suffixColor, fontSize: suffixFontSize ?? SuperWidgetConfig.defaultTextSize, fontWeight: suffixFontWeight),
          ),
          if (suffixEndSpace != null) WidgetSpan(child: SizedBox(width: suffixEndSpace)),
          for (var span in spanList) span
        ],
      ),
    );
  }
}
