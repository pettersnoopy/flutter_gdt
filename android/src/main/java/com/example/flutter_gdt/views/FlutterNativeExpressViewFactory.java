package com.example.flutter_gdt.views;

import android.app.Activity;
import android.content.Context;

import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.platform.PlatformView;

/**
 * @author luopeng
 * Created at 2019/6/19 18:13
 */
public class FlutterNativeExpressViewFactory extends PlatformViewFactory {
    private Activity mActivity;
    private BinaryMessenger mMessenger;

    public FlutterNativeExpressViewFactory(MessageCodec<Object> createArgsCodec, Activity activity, BinaryMessenger messenger) {
        super(createArgsCodec);
        this.mActivity = activity;
        this.mMessenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        return new FlutterNativeExpressView(mActivity, mMessenger, id);
    }
}
