package com.example.flutter_gdt.managers;

import android.app.Activity;
import android.util.Log;

import com.example.flutter_gdt.Consts;
import com.example.flutter_gdt.LogUtils;
import com.qq.e.ads.nativ.ADSize;
import com.qq.e.ads.nativ.NativeExpressAD;
import com.qq.e.ads.nativ.NativeExpressADView;
import com.qq.e.comm.util.AdError;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @author luopeng
 * Created at 2019/7/9 10:45
 */
public class NativeExpressManager {
    public interface NativeExpressViewGetCallback {
        void viewGet(NativeExpressADView view);
        void viewGetError(int code, String reason);
    }
    private volatile static NativeExpressManager mInstance;
    public static NativeExpressManager getInstance() {
        if (mInstance == null) {
            synchronized (NativeExpressManager.class) {
                if (mInstance == null) {
                    mInstance = new NativeExpressManager();
                }
            }
        }
        return mInstance;
    }

    public NativeExpressManager() {
        mNativeExpressAdViewCache = new HashMap<>();
        mNativeExpressAdCache = new HashMap<>();
    }

    private HashMap<String, NativeExpressAD> mNativeExpressAdCache;
    private HashMap<String, ArrayList<NativeExpressADView>> mNativeExpressAdViewCache;
    private MethodChannel.Result mTmpResult;

    public void preloadNativeExpressAd(Activity activity, String appId, String positionId, ADSize adSize, int preloadCount) {
        this.loadNativeExpressAd(activity, appId, positionId, adSize, preloadCount, null);
    }

    public void getNativeExpressView(
            Activity activity,
            String appId,
            final String positionId,
            ADSize adSize,
            int preloadCount,
            MethodChannel.Result result,
            NativeExpressViewGetCallback callback) {
        mTmpResult = result;

        ArrayList<NativeExpressADView> adViews = mNativeExpressAdViewCache.get(positionId);
        if (adViews != null && adViews.size() > 0) {
            if (callback != null) {
                callback.viewGet(getAdView(positionId));
            }

            if (adViews.size() <= 0 && preloadCount > 0) {
                loadNativeExpressAd(activity, appId, positionId, adSize, preloadCount, null);
            }
            return;
        }

        loadNativeExpressAd(activity, appId, positionId, adSize, preloadCount, callback);
    }

    private void loadNativeExpressAd(Activity activity, String appId, final String positionId, ADSize adSize, int loadCount, final NativeExpressViewGetCallback callback) {
        if (mNativeExpressAdCache.get(positionId) == null) {
            mNativeExpressAdCache.put(positionId, new NativeExpressAD(activity, adSize, appId, positionId, new NativeExpressAD.NativeExpressADListener() {
                @Override
                public void onADLoaded(List<NativeExpressADView> list) {
                    putAdViewCache(positionId, list);

                    if (callback != null) {
                        callback.viewGet(getAdView(positionId));
                    }
                }

                @Override
                public void onRenderFail(NativeExpressADView nativeExpressADView) {

                }

                @Override
                public void onRenderSuccess(NativeExpressADView nativeExpressADView) {
                    if (mTmpResult != null) {
                        mTmpResult.success(true);
                        mTmpResult = null;
                    }
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
                    Log.e(Consts.TAG, "no ad error " + adError.getErrorCode() + "," + adError.getErrorMsg());
                }
            }));
        }

        NativeExpressAD nativeExpressAD = mNativeExpressAdCache.get(positionId);
        nativeExpressAD.loadAD(loadCount);
    }

    private void putAdViewCache(String posId, List<NativeExpressADView> list) {
        synchronized (this) {
            if (mNativeExpressAdViewCache.get(posId) == null) {
                mNativeExpressAdViewCache.put(posId, new ArrayList<NativeExpressADView>());
            }

            mNativeExpressAdViewCache.get(posId).addAll(list);
        }
    }

    private NativeExpressADView getAdView(String posId) {
        synchronized (this) {
            ArrayList<NativeExpressADView> adViews = mNativeExpressAdViewCache.get(posId);
            return (adViews == null || adViews.size() <= 0) ? null : adViews.remove(0);
        }
    }
}
