import 'dart:async';
import 'package:flutter/services.dart';

class FlutterGdt {
  static const MethodChannel _channel = MethodChannel('flutter_gdt');
  static Future<bool> checkPermissions() async {
    return await _channel.invokeMethod("checkPermissions");
  }

  static Future<void> preloadNativeExpressView(NativeExpressParam param) async {
    await _channel.invokeMethod("preloadNativeExpress", {
      "appId": param.appId,
      "positionId": param.positionId,
      "width": param.ptWidth,
      "height": param.ptHeight,
    });
  }
}

class NativeExpressParam {
  String appId;
  String positionId;
  int ptWidth;
  int ptHeight;

  NativeExpressParam({this.appId, this.positionId, this.ptWidth, this.ptHeight});
}
