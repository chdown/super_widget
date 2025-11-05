import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_widget/super_widget.dart';
import 'click_throttler_utils.dart';

enum SuperKeyboardType { number, decimal, decimalNegative }

enum SuperInputBorderStyle { none, fill, outline, underline }

/// @author : ch
/// @date 2024-01-19 21:59:11
/// @description 输入框组件
///
class SuperInput extends StatefulWidget {
  /// 控制器
  final TextEditingController controller;

  /// 原始文本
  final String? originalText;

  /// 文本颜色
  final Color? color;

  /// 文本大小
  final double? fontSize;

  /// 文本对齐方式
  final TextAlign textAlign;

  /// 输入内容大小写
  final TextCapitalization textCapitalization;

  /// 焦点节点
  final FocusNode? focusNode;

  /// 自动获取焦点
  final bool autofocus;

  /// 自定义键盘类型（number/decimal/decimalNegative）
  final SuperKeyboardType? superKeyboardType;

  /// 原生键盘类型
  final TextInputType? textInputType;

  /// 键盘回车按钮类型
  final TextInputAction? textInputAction;

  /// 键盘输入限制
  final List<TextInputFormatter>? inputFormatters;

  /// 最大输入长度
  final int? maxLength;

  /// 小数点长度，当[superKeyboardType]为[SuperKeyboardType.decimal]或[SuperKeyboardType.decimalNegative]时生效
  final int decimalLength;

  /// 整数位长度
  final int? integerLength;

  /// 装饰是否与输入字段大小相同，该属性用于修改高度
  final bool isCollapsed;

  /// 是否为紧凑模式
  final bool isDense;

  /// 内部内容边距
  final EdgeInsetsGeometry? contentPadding;

  /// 填充色
  final Color? fillColor;

  /// 是否扩展
  final bool expands;

  /// 最小行数
  final int? minLines;

  /// 最大行数
  final int? maxLines;

  // ========== 行为控制 ==========
  /// 是否只读
  final bool readOnly;

  /// 是否启用
  final bool enabled;

  /// 是否显示密文
  final bool obscureText;

  /// 是否显示清除按钮
  final bool? isClear;

  // ========== 事件回调 ==========
  /// 点击事件
  final VoidCallback? onTap;

  /// 防抖时间（毫秒），为0时禁用防抖
  final int? debounceTime;

  /// 内容改变监听
  final ValueChanged<String>? onChanged;

  /// 提交监听
  final ValueChanged<String>? onSubmitted;

  /// 点击清除按钮回调
  final VoidCallback? onClear;

  // ========== 边框样式 ==========
  /// 边框样式
  final SuperInputBorderStyle borderStyle;

  /// 边框圆角
  final BorderRadius? borderRadius;

  /// 边框宽度
  final double borderWidth;

  /// 边框颜色
  final Color? borderColor;

  /// 获取焦点时边框颜色
  final Color? borderFocusColor;

  /// 错误状态边框颜色
  final Color borderErrorColor;

  // ========== 提示文本 ==========
  /// 提示文本
  final String? hintText;

  /// 提示文本颜色
  final Color? hintFontColor;

  /// 提示文本大小
  final double? hintFontSize;

  // ========== 标签 ==========
  /// 标签组件
  final Widget? label;

  /// 标签文本
  final String? labelText;

  /// 标签样式
  final TextStyle? labelStyle;

  // ========== 错误提示 ==========
  /// 错误文本
  final String? errorText;

  /// 错误文本颜色
  final Color errorColor;

  /// 错误文本样式
  final TextStyle? errorStyle;

  // ========== 辅助文本 ==========
  /// 辅助文本
  final String? helperText;

  /// 辅助文本样式
  final TextStyle? helperStyle;

  /// 辅助文本最大行数
  final int? helperMaxLines;

  // ========== 计数器 ==========
  /// 计数器组件
  final Widget? counter;

  /// 计数器文本
  final String? counterText;

  /// 计数器样式
  final TextStyle? counterStyle;

  /// 前缀图标
  final Widget? prefixIcon;

  /// 前缀文本
  final String? prefixText;

  /// 前缀文本样式
  final TextStyle? prefixStyle;

  /// 前缀图标约束
  final BoxConstraints? prefixIconConstraints;

  /// 后缀图标
  final Widget? suffixIcon;

  /// 后缀文本
  final String? suffixText;

  /// 后缀文本样式
  final TextStyle? suffixStyle;

  /// 后缀图标约束
  final BoxConstraints? suffixIconConstraints;

  const SuperInput({
    super.key,
    // 基础属性
    required this.controller,
    this.originalText,
    // 文本样式
    this.color,
    this.fontSize = 14,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    // 焦点相关
    this.focusNode,
    this.autofocus = false,
    // 键盘相关
    this.superKeyboardType,
    this.textInputType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.decimalLength = 2,
    this.integerLength,
    // 布局相关
    this.isCollapsed = true,
    this.isDense = false,
    this.contentPadding,
    this.fillColor,
    this.expands = false,
    this.minLines = 1,
    this.maxLines = 1,
    // 行为控制
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.isClear,
    // 事件回调
    this.onTap,
    this.debounceTime,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    // 边框样式
    this.borderStyle = SuperInputBorderStyle.outline,
    this.borderRadius,
    this.borderWidth = 1.0,
    this.borderColor,
    this.borderFocusColor,
    this.borderErrorColor = const Color(0xFFFF0000),
    // 提示文本
    this.hintText,
    this.hintFontColor = const Color(0xFF999999),
    this.hintFontSize,
    // 标签
    this.label,
    this.labelText,
    this.labelStyle,
    // 错误提示
    this.errorText,
    this.errorColor = const Color(0xFFFF0000),
    this.errorStyle,
    // 辅助文本
    this.helperText,
    this.helperStyle,
    this.helperMaxLines,
    // 计数器
    this.counter,
    this.counterText,
    this.counterStyle,
    // 前缀
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.prefixIconConstraints,
    // 后缀
    this.suffixIcon,
    this.suffixText,
    this.suffixStyle,
    this.suffixIconConstraints,
  });

  @override
  State<SuperInput> createState() => _SuperInputState();
}

class _SuperInputState extends State<SuperInput> {
  List<TextInputFormatter> formatter = [];
  TextEditingController? _textController;
  FocusNode? _focusNode;
  TextInputType textInputType = TextInputType.text;
  bool _isClear = false;
  bool userClear = false;

  @override
  void initState() {
    super.initState();
    userClear = widget.isClear ?? SuperWidgetConfig.textFiledClear;
    if (widget.maxLength != null) formatter.add(LengthLimitingTextInputFormatter(widget.maxLength!));
    if (widget.inputFormatters != null) formatter.addAll(widget.inputFormatters!);

    _textController = widget.controller;
    if (widget.originalText != null) _textController?.text = widget.originalText ?? "";
    _focusNode = widget.focusNode ?? FocusNode();

    _isClear = userClear && _focusNode!.hasFocus && _textController!.text.isNotEmpty;
    _focusNode!.addListener(() {
      if (!mounted) return;
      setState(() {
        _isClear = userClear && _focusNode!.hasFocus && _textController!.text.isNotEmpty;
      });
    });
    _keyboard();
  }

  void _keyboard() {
    switch (widget.superKeyboardType) {
      case SuperKeyboardType.number:
        textInputType = TextInputType.number;
        formatter.add(FilteringTextInputFormatter.digitsOnly);
        break;
      case SuperKeyboardType.decimal:
        textInputType = const TextInputType.numberWithOptions(decimal: true);
        formatter.add(XNumberTextInputFormatter(maxDecimalLength: widget.decimalLength, maxIntegerLength: widget.integerLength, isAllowNegative: false));
        break;
      case SuperKeyboardType.decimalNegative:
        textInputType = const TextInputType.numberWithOptions(decimal: true, signed: true);
        formatter.add(XNumberTextInputFormatter(maxDecimalLength: widget.decimalLength, maxIntegerLength: widget.integerLength, isAllowNegative: true));
        break;
      case null:
        if (widget.textInputType != null) textInputType = widget.textInputType!;
    }
  }

  @override
  void didUpdateWidget(SuperInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.superKeyboardType != widget.superKeyboardType || oldWidget.textInputType != widget.textInputType) {
      _keyboard();
    }
  }

  /// 根据边框样式和颜色生成InputBorder
  InputBorder _border(Color color) {
    InputBorder inputBorder = InputBorder.none;

    switch (widget.borderStyle) {
      case SuperInputBorderStyle.outline:
        inputBorder = OutlineInputBorder(
          borderSide: BorderSide(color: color, width: widget.borderWidth),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        );
        break;
      case SuperInputBorderStyle.fill:
        inputBorder = OutlineInputBorder(
          borderSide: const BorderSide(style: BorderStyle.none),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        );
        break;
      case SuperInputBorderStyle.underline:
        inputBorder = UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: widget.borderWidth),
          borderRadius: widget.borderRadius ?? BorderRadius.zero,
        );
        break;
      case SuperInputBorderStyle.none:
        inputBorder = InputBorder.none;
        break;
    }
    return inputBorder;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      cursorWidth: 1,
      style: TextStyle(color: widget.color, fontSize: widget.fontSize ?? SuperWidgetConfig.defaultTextSize),
      keyboardType: textInputType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      inputFormatters: formatter,
      onTap: widget.debounceTime == 0
          ? widget.onTap
          : () {
              if (!ClickThrottlerUtils.canClick(Duration(milliseconds: widget.debounceTime ?? SuperWidgetConfig.debounceTime))) return;
              widget.onTap?.call();
            },
      onChanged: (text) {
        setState(() {
          _isClear = userClear && _focusNode!.hasFocus && _textController!.text.isNotEmpty;
        });
        widget.onChanged?.call(text);
      },
      expands: widget.expands,
      onSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      minLines: widget.minLines,
      maxLines: (widget.minLines != null && widget.maxLines != null && widget.minLines! > widget.maxLines!) ? widget.minLines : widget.maxLines,
      obscureText: widget.obscureText,
      textAlign: widget.textAlign,
      enabled: widget.enabled,
      focusNode: _focusNode,
      decoration: InputDecoration(
        isCollapsed: widget.isCollapsed,
        isDense: widget.isDense,
        label: widget.label,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: widget.hintFontColor, fontSize: widget.hintFontSize ?? widget.fontSize ?? SuperWidgetConfig.defaultTextSize),
        fillColor: widget.fillColor,
        filled: widget.fillColor != null,
        contentPadding: widget.contentPadding,
        border: _border(widget.borderColor ?? SuperWidgetConfig.etBorderColor),
        enabledBorder: _border(widget.borderColor ?? SuperWidgetConfig.etBorderColor),
        focusedBorder: _border(widget.borderFocusColor ?? Theme.of(context).colorScheme.primary),
        errorBorder: _border(widget.borderErrorColor),
        focusedErrorBorder: _border(widget.borderErrorColor),
        counter: widget.counter,
        counterText: widget.counterText,
        counterStyle: widget.counterStyle,
        errorText: widget.errorText,
        errorStyle: widget.errorStyle,
        helperText: widget.helperText,
        helperStyle: widget.helperStyle,
        helperMaxLines: widget.helperMaxLines,
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: widget.prefixIconConstraints ?? const BoxConstraints(minHeight: 24, minWidth: 32),
        prefixText: widget.prefixText,
        prefixStyle: widget.prefixStyle,
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _defaultClearIcon(_isClear),
            if (widget.suffixIcon != null) widget.suffixIcon!,
          ],
        ),
        suffixIconConstraints: widget.suffixIconConstraints ?? const BoxConstraints(minHeight: 24, minWidth: 32),
        suffixText: widget.suffixText,
        suffixStyle: widget.suffixStyle,
      ),
    );
  }

  Widget _defaultClearIcon(bool isClear) {
    return Visibility(
      visible: isClear && !widget.readOnly,
      child: GestureDetector(
        onTap: () {
          if (mounted) {
            _textController?.clear();
            setState(() {});
            widget.onClear?.call();
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(4),
          child: Icon(
            CupertinoIcons.clear_circled,
            size: 18,
            color: Color(0xff909399),
          ),
        ),
      ),
    );
  }
}
