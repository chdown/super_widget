import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 简化版可展开文本组件
/// 支持展开/收起功能，支持外部富文本控制
///
/// 如果需要复制功能，通过 [builder] 方法进行构造，eg:
// SuperExpandableText(
//   text: '这是一段可选中的文本示例。你可以长按或拖动来选中文本内容。当选中文本时，会在下方显示选中的文本内容和选中范围。通过 onSelectionChanged 参数，组件会自动使用 SelectableText 替代 RichText，支持文本选中功能。这个功能适用于需要用户能够复制或分享文本内容的场景。',
//   maxLines: 3,
//   builder: (textSpan, int? endOffset) {
//     return SelectableText.rich(textSpan, scrollPhysics: NeverScrollableScrollPhysics());
//   },
// )
///
class SuperExpandableText extends StatefulWidget {

  /// 文本内容
  final String text;

  /// 展开按钮文本
  final String expandText;

  /// 收起按钮文本
  final String collapseText;

  /// 最大行数
  final int maxLines;

  /// 初始展开状态
  final bool expanded;

  /// 文本样式
  final TextStyle? textStyle;

  /// 展开/收起按钮样式
  final TextStyle? collapseStyle;

  /// 展开状态变化回调，返回 false 可阻止状态变化
  final bool? Function(bool willExpanded)? onExpanded;

  /// 富文本片段列表
  final List<TextSpan>? richTextSpans;

  /// 构造方法
  /// [endOffset] 截断是返回
  final Widget Function(TextSpan textSpan,int? endOffset)? builder;

  const SuperExpandableText({
    super.key,
    required this.text,
    this.expandText = '展开',
    this.collapseText = '收起',
    this.maxLines = 3,
    this.expanded = false,
    this.textStyle,
    this.collapseStyle,
    this.onExpanded,
    this.richTextSpans,
    this.builder,
  });

  @override
  State<SuperExpandableText> createState() => _SuperExpandableTextState();
}

class _SuperExpandableTextState extends State<SuperExpandableText> {
  late bool _expanded;
  late TapGestureRecognizer _linkTapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expanded;
    _linkTapGestureRecognizer = TapGestureRecognizer()..onTap = _toggleExpanded;
  }

  @override
  void dispose() {
    _linkTapGestureRecognizer.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    final willExpanded = !_expanded;

    // 如果用户提供了回调且返回 false，则阻止状态变化
    if (widget.onExpanded != null && widget.onExpanded!(willExpanded) == false) {
      return;
    }

    setState(() {
      _expanded = willExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = widget.textStyle ?? defaultTextStyle.style;
    if (widget.textStyle == null || widget.textStyle!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.textStyle);
    }

    final linkTextStyle = effectiveTextStyle.merge(widget.collapseStyle);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        final textDirection = Directionality.of(context);
        final textScaleFactor = MediaQuery.textScaleFactorOf(context);
        final locale = Localizations.maybeLocaleOf(context);

        // 构建链接按钮
        final linkText = _expanded ? widget.collapseText : widget.expandText;
        final link = TextSpan(
          text: _expanded ? ' $linkText' : '... $linkText',
          style: linkTextStyle,
          recognizer: _linkTapGestureRecognizer,
        );

        // 测量链接按钮的尺寸
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: widget.maxLines,
          locale: locale,
        );
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        // 构建内容
        final content = _buildContent(effectiveTextStyle);

        // 测量内容的尺寸
        textPainter.text = content;
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final textSize = textPainter.size;

        // 判断是否需要截断
        TextSpan textSpan;
        int? endOffset;
        if (textPainter.didExceedMaxLines) {
          // 需要截断
          final position = textPainter.getPositionForOffset(Offset(
            textSize.width - linkSize.width,
            textSize.height,
          ));
          endOffset = textPainter.getOffsetBefore(position.offset) ?? 0;

          if (_expanded) {
            // 已展开：显示全部内容 + 收起按钮
            textSpan = TextSpan(
              style: effectiveTextStyle,
              children: <TextSpan>[
                content,
                link,
              ],
            );
          } else {
            // 未展开：截断内容 + 展开按钮
            final truncatedContent = _buildTruncatedContent(
              endOffset,
              effectiveTextStyle,
            );
            textSpan = TextSpan(
              style: effectiveTextStyle,
              children: <TextSpan>[
                truncatedContent,
                link,
              ],
            );
          }
        } else {
          // 不需要截断
          if (_expanded) {
            // 显示全部内容 + 收起按钮
            textSpan = TextSpan(
              style: effectiveTextStyle,
              children: <TextSpan>[
                content,
                link,
              ],
            );
          } else {
            // 仅显示内容
            textSpan = content;
          }
        }

        return widget.builder != null
            ? widget.builder!(textSpan, endOffset)
            : RichText(
                text: textSpan,
                softWrap: true,
                textDirection: textDirection,
                textScaleFactor: textScaleFactor,
                overflow: TextOverflow.clip,
              );
      },
    );
  }

  /// 构建内容 TextSpan
  TextSpan _buildContent(TextStyle textStyle) {
    if (widget.richTextSpans != null && widget.richTextSpans!.isNotEmpty) {
      // 使用富文本
      return TextSpan(
        children: widget.richTextSpans,
        style: textStyle,
      );
    } else {
      // 使用普通文本
      return TextSpan(
        text: widget.text,
        style: textStyle,
      );
    }
  }

  /// 构建截断后的内容
  TextSpan _buildTruncatedContent(int endOffset, TextStyle textStyle) {
    if (widget.richTextSpans != null && widget.richTextSpans!.isNotEmpty) {
      // 富文本：尝试智能截断
      return _truncateRichTextSpans(endOffset, textStyle);
    } else {
      // 普通文本：直接截断
      final truncatedText = widget.text.substring(0, max(endOffset, 0));
      return TextSpan(
        text: truncatedText,
        style: textStyle,
      );
    }
  }

  /// 截断富文本片段
  TextSpan _truncateRichTextSpans(int endOffset, TextStyle textStyle) {
    if (widget.richTextSpans == null || widget.richTextSpans!.isEmpty) {
      return TextSpan(text: '', style: textStyle);
    }

    // 计算富文本的总长度
    int currentLength = 0;
    final List<TextSpan> truncatedSpans = [];

    for (final span in widget.richTextSpans!) {
      final spanText = span.toPlainText();
      final spanLength = spanText.length;

      if (currentLength + spanLength <= endOffset) {
        // 整个 span 都可以包含
        truncatedSpans.add(span);
        currentLength += spanLength;
      } else if (currentLength < endOffset) {
        // 部分 span 可以包含
        final remainingLength = endOffset - currentLength;
        final truncatedSpanText = spanText.substring(0, remainingLength);
        truncatedSpans.add(TextSpan(
          text: truncatedSpanText,
          style: span.style,
        ));
        break;
      } else {
        // 已经达到截断长度
        break;
      }
    }

    return TextSpan(
      children: truncatedSpans,
      style: textStyle,
    );
  }
}
