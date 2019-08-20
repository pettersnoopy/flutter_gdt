package com.example.flutter_gdt.views;

import android.app.Activity;
import android.text.TextUtils;
import android.view.View;
import android.widget.LinearLayout;

import com.example.flutter_gdt.Consts;
import com.qq.e.ads.splash.SplashAD;
import com.qq.e.ads.splash.SplashADListener;
import com.qq.e.comm.util.AdError;

import java.util.HashMap;

import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * @author luopeng
 * Created at 2019-08-19 23:23
 */
public class FlutterSplashAdView implements PlatformView, MethodChannel.MethodCallHandler {
    private LinearLayout mLinearLayout;
    private Activity mActivity;
    private String mAppId;
    private String mPositionId;

    FlutterSplashAdView(Activity activity, BinaryMessenger messenger, int id) {
        MethodChannel methodChannel = new MethodChannel(messenger, "flutter_gdt_splash_ad_view_" + id);
        methodChannel.setMethodCallHandler(this);
        this.mActivity = activity;
        if (mLinearLayout == null) {
            mLinearLayout = new LinearLayout(activity);
        }
    }

    @Override
    public View getView() {
        return mLinearLayout;
    }

    @Override
    public void dispose() {
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (Consts.FunctionName.RENDER_SPLASH_AD.equals(methodCall.method)) {
            renderSplashAd(methodCall, result);
        }
    }

    private void renderSplashAd(MethodCall call, final MethodChannel.Result result) {
        try {
            String appId = (String) call.argument(Consts.ParamKey.APP_ID);
            String positionId = (String) call.argument(Consts.ParamKey.POSITION_ID);
            if (TextUtils.isEmpty(appId) || TextUtils.isEmpty(positionId)) {
                return;
            }

            new SplashAD(mActivity, mLinearLayout, appId, positionId, new SplashADListener() {
                @Override
                public void onADDismissed() {
                    try {
                        result.success(true);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void onNoAD(AdError adError) {
                    try {
                        result.success(true);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    System.out.println(adError.getErrorMsg());
                }

                @Override
                public void onADPresent() {
                }

                @Override
                public void onADClicked() {
                }

                @Override
                public void onADTick(long l) {
                }

                @Override
                public void onADExposure() {
                }
            }, 3000);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
