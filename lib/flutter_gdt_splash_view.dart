import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterGdtSplashView extends StatelessWidget {
  final String appId;
  final String positionId;
  final Function adCallback;

  FlutterGdtSplashView({this.appId, this.positionId, this.adCallback});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidView();
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosView();
    }

    print('不支持的平台');
    return Container(width: 0, height: 0);
  }

  Widget _androidView() {
    return AndroidView(
      viewType: "flutter_gdt_splash_ad_view",
      onPlatformViewCreated: (id) async {
        final channel =
            MethodChannel("flutter_gdt_splash_ad_view_" + id.toString());
        final success = await channel.invokeMethod("renderSplashAd", {
          "appId": appId,
          "positionId": positionId,
        });
        if (adCallback != null) {
          adCallback(success);
        }
      },
    );
  }

  Widget _iosView() {
    return UiKitView(
      viewType: "flutter_gdt_splash_ad_view",
      creationParams: <String, dynamic>{
        "appId": appId,
        "positionId": positionId,
      },
      creationParamsCodec: new StandardMessageCodec(),
      onPlatformViewCreated: (int id) async {
        final success = await MethodChannel("flutter_gdt_splash_ad_view_$id")
            .invokeMethod("renderSplashAd");
        if (adCallback != null) {
          adCallback(success);
        }
      },
    );
  }
}
