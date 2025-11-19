import 'package:example/super_text_filed_demo.dart';
import 'package:flutter/material.dart';
import 'package:super_widget/super_widget.dart';

/// SuperTooltip 键盘 + 滚动列表复杂场景测试
/// 测试当键盘打开且在滚动列表中时，Tooltip 的表现
class SuperTooltipKeyboardScrollTest extends StatefulWidget {
  const SuperTooltipKeyboardScrollTest({super.key});

  @override
  State<SuperTooltipKeyboardScrollTest> createState() => _SuperTooltipKeyboardScrollTestState();
}

class _SuperTooltipKeyboardScrollTestState extends State<SuperTooltipKeyboardScrollTest> {
  final ScrollController _scrollController = ScrollController();
  late FocusNode _inputFocusNode;
  double _keyboardHeight = 0;
  String _statusMessage = '准备好测试...';

  @override
  void initState() {
    super.initState();
    _inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final effectiveHeight = screenHeight - _keyboardHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tooltip 键盘+滚动复杂场景'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 状态栏
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(bottom: BorderSide(color: Colors.blue.shade200)),
            ),
            child: Row(
              children: [
                Icon(
                  _keyboardHeight > 0 ? Icons.keyboard : Icons.keyboard_hide,
                  color: _keyboardHeight > 0 ? Colors.red : Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _statusMessage,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '键盘: ${_keyboardHeight.toInt()}px | 有效高度: ${effectiveHeight.toInt()}px',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 列表
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: 30,
              itemBuilder: (context, index) {
                return _buildListItem(index);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: SuperTooltip(
              content: Container(
                decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '搜索功能提示',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '当打开键盘时，Tooltip 会自动调整位置\n当前键盘高度: ${_keyboardHeight.toInt()}px',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ),
              position: TooltipPosition.bottom,
              onBeforeShow: () {
                setState(() => _statusMessage = '搜索框 Tooltip 显示');
              },
              child: TextField(
                focusNode: _inputFocusNode,
                onChanged: (value) {
                  setState(() => _statusMessage = '正在搜索: $value');
                },
                decoration: InputDecoration(
                  hintText: '搜索项目...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.filter_list),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_inputFocusNode.hasFocus) {
            _inputFocusNode.unfocus();
            setState(() => _statusMessage = '键盘已关闭');
          } else {
            _inputFocusNode.requestFocus();
            setState(() => _statusMessage = '键盘已打开');
          }
        },
        tooltip: '切换键盘',
        child: Icon(_inputFocusNode.hasFocus ? Icons.keyboard_hide : Icons.keyboard),
      ),
    );
  }

  Widget _buildListItem(int index) {
    if (index == 0) {
      return _buildInfoCard();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '项目 #${index.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '这是一个测试项目，点击右侧按钮查看详情',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SuperTooltip(
                  content: _buildItemTooltip(index),
                  position: TooltipPosition.auto,
                  barrierColor: Colors.black.withOpacity(0.3),
                  onBeforeShow: () {
                    setState(() => _statusMessage = '项目 #${index.toString().padLeft(2, '0')} Tooltip 显示');
                    Future.delayed(Duration(seconds: 3),() {
                      Navigator.pushNamed(context, '/expandable_text');
                    },);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 标签
            Wrap(
              spacing: 6,
              children: [
                _buildTag('标签1', Colors.blue),
                _buildTag('标签2', Colors.green),
                _buildTag('标签3', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📱 键盘 + 滚动列表复杂场景',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildInfoItem('场景模拟', '真实应用中的搜索列表场景'),
            _buildInfoItem('测试焦点', '键盘打开时 Tooltip 的位置调整'),
            _buildInfoItem('预期结果', 'Tooltip 避免被键盘和其他元素遮挡'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SuperTooltip(
                    content: const Text('尝试这些操作来验证键盘感知功能', style: TextStyle(color: Colors.white)),
                    position: TooltipPosition.bottom,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '✓ 长按查看操作提示',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTooltip(int index) {
    return Container(
      decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '项目详情 #${index.toString().padLeft(2, '0')}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            '• 键盘已集成到位置计算\n'
            '• 有效屏幕高度动态更新\n'
            '• Tooltip 自动调整显示方向',
            style: TextStyle(fontSize: 12, color: Colors.white, height: 1.6),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 14, color: Colors.greenAccent),
              const SizedBox(width: 4),
              Text(
                '键盘感知: ${_keyboardHeight > 0 ? "已启用" : "待触发"}',
                style: const TextStyle(fontSize: 11, color: Colors.greenAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}

