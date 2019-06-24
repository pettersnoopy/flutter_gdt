import 'dart:async';
import 'package:flutter/services.dart';

class FlutterGdt {
  static const MethodChannel _channel = MethodChannel('flutter_gdt');
  static Future<bool> checkPermissions() async {
    return await _channel.invokeMethod("checkPermissions");
  }
}

