import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_widget/super_widget.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  TextEditingController textEditingController = TextEditingController(text: "在VideoItemWidget中添加了对房主信息的检查中添加了对房主信息的检查中添加了对房主信息的检查");
  TextEditingController textEditingController1 = TextEditingController(text: "在VideoItemWidget中添加了对房主信息的检查中添加了对房主信息的检查中添加了对房主信息的检查");

  void _incrementCounter() {
    print(DateTime.now().millisecondsSinceEpoch);
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    ExtendedImage.globalStateWidgetBuilder = (
      BuildContext context,
      ExtendedImageState state,
    ) {
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              // SuperRichText(
              //   textAlign: TextAlign.center,
              //   text: "161.7万",
              //   fontSize: 32,
              //   fontWeight: FontWeight.w600,
              //   textEndSpace: 8,
              //   suffixText: '获赞',
              //   suffixFontSize: 26,
              //   suffixColor: Colors.blue,
              // ),
              SuperButton(
                  type: ButtonType.filled,
                  text: "text",
                  onTap: () {
                    print("11111111111111111111111111111");
                  }),
              SuperTextFiled(
                style: TextFiledStyle.outline,
                hintText: "hintText",
                heightH: 40,
                paddingHorizontal: 30,
                paddingRight: 30,
                isCollapsed: true,
                controller: textEditingController,
              ),
              TextField(
                controller: textEditingController1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                ),
              ),
              // SizedBox(
              //   height: 50,
              //   child: SuperTextFiled(
              //     style: TextFiledStyle.outline,
              //     controller: textEditingController1,
              //   ),
              // ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
