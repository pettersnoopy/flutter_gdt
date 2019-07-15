//
//  GDTManager.m
//  barcode_scan
//
//  Created by 杜金彩 on 2019/7/15.
//

#import "GDTManager.h"

#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"

@interface GDTManager ()<GDTNativeExpressAdDelegete>

@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;

@end

@implementation GDTManager
{
    int64_t _viewId;
    CGRect adFram;
    NSString * placementId;
    NSString *appId;
}


+ (instancetype)sharedManager
{
    static GDTManager *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GDTManager alloc] init];
        
    });
    return sharedInstance;
}

- (void)loadAd
{
    placementId = self.arguments[@"placementId"];
    appId = self.arguments[@"appId"];
    adFram = CGRectMake(0, 0, [self.arguments[@"width"] floatValue], [self.arguments[@"height"]  floatValue]);
    
    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:appId placementId:placementId adSize:adFram.size];
    self.nativeExpressAd.delegate = self;
    // 配置视频播放属性
    //      self.nativeExpressAd.maxVideoDuration = (NSInteger)self.maxVideoDurationSlider.value;  // 如果需要设置视频最大时长，可以通过这个参数来进行设置
    //      self.nativeExpressAd.videoAutoPlayOnWWAN = self.videoAutoPlaySwitch.on;
    //      self.nativeExpressAd.videoMuted = self.videoMutedSwitch.on;
    [self.nativeExpressAd loadAd:5];
}


/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
{
//    if (self.callback) {
//
//        self.callback(YES);
//        self.callback = nil;
//    }
    NSLog(@"nativeExpressAdViewRenderSuccess");
}

/**
 * 原生模板广告渲染失败
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
{
//    if (self.callback) {
//
//        self.callback(NO);
//        self.callback = nil;
//    }
    NSLog(@"nativeExpressAdViewRenderFail");
}

-(void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
{
    NSLog(@"nativeExpressAdFailToLoad%@", error);
}
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewExposure");
}

- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views
{
//    if (views.count <= 0){
//        self.callback(NO);
//    }
//    [self.gdtViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        GDTNativeExpressAdView *adView = (GDTNativeExpressAdView *)obj;
////        [adView removeFromSuperview];
//    }];
    self.gdtViews = [NSArray arrayWithArray:views];
    
    if (self.gdtViews.count) {
        [self.gdtViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
            expressView.frame = self->adFram;
            expressView.controller = window.rootViewController;
            [expressView render];
        }];
    }
}

@end
