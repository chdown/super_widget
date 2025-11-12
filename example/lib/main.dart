import 'package:example/super_input_demo.dart';
import 'package:example/super_popup_demo.dart';
import 'package:example/super_popup_edge_test.dart';
import 'package:example/super_text_filed_demo.dart' hide SuperInputDemo;
import 'package:example/super_tooltip_test.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'super_expandable_text_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/expandable_text': (context) => const SuperExpandableTextExample(),
        '/super_input': (context) => const SuperInputDemo(),
        '/super_text_filed': (context) => const SuperTextFiledDemo(),
        '/super_popup': (context) => const SuperPopupDemo(),
        '/super_popup_edge': (context) => const SuperPopupEdgeTest(),
        '/super_tooltip_test': (context) => const SuperTooltipTest(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    ExtendedImage.globalStateWidgetBuilder = (BuildContext context, ExtendedImageState state) {
      switch (state.extendedImageLoadState) {
        case LoadState.loading:
          return Container(
            alignment: Alignment.center,
            child: Theme.of(context).platform == TargetPlatform.iOS
                ? const CupertinoActivityIndicator(animating: true, radius: 16.0)
                : CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          );

        case LoadState.completed:
          return state.completedWidget;
        case LoadState.failed:
          return Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                state.reLoadImage();
              },
              child: const Icon(Icons.image_not_supported_outlined),
            ),
          );
      }
    };
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/expandable_text');
                },
                child: const Text('查看 SuperExpandableText 示例'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/super_input');
                },
                child: const Text('查看 super_input 示例'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/super_text_filed');
                },
                child: const Text('查看 super_text_filed 示例'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/super_popup');
                },
                child: const Text('查看 CustomPopup 示例'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/super_popup_edge');
                },
                child: const Text('super_popup_edge 边缘/全屏测试'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/super_tooltip_test');
                },
                child: const Text('super_tooltip_test 边缘/全屏测试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
