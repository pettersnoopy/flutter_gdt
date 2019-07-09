package com.example.flutter_gdt;

import android.util.Log;

/**
 * @author luopeng
 * Created at 2019/7/8 17:33
 */
public class LogUtils {
    public static void i(String tag, String content) {
        if (!BuildConfig.DEBUG) {
            return;
        }

        Log.i(tag, content);
    }

    public static void e(String tag, String content) {
        if (!BuildConfig.DEBUG) {
            return;
        }

        Log.e(tag, content);
    }
}
