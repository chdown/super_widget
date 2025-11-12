import 'package:flutter/material.dart';
import 'package:super_widget/super_widget.dart';

/// SuperTooltip 键盘感知测试页面
/// 测试当软键盘打开时，Tooltip 是否能正确调整位置
class SuperTooltipKeyboardTest extends StatefulWidget {
  const SuperTooltipKeyboardTest({super.key});

  @override
  State<SuperTooltipKeyboardTest> createState() => _SuperTooltipKeyboardTestState();
}

class _SuperTooltipKeyboardTestState extends State<SuperTooltipKeyboardTest> {
  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  late FocusNode _focusNode3;
  String _testStatus = '准备好测试...';
  double _keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 获取键盘高度
    _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SuperTooltip 键盘感知测试'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 键盘状态卡片
              _buildKeyboardStatusCard(context),
              const SizedBox(height: 24),

              // 场景1：输入框位于屏幕上方
              _buildScenarioCard(
                title: '场景 1: 输入框在屏幕上方',
                description: '测试当输入框在屏幕上方时，Tooltip 向下显示，不被键盘遮挡',
                onTap: () => setState(() => _testStatus = '场景 1: 输入框在屏幕上方 - 聚焦输入框'),
                focusNode: _focusNode1,
              ),
              const SizedBox(height: 16),

              // 场景2：输入框位于屏幕中间
              _buildScenarioCard(
                title: '场景 2: 输入框在屏幕中间',
                description: '测试当输入框在屏幕中间时，Tooltip 自动判断方向，避免被键盘遮挡',
                onTap: () => setState(() => _testStatus = '场景 2: 输入框在屏幕中间 - 聚焦输入框'),
                focusNode: _focusNode2,
              ),
              const SizedBox(height: 16),

              // 场景3：输入框位于屏幕下方
              _buildScenarioCard(
                title: '场景 3: 输入框在屏幕下方',
                description: '测试当输入框在屏幕下方时，Tooltip 向上显示，避免被键盘完全遮挡',
                onTap: () => setState(() => _testStatus = '场景 3: 输入框在屏幕下方 - 聚焦输入框'),
                focusNode: _focusNode3,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardStatusCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final effectiveHeight = screenHeight - _keyboardHeight;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _keyboardHeight > 0 ? Icons.keyboard : Icons.keyboard_hide,
                  color: _keyboardHeight > 0 ? Colors.red : Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _keyboardHeight > 0 ? '键盘已打开' : '键盘已关闭',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _keyboardHeight > 0 ? Colors.red : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _testStatus,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 尺寸信息
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('屏幕高度:', '${screenHeight.toInt()} px'),
                  _buildInfoRow('键盘高度:', '${_keyboardHeight.toInt()} px'),
                  _buildInfoRow('有效屏幕高度:', '${effectiveHeight.toInt()} px'),
                  _buildInfoRow('空间占用比:', '${(_keyboardHeight / screenHeight * 100).toStringAsFixed(1)}%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildScenarioCard({
    required String title,
    required String description,
    required VoidCallback onTap,
    required FocusNode focusNode,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            // 输入框和 Tooltip
            Row(
              children: [
                Expanded(
                  child: SuperTooltip(
                    content: _buildTooltipContent(title),
                    position: TooltipPosition.auto,
                    barrierColor: Colors.black.withOpacity(0.3),
                    onBeforeShow: onTap,
                    child: SuperText('点击输入框并查看 Tooltip'),
                  ),
                ),
              ],
            ),
            TextField(
              focusNode: focusNode,
              onTap: () => setState(() => _testStatus = '$title - 输入框已聚焦'),
              decoration: InputDecoration(
                hintText: '点击输入框并查看 Tooltip',
                prefixIcon: const Icon(Icons.edit),
                suffixIcon: const Icon(Icons.info_outline, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '✓ 点击输入框打开键盘，观察 Tooltip 的位置调整',
              style: TextStyle(fontSize: 11, color: Colors.blue.shade600, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTooltipContent(String scenarioTitle) {
    return SuperText("text");
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scenarioTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '这个 Tooltip 会自动调整位置：\n'
            '• 检测键盘高度\n'
            '• 计算有效屏幕空间\n'
            '• 智能选择显示方向\n'
            '• 避免被键盘遮挡',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 14, color: Colors.greenAccent),
                const SizedBox(width: 4),
                Text(
                  '键盘感知: ${_keyboardHeight > 0 ? "已启用" : "未触发"}',
                  style: const TextStyle(fontSize: 11, color: Colors.greenAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.amber.shade50,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 8),
                Text(
                  '键盘感知原理',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.amber.shade900),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildExplanationItem(
              '1. 动态检测',
              '通过 MediaQuery.of(context).viewInsets.bottom 获取键盘高度',
            ),
            const SizedBox(height: 8),
            _buildExplanationItem(
              '2. 有效屏幕计算',
              'effectiveScreenHeight = screenHeight - keyboardHeight',
            ),
            const SizedBox(height: 8),
            _buildExplanationItem(
              '3. 智能定位',
              '根据有效屏幕高度判断 Tooltip 应显示在上方还是下方',
            ),
            const SizedBox(height: 8),
            _buildExplanationItem(
              '4. 位置调整',
              '在计算可见区域和边界时，都使用有效屏幕高度',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildTestTipsCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.cyan.shade50,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.cyan.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.cyan.shade700, size: 20),
                const SizedBox(width: 8),
                Text(
                  '测试指南',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.cyan.shade900),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem(
              '✓ 点击输入框打开软键盘',
              '观察 Tooltip 如何根据有效屏幕高度调整位置',
            ),
            const SizedBox(height: 8),
            _buildTipItem(
              '✓ 在不同输入框之间切换',
              '查看 Tooltip 是否能正确识别当前屏幕可用空间',
            ),
            const SizedBox(height: 8),
            _buildTipItem(
              '✓ 关闭键盘',
              '验证 Tooltip 是否恢复到初始位置',
            ),
            const SizedBox(height: 8),
            _buildTipItem(
              '✓ 旋转屏幕（如果支持）',
              '测试不同屏幕尺寸下的键盘感知能力',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}

