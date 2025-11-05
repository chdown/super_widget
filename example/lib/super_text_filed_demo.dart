import 'package:flutter/material.dart';
import 'package:super_widget/super_widget.dart';

/// SuperInput 功能演示页面
class SuperTextFiledDemo extends StatefulWidget {
  const SuperTextFiledDemo({super.key});

  @override
  State<SuperTextFiledDemo> createState() => _SuperTextFiledDemoState();
}

class _SuperTextFiledDemoState extends State<SuperTextFiledDemo> {
  // 各种测试用的控制器
  final TextEditingController _basicController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _decimalController = TextEditingController();
  final TextEditingController _decimalNegativeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _multilineController = TextEditingController();
  final TextEditingController _readonlyController = TextEditingController(text: '只读文本');
  final TextEditingController _disabledController = TextEditingController(text: '禁用状态');
  final TextEditingController _withBorderController = TextEditingController();
  final TextEditingController _withPrefixSuffixController = TextEditingController();
  final TextEditingController _validationController = TextEditingController();
  final TextEditingController _customStyleController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  String _changeLog = '';
  String _validationError = '';

  @override
  void initState() {
    super.initState();
    _validationController.addListener(_validateEmail);
  }

  void _validateEmail() {
    final text = _validationController.text;
    setState(() {
      if (text.isEmpty) {
        _validationError = '';
      } else if (!text.contains('@')) {
        _validationError = '请输入有效的邮箱地址';
      } else {
        _validationError = '';
      }
    });
  }

  @override
  void dispose() {
    _basicController.dispose();
    _numberController.dispose();
    _decimalController.dispose();
    _decimalNegativeController.dispose();
    _passwordController.dispose();
    _multilineController.dispose();
    _readonlyController.dispose();
    _disabledController.dispose();
    _withBorderController.dispose();
    _withPrefixSuffixController.dispose();
    _validationController.dispose();
    _customStyleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        ...children,
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SuperTextFile 组件测试'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== 基础输入 ==========
            _buildSection('1. 基础输入', [
              _buildLabel('基础文本输入框'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _basicController,
                hintText: '请输入内容...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isClear: true,
              ),
              _buildLabel('带原始文本'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: TextEditingController(),
                originalText: '这是原始文本',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ]),

            // ========== 键盘类型 ==========
            _buildSection('2. 键盘类型', [
              _buildLabel('纯数字输入 (SuperKeyboardType.number)'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _numberController,
                hintText: '只能输入数字',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                maxLength: 10,
              ),
              _buildLabel('小数输入 (SuperKeyboardType.decimal, 2位小数)'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _decimalController,
                decimalLength: 2,
                integerLength: 6,
                hintText: '可输入小数，最多2位',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              _buildLabel('负数小数输入 (SuperKeyboardType.decimalNegative)'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _decimalNegativeController,
                keyboardType: KeyboardType.decimalNegative,
                decimalLength: 3,
                hintText: '可输入负数和小数',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ]),

            // ========== 特殊输入 ==========
            _buildSection('3. 特殊输入', [
              _buildLabel('密码输入框'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _passwordController,
                obscureText: true,
                hintText: '请输入密码',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              _buildLabel('多行文本输入 (3-5行)'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _multilineController,
                minLines: 3,
                maxLines: 5,
                hintText: '请输入多行文本...',
                contentPadding: const EdgeInsets.all(12),
              ),
            ]),

            // ========== 状态控制 ==========
            _buildSection('4. 状态控制', [
              _buildLabel('只读状态'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _readonlyController,
                readOnly: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                fillColor: Colors.grey[100],
              ),
              _buildLabel('禁用状态'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _disabledController,
                enabled: false,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ]),

            // ========== 边框样式 ==========
            _buildSection('5. 边框样式', [
              _buildLabel('自定义边框颜色'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _withBorderController,
                hintText: '蓝色边框',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              _buildLabel('下划线边框'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: TextEditingController(),
                hintText: '下划线样式',
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ]),

            // ========== 前缀后缀 ==========
            _buildSection('6. 前缀和后缀', [
              _buildLabel('带前缀图标和后缀文本'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _withPrefixSuffixController,
                hintText: '请输入金额',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
                suffixText: '元',
                keyboardType: KeyboardType.decimal,
                decimalLength: 2,
              ),
              _buildLabel('带前缀文本'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: TextEditingController(),
                hintText: '请输入网址',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                prefixText: 'https://',
                prefixStyle: const TextStyle(color: Colors.blue),
              ),
            ]),

            // ========== 验证和提示 ==========
            _buildSection('7. 验证和提示', [
              _buildLabel('邮箱验证'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _validationController,
                hintText: '请输入邮箱',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                errorText: _validationError.isEmpty ? null : _validationError,
                prefixIcon: const Icon(Icons.email),
                helperText: '输入完整的邮箱地址',
              ),
              _buildLabel('带字符计数'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: TextEditingController(),
                hintText: '最多输入50个字符',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                maxLength: 50,
                counterText: '',
              ),
            ]),

            // ========== 自定义样式 ==========
            _buildSection('8. 自定义样式', [
              _buildLabel('自定义文本颜色和大小'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: _customStyleController,
                hintText: '自定义样式',
                color: Colors.purple,
                fontSize: 18,
                hintFontColor: Colors.purple[200],
                hintFontSize: 16,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                fillColor: Colors.purple[50],
              ),
              _buildLabel('带标签的输入框'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: TextEditingController(),
                labelText: '用户名',
                hintText: '请输入用户名',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                prefixIcon: const Icon(Icons.person),
              ),
            ]),

            // ========== 事件回调 ==========
            _buildSection('9. 事件回调', [
              _buildLabel('onChange 事件监听'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: TextEditingController(),
                hintText: '输入内容会显示在下方',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onChanged: (text) {
                  setState(() {
                    _changeLog = '当前输入: $text';
                  });
                },
              ),
              if (_changeLog.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_changeLog, style: const TextStyle(color: Colors.green)),
                ),
              _buildLabel('onSubmitted 事件（按回车触发）'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: TextEditingController(),
                hintText: '输入后按回车',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textInputAction: TextInputAction.done,
                onSubmitted: (text) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('提交内容: $text')));
                },
              ),
              _buildLabel('onTap 事件（带防抖500ms）'),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                controller: TextEditingController(),
                hintText: '点击输入框',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                readOnly: true,
                debounceTime: 500,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('输入框被点击')));
                },
              ),
            ]),

            // ========== 复杂场景 ==========
            _buildSection('10. 复杂场景', [
              _buildLabel('表单组合示例'),
              Column(
                children: [
                  SuperTextFiled(
                    style: TextFiledStyle.outline,
                    controller: TextEditingController(),
                    labelText: '姓名',
                    hintText: '请输入姓名',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 12),
                  SuperTextFiled(
                    style: TextFiledStyle.outline,
                    controller: TextEditingController(),
                    labelText: '手机号',
                    hintText: '请输入手机号',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    prefixIcon: const Icon(Icons.phone),
                    keyboardType: KeyboardType.number,
                    maxLength: 11,
                    counterText: '',
                  ),
                  const SizedBox(height: 12),
                  SuperTextFiled(
                    style: TextFiledStyle.outline,
                    controller: TextEditingController(),
                    labelText: '地址',
                    hintText: '请输入详细地址',
                    contentPadding: const EdgeInsets.all(12),
                    prefixIcon: const Icon(Icons.location_on),
                    minLines: 3,
                    maxLines: 5,
                  ),
                ],
              ),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
