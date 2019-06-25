package com.example.flutter_gdt;

import android.app.Activity;
import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.qq.e.ads.nativ.ADSize;
import com.qq.e.ads.nativ.NativeExpressAD;
import com.qq.e.ads.nativ.NativeExpressADView;
import com.qq.e.comm.util.AdError;

import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * @author luopeng
 * Created at 2019/6/19 18:03
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
            mLinearLayout.setBackgroundColor(Color.parseColor("#ffffff"));
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
            return;
        }
    }

    private void showNativeExpressAd(MethodCall call, MethodChannel.Result result) {
        String appId = call.argument("appId");
        String codeId = call.argument("codeId");

        if (mNativeExpressAdMap.get(codeId) == null) {
            try {
                HashMap<String, Object> params = call.argument("params");

                int expressWidth = ADSize.FULL_WIDTH;
                int expressHeight = ADSize.AUTO_HEIGHT;
                if (params != null) {
                    if (params.containsKey("adWidth")) {
                        expressWidth = (int) params.get("adWidth");
                    }
                    if (params.containsKey("adHeight")) {
                        expressHeight = (int) params.get("adHeight");
                    }
                }
                mNativeExpressAdMap.put(codeId, new NativeExpressAD(mActivity, new ADSize(expressWidth, expressHeight), appId, codeId, new ExpressListener(result)));
            } catch (Exception e) {
                System.out.println(e);
            }
        }

        mNativeExpressAdMap.get(codeId).loadAD(1);
    }

    private class ExpressListener implements NativeExpressAD.NativeExpressADListener {
        private MethodChannel.Result mResult;
        private boolean mFailed = false;
        public ExpressListener(MethodChannel.Result result) {
            mResult = result;
        }
        @Override
        public void onADLoaded(List<NativeExpressADView> list) {
            if (mNativeExpressAdView != null) {
                mNativeExpressAdView.destroy();
            }

            if (list == null || list.size() <= 0) {
                return;
            }

            mNativeExpressAdView = list.get(0);
            mNativeExpressAdView.render();
            if (mLinearLayout.getChildCount() > 0) {
                mLinearLayout.removeAllViews();
            }
            mLinearLayout.addView(mNativeExpressAdView);
            mResult.success(true);
        }

        @Override
        public void onRenderFail(NativeExpressADView nativeExpressADView) {
          System.out.println("flutter_gdt_plugin: native express ad render failed.");
          if (mFailed) {
            return;
          }
          mFailed = true;
          mResult.success(false);
        }

        @Override
        public void onRenderSuccess(NativeExpressADView nativeExpressADView) {

        }

        @Override
        public void onADExposure(NativeExpressADView nativeExpressADView) {

        }

        @Override
        public void onADClicked(NativeExpressADView nativeExpressADView) {

        }

        @Override
        public void onADClosed(NativeExpressADView nativeExpressADView) {

        }

        @Override
        public void onADLeftApplication(NativeExpressADView nativeExpressADView) {

        }

        @Override
        public void onADOpenOverlay(NativeExpressADView nativeExpressADView) {

        }

        @Override
        public void onADCloseOverlay(NativeExpressADView nativeExpressADView) {

        }

        @Override
        public void onNoAD(AdError adError) {
            System.out.println(adError.getErrorCode() + " | " + adError.getErrorMsg());
            if (mFailed) {
              return;
            }
            mFailed = true;
            mResult.success(false);
        }
    }


}
