package com.example.flutter_gdt;

import android.content.Context;

import java.util.HashMap;

/**
 * @author luopeng
 * Created at 2019/7/8 17:32
 */
public class Consts {
    public static final String TAG = "flutter_gdt";

    public static int dp2px(Context context, int dp) {
        return (int) ((float) dp * context.getResources().getDisplayMetrics().density);
    }
}
