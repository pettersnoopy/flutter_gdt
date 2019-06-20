package com.example.flutter_gdt;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Build;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StandardMessageCodec;

/** FlutterGdtPlugin */
public class FlutterGdtPlugin implements MethodCallHandler {
    private Activity mActivity;

    public FlutterGdtPlugin(Activity activity) {
        mActivity = activity;
    }
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_gdt");
        channel.setMethodCallHandler(new FlutterGdtPlugin(registrar.activity()));
        registrar.platformViewRegistry().registerViewFactory("flutter_gdt_native_express_ad_view",
                new FlutterNativeExpressViewFactory(new StandardMessageCodec(), registrar.activity(), registrar.messenger()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if ("checkPermissions".equals(call.method)) {
            this.checkPermission(call, result);
            return;
        }
    }

    private void checkPermission(MethodCall call, Result result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            this.checkAndRequestPermission(result);
        } else {
            result.success(true);
        }
    }

    @TargetApi(Build.VERSION_CODES.M)
    private void checkAndRequestPermission(Result result) {
        List<String> lackedPermission = new ArrayList<String>();
        if (!(mActivity.checkSelfPermission(Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED)) {
            lackedPermission.add(Manifest.permission.READ_PHONE_STATE);
        }

        if (!(mActivity.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED)) {
            lackedPermission.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
        }

        if (!(mActivity.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED)) {
            lackedPermission.add(Manifest.permission.ACCESS_FINE_LOCATION);
        }

        // 权限都已经有了，那么直接调用SDK
        if (lackedPermission.size() == 0) {
            result.success(true);
        } else {
            // 请求所缺少的权限，在onRequestPermissionsResult中再看是否获得权限，如果获得权限就可以调用SDK，否则不要调用SDK。
            result.success(false);
            String[] requestPermissions = new String[lackedPermission.size()];
            lackedPermission.toArray(requestPermissions);
            mActivity.requestPermissions(requestPermissions, 1024);
        }
    }
}
