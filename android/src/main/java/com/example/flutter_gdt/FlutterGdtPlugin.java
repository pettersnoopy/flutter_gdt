package com.example.flutter_gdt;
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
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        result.notImplemented();
    }

}
