import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterGdtExpressView extends StatelessWidget {
  final String appId;
  final String positionId;
  final num width;
  final num height;
  final Function adCallback;

  FlutterGdtExpressView(
      {this.appId, this.positionId, this.width, this.height, this.adCallback});

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
      viewType: "flutter_gdt_native_express_ad_view",
      onPlatformViewCreated: (id) async {
        final channel = MethodChannel(
            "flutter_gdt_native_express_ad_view_" + id.toString());
        final success = await channel.invokeMethod("showNativeExpressAd", {
          "appId": appId,
          "positionId": positionId,
          "width": width,
          "height": height,
        });
        if (adCallback != null) {
          adCallback(success);
        }
      },
    );
  }

  Widget _iosView() {
    return UiKitView(
      viewType: "flutter_gdt_native_express_ad_view",
      creationParams: <String, dynamic>{
        "appId": appId,
        "placementId": positionId,
        "width": width,
        "height": height,
      },
      creationParamsCodec: new StandardMessageCodec(),
      onPlatformViewCreated: (int id) async {
        final success =
            await MethodChannel("flutter_gdt_native_express_ad_view_$id")
                .invokeMethod("showNativeExpressAd");

        if (adCallback != null) {
          adCallback(success);
        }
        print("flutter_gdt_plugin: ios dart ios view created.$success--$id");
      },
    );
  }
}
