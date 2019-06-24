import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_gdt/flutter_gdt.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterGdt _gdt;
  String _platformVersion = 'Unknown';

  bool showGdt = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformVersion = await FlutterGdt.platformVersion;
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }
    // await FlutterGdt.showNativeExpressAd;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });
  }

  void _onAdViewWidgetCreated(FlutterGdt gdt) {
    _gdt = gdt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: new Container(
                child: InkWell(
                  child: new Container(
                    width: 150,
                    height: 50,
                    color: Colors.red,
                    child: Text(
                      '点击看广告111',
                    ),
                  ),
                  onTap: () {
                    //点击
                    setState(() {
                      showGdt = true;
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 310,
                height: 487,
                color: Colors.yellow,
                child: GDTAdView(
                  appId: '1106622311',
                  placementId: '9080027978920719',
                  width: 310,
                  height: 487,
                  onAdViewWidgetCreated: _onAdViewWidgetCreated,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
