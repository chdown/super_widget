import 'package:flutter/material.dart';
import 'package:super_widget/super_widget.dart';

class SuperPopupDemo extends StatefulWidget {
  const SuperPopupDemo({super.key});

  @override
  State<SuperPopupDemo> createState() => _SuperPopupDemoState();
}

class _SuperPopupDemoState extends State<SuperPopupDemo> {
  String _lastAction = '等待操作...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SuperPopup 测试'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('测试说明'),
                  content: const Text(
                    '1. 测试不同位置的弹窗\n'
                    '2. 测试屏幕旋转后弹窗位置是否正确\n'
                    '3. 测试长按和点击触发\n'
                    '4. 测试自定义样式',
                  ),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('知道了'))],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 状态显示
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('最后操作:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(_lastAction),
                  const SizedBox(height: 8),
                  Text(
                    '屏幕方向: ${MediaQuery.of(context).orientation == Orientation.portrait ? "竖屏" : "横屏"}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                  Text(
                    '屏幕尺寸: ${MediaQuery.of(context).size.width.toInt()} x ${MediaQuery.of(context).size.height.toInt()}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 测试区域标题
            const Text('位置测试', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 顶部按钮
            Center(
              child: SuperPopup(
                content: _buildPopupContent('顶部弹窗', '这是一个在顶部的弹窗'),
                onBeforePopup: () => setState(() => _lastAction = '顶部弹窗打开'),
                onAfterPopup: () => setState(() => _lastAction = '顶部弹窗关闭'),
                child: ElevatedButton(onPressed: null, child: const Text('顶部按钮 (点击触发)')),
              ),
            ),
            const SizedBox(height: 200),

            // 中间按钮
            Center(
              child: SuperPopup(
                position: PopupPosition.auto,
                content: _buildPopupContent('中间弹窗', '位置会自动选择上方或下方'),
                onBeforePopup: () => setState(() => _lastAction = '中间弹窗打开'),
                onAfterPopup: () => setState(() => _lastAction = '中间弹窗关闭'),
                child: ElevatedButton(onPressed: null, child: const Text('中间按钮 (自动位置)')),
              ),
            ),
            const SizedBox(height: 200),

            // 底部按钮
            Center(
              child: SuperPopup(
                position: PopupPosition.top,
                content: _buildPopupContent('底部弹窗', '强制显示在上方'),
                onBeforePopup: () => setState(() => _lastAction = '底部弹窗打开'),
                onAfterPopup: () => setState(() => _lastAction = '底部弹窗关闭'),
                child: ElevatedButton(onPressed: null, child: const Text('底部按钮 (强制上方)')),
              ),
            ),
            const SizedBox(height: 40),

            const Divider(height: 40),

            // 样式测试
            const Text('样式测试', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                // 长按触发
                SuperPopup(
                  isLongPress: true,
                  content: _buildPopupContent('长按触发', '需要长按按钮才能显示'),
                  backgroundColor: Colors.purple.shade50,
                  arrowColor: Colors.purple.shade50,
                  onBeforePopup: () => setState(() => _lastAction = '长按弹窗打开'),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                    onPressed: null,
                    child: const Text('长按我'),
                  ),
                ),

                // 无箭头
                SuperPopup(
                  showArrow: false,
                  content: _buildPopupContent('无箭头', '这个弹窗没有箭头'),
                  backgroundColor: Colors.orange.shade50,
                  onBeforePopup: () => setState(() => _lastAction = '无箭头弹窗打开'),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                    onPressed: null,
                    child: const Text('无箭头'),
                  ),
                ),

                // 自定义装饰
                SuperPopup(
                  contentDecoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.pink.shade100, Colors.purple.shade100], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 4))],
                  ),
                  arrowColor: Colors.pink.shade100,
                  contentPadding: const EdgeInsets.all(16),
                  onBeforePopup: () => setState(() => _lastAction = '渐变弹窗打开'),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
                    onPressed: null,
                    child: const Text('渐变样式'),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '深色弹窗',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text('使用深色主题', style: TextStyle(color: Colors.grey.shade300, fontSize: 14)),
                    ],
                  ),
                ),

                // 深色主题
                SuperPopup(
                  backgroundColor: Colors.grey.shade800,
                  arrowColor: Colors.grey.shade800,
                  barrierColor: Colors.black.withOpacity(0.3),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '深色弹窗',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text('使用深色主题', style: TextStyle(color: Colors.grey.shade300, fontSize: 14)),
                    ],
                  ),
                  onBeforePopup: () => setState(() => _lastAction = '深色弹窗打开'),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade800, foregroundColor: Colors.white),
                    onPressed: null,
                    child: const Text('深色主题'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            const Divider(height: 40),

            // 内容测试
            const Text('内容测试', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Center(
              child: SuperPopup(
                content: SizedBox(
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const SizedBox(height: 12),
                      const Text('操作成功', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('这是一个包含图标和多行文本的弹窗示例', textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(onPressed: () {}, child: const Text('取消')),
                          ElevatedButton(onPressed: () {}, child: const Text('确定')),
                        ],
                      ),
                    ],
                  ),
                ),
                onBeforePopup: () => setState(() => _lastAction = '复杂内容弹窗打开'),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: null,
                  child: const Text('复杂内容'),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 提示信息
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.amber.shade700),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('尝试旋转屏幕，测试弹窗位置是否正确计算！', style: TextStyle(fontSize: 14))),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupContent(String title, String description) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
