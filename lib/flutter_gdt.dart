import 'dart:async';

import 'package:flutter/services.dart';

class FlutterGdt {
  static const MethodChannel _channel =
      const MethodChannel('flutter_gdt');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> checkPermission() async {
    return await _channel.invokeMethod("checkPermissions");
  }
}
