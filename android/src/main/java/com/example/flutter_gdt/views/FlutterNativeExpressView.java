package com.example.flutter_gdt.views;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.example.flutter_gdt.Consts;
import com.example.flutter_gdt.LogUtils;
import com.example.flutter_gdt.managers.NativeExpressManager;
import com.qq.e.ads.nativ.ADSize;
import com.qq.e.ads.nativ.NativeExpressAD;
import com.qq.e.ads.nativ.NativeExpressADView;

import java.util.HashMap;

import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * @author luopeng Created at 2019/6/19 18:03
 */
public class FlutterNativeExpressView implements PlatformView, MethodChannel.MethodCallHandler {
  private HashMap<String, NativeExpressAD> mNativeExpressAdMap;
  private NativeExpressADView mNativeExpressAdView;
  private LinearLayout mLinearLayout;
  private Activity mActivity;

  FlutterNativeExpressView(Activity activity, BinaryMessenger messenger, int id) {
    MethodChannel methodChannel = new MethodChannel(messenger, "flutter_gdt_native_express_ad_view_" + id);
    methodChannel.setMethodCallHandler(this);
    this.mActivity = activity;
    if (mLinearLayout == null) {
      mLinearLayout = new LinearLayout(activity);
    }
    if (mNativeExpressAdMap == null) {
      mNativeExpressAdMap = new HashMap<>();
    }
  }

  @Override
  public View getView() {
    return mLinearLayout;
  }

  @Override
  public void dispose() {
    if (mNativeExpressAdView != null) {
      mNativeExpressAdView.destroy();
    }
  }

  @Override
  public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
    if ("showNativeExpressAd".equals(methodCall.method)) {
      showNativeExpressAd(methodCall, result);
    }
  }

    private void showNativeExpressAd(MethodCall call, MethodChannel.Result result) {
        String appId = call.argument("appId");
        String positionId = call.argument("positionId");
        Object width = call.argument("width");
        if (width == null) {
            LogUtils.e(Consts.TAG, "no ad width");
            return;
        }

        Object height = call.argument("height");
        if (height == null) {
            LogUtils.e(Consts.TAG, "no ad height");
            return;
        }

        int expressWidth = (int) width;
        int expressHeight = (int) height;

        ViewGroup.LayoutParams layoutParams = mLinearLayout.getLayoutParams();
        if (expressWidth > 0) {
            layoutParams.width = Consts.dp2px(mActivity, expressWidth);
        }
        if (expressHeight > 0) {
            layoutParams.height = Consts.dp2px(mActivity, expressHeight);
        }
        mLinearLayout.setLayoutParams(layoutParams);

        LogUtils.i(Consts.TAG, "try get express View");

        NativeExpressManager.getInstance().getNativeExpressView(mActivity, appId, positionId, new ADSize(expressWidth, expressHeight), result, new NativeExpressManager.NativeExpressViewGetCallback() {
            @Override
            public void viewGet(NativeExpressADView view) {
              System.out.println("view getted.");
                view.render();
                mLinearLayout.removeAllViews();
                mLinearLayout.addView(view, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
            }

            @Override
            public void viewGetError(int code, String reason) {
                LogUtils.e(Consts.TAG, "error: code: " + code + " ,reason: " + reason);
            }
        });
    }
}
