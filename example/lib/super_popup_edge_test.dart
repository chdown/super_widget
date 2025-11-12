import 'package:flutter/material.dart';
import 'package:super_widget/super_widget.dart';

/// 边缘和全屏测试页面
class SuperPopupEdgeTest extends StatefulWidget {
  const SuperPopupEdgeTest({super.key});

  @override
  State<SuperPopupEdgeTest> createState() => _SuperPopupEdgeTestState();
}

class _SuperPopupEdgeTestState extends State<SuperPopupEdgeTest> {
  String _lastAction = '等待操作...';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('边缘场景测试'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Stack(
        children: [
          // 状态显示 - 悬浮在右下角
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '最后操作:',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(_lastAction, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
          ),

          // 四个角落的按钮
          // 左上角
          Positioned(
            left: 16,
            top: 16,
            child: SuperPopup(
              position: PopupPosition.auto,
              content: _buildPopupContent('左上角', '弹窗应该向下或向右显示'),
              onBeforePopup: () => setState(() => _lastAction = '左上角弹窗打开'),
              onAfterPopup: () => setState(() => _lastAction = '左上角弹窗关闭'),
              child: _buildCornerButton('左上角', Colors.red),
            ),
          ),

          // 右上角
          Positioned(
            right: 16,
            top: 16,
            child: SuperPopup(
              position: PopupPosition.auto,
              content: _buildPopupContent('右上角', '弹窗应该向下或向左显示'),
              onBeforePopup: () => setState(() => _lastAction = '右上角弹窗打开'),
              onAfterPopup: () => setState(() => _lastAction = '右上角弹窗关闭'),
              child: _buildCornerButton('右上角', Colors.blue),
            ),
          ),

          // 左下角
          Positioned(
            left: 16,
            bottom: 100,
            child: SuperPopup(
              position: PopupPosition.auto,
              content: _buildPopupContent('左下角', '弹窗应该向上或向右显示'),
              onBeforePopup: () => setState(() => _lastAction = '左下角弹窗打开'),
              onAfterPopup: () => setState(() => _lastAction = '左下角弹窗关闭'),
              child: _buildCornerButton('左下角', Colors.green),
            ),
          ),

          // 右下角（避开状态显示）
          Positioned(
            right: 16,
            bottom: 250,
            child: SuperPopup(
              position: PopupPosition.auto,
              content: _buildPopupContent('右下角', '弹窗应该向上或向左显示'),
              onBeforePopup: () => setState(() => _lastAction = '右下角弹窗打开'),
              onAfterPopup: () => setState(() => _lastAction = '右下角弹窗关闭'),
              child: _buildCornerButton('右下角', Colors.orange),
            ),
          ),

          // 中心区域的测试
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '边缘测试',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                const Text('点击四个角落的按钮测试边缘场景', style: TextStyle(fontSize: 14, color: Colors.black45)),
                const SizedBox(height: 32),

                // 中心弹窗
                SuperPopup(
                  position: PopupPosition.auto,
                  content: _buildPopupContent('中心弹窗', '在屏幕中央，可以向任意方向显示'),
                  onBeforePopup: () => setState(() => _lastAction = '中心弹窗打开'),
                  onAfterPopup: () => setState(() => _lastAction = '中心弹窗关闭'),
                  child: ElevatedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.center_focus_strong),
                    label: const Text('中心位置'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 滚动列表测试按钮
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FullScreenPopupTest()));
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('可滚动列表测试'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          // 屏幕边缘中点的按钮
          // 顶部中心
          Positioned(
            left: size.width / 2 - 50,
            top: 16,
            child: SuperPopup(
              position: PopupPosition.auto,
              content: _buildPopupContent('顶部中心', '弹窗应该向下显示'),
              onBeforePopup: () => setState(() => _lastAction = '顶部中心弹窗打开'),
              onAfterPopup: () => setState(() => _lastAction = '顶部中心弹窗关闭'),
              child: _buildEdgeButton('顶', Colors.teal),
            ),
          ),

          // 底部中心
          Positioned(
            left: size.width / 2 - 50,
            bottom: 100,
            child: SuperPopup(
              position: PopupPosition.auto,
              content: _buildPopupContent('底部中心', '弹窗应该向上显示'),
              onBeforePopup: () => setState(() => _lastAction = '底部中心弹窗打开'),
              onAfterPopup: () => setState(() => _lastAction = '底部中心弹窗关闭'),
              child: _buildEdgeButton('底', Colors.cyan),
            ),
          ),

          // 左侧中心
          Positioned(
            left: 16,
            top: size.height / 2 - 70,
            child: SuperPopup(
              position: PopupPosition.auto,
              content: _buildPopupContent('左侧中心', '弹窗应该向右或上下显示'),
              onBeforePopup: () => setState(() => _lastAction = '左侧中心弹窗打开'),
              onAfterPopup: () => setState(() => _lastAction = '左侧中心弹窗关闭'),
              child: _buildEdgeButton('左', Colors.lime),
            ),
          ),

          // 右侧中心
          Positioned(
            right: 16,
            top: size.height / 2 - 70,
            child: SuperPopup(
              position: PopupPosition.auto,
              content: _buildPopupContent('右侧中心', '弹窗应该向左或上下显示'),
              onBeforePopup: () => setState(() => _lastAction = '右侧中心弹窗打开'),
              onAfterPopup: () => setState(() => _lastAction = '右侧中心弹窗关闭'),
              child: _buildEdgeButton('右', Colors.amber),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerButton(String label, Color color) {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildEdgeButton(String label, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        const SizedBox(height: 8),
        Text(
          '屏幕: ${MediaQuery.of(context).size.width.toInt()} x ${MediaQuery.of(context).size.height.toInt()}',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

/// 可滚动列表中的弹窗测试
class FullScreenPopupTest extends StatefulWidget {
  const FullScreenPopupTest({super.key});

  @override
  State<FullScreenPopupTest> createState() => _FullScreenPopupTestState();
}

class _FullScreenPopupTestState extends State<FullScreenPopupTest> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('可滚动列表测试'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('滚动测试场景', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text('滚动位置: ${_scrollPosition.toInt()}px', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildListItem(index);
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'top',
            onPressed: () {
              _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
            child: const Icon(Icons.arrow_upward),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'bottom',
            onPressed: () {
              _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
            child: const Icon(Icons.arrow_downward),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(int index) {
    // 不同类型的列表项
    if (index == 0) {
      return _buildHeaderCard();
    } else if (index == 49) {
      return _buildFooterCard();
    } else if (index % 10 == 0) {
      return _buildSectionHeader(index);
    } else if (index % 5 == 0) {
      return _buildComplexItem(index);
    } else {
      return _buildNormalItem(index);
    }
  }

  Widget _buildHeaderCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.purple.shade400, Colors.blue.shade400], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '可滚动列表测试',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('这个页面模拟真实场景：\n• 长列表内容\n• 不同位置的弹窗\n• 滚动时弹窗行为', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 16),
            SuperPopup(
              contentBackgroundColor: Colors.white,
              arrowColor: Colors.white,
              content: const Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('顶部弹窗', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
                    Text('这个按钮在列表顶部\n弹窗应该向下显示', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.touch_app),
                label: const Text('点击测试顶部弹窗'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterCard() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.red.shade400], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '列表底部',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('测试底部元素的弹窗表现', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 16),
            SuperPopup(
              contentBackgroundColor: Colors.white,
              arrowColor: Colors.white,
              position: PopupPosition.auto,
              content: const Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('底部弹窗', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
                    Text('这个按钮在列表底部\n弹窗应该向上显示\n避免超出屏幕', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.touch_app),
                label: const Text('点击测试底部弹窗'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.folder, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '第 ${(index ~/ 10) + 1} 组 (项目 #$index)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade800),
            ),
          ),
          SuperPopup(
            content: Padding(padding: const EdgeInsets.all(8), child: Text('组 ${(index ~/ 10) + 1} 的信息')),
            child: IconButton(icon: Icon(Icons.info_outline, color: Colors.blue.shade400), onPressed: null),
          ),
        ],
      ),
    );
  }

  Widget _buildComplexItem(int index) {
    return SuperPopup(
      contentBackgroundColor: Colors.red.shade50,
      arrowColor: Colors.red.shade50,
      content: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete, color: Colors.red.shade400, size: 32),
            const SizedBox(height: 8),
            const Text('确认删除？', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('项目 #$index', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: Colors.primaries[index % Colors.primaries.length].shade100, borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.image, color: Colors.primaries[index % Colors.primaries.length], size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('复杂项目 #$index', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 800),
                    Text('这是一个包含更多内容的列表项\n测试在复杂布局中的弹窗表现', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SuperPopup(
                          content: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.share, color: Colors.green, size: 32),
                                const SizedBox(height: 8),
                                Text('分享项目 #$index'),
                              ],
                            ),
                          ),
                          child: TextButton.icon(onPressed: null, icon: const Icon(Icons.share, size: 16), label: const Text('分享')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNormalItem(int index) {
    final color = Colors.primaries[index % Colors.primaries.length];
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.shade100,
          child: Text(
            '$index',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text('列表项 #$index'),
        subtitle: Text('滚动位置: ${_scrollPosition.toInt()}px'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SuperPopup(
              content: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('项目 #$index 详情', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('这是一个简单的弹窗提示', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              child: IconButton(icon: const Icon(Icons.more_vert), onPressed: null),
            ),
          ],
        ),
      ),
    );
  }
}
