import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterGdt {
  FlutterGdt(int id)
      : _channel = MethodChannel('flutter_gdt_native_express_ad_view_$id');

  final MethodChannel _channel;

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<bool> checkPermission() async {
    return await _channel.invokeMethod("checkPermissions");
  }
}

typedef void GDTAdViewWidgetCreatedCallback(FlutterGdt adView);

class GDTAdView extends StatefulWidget {
  const GDTAdView({
    Key key,
    this.onAdViewWidgetCreated,
    this.placementId,
    this.appId,
    this.width,
    this.height,
  }) : super(key: key);

  final GDTAdViewWidgetCreatedCallback onAdViewWidgetCreated;
  final String placementId;
  final String appId;
  final double width;
  final double height;
  @override
  State<StatefulWidget> createState() {
    return _GDTAdViewState();
  }
}

class _GDTAdViewState extends State<GDTAdView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: "flutter_gdt_native_express_ad_view",
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: <String, dynamic>{
          "placementId": widget.placementId,
          "appId": widget.appId,
          "width": widget.width,
          "height": widget.height,
        },
        creationParamsCodec: new StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return Container();
    }
    return Text('activity_indicator插件尚不支持$defaultTargetPlatform ');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onAdViewWidgetCreated == null) {
      return;
    }
    widget.onAdViewWidgetCreated(new FlutterGdt(id));
  }
}
