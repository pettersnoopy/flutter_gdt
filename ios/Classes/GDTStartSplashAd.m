//
//  GDTStartSplashAd.m
//  flutter_gdt
//
//  Created by 杜金彩 on 2019/8/20.
//

#import "GDTStartSplashAd.h"
 #import "GDTSplashAd.h"
@implementation GDTStartSplashAd
{
    NSObject<FlutterBinaryMessenger>*_messenger;
}
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager
{
    if ([super init]){
        _messenger = messager;
    }
    return self;
}
- (NSObject<FlutterMessageCodec> *)createArgsCodec
{
    return [FlutterStandardMessageCodec sharedInstance];
}
- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args
{
    return [[GDTSplashController alloc]initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
}
@end

@interface GDTSplashController()<GDTSplashAdDelegate>

@property (nonatomic, strong) void (^callback)(BOOL result);
@property (nonatomic, strong) UIView *adView;
@end

@implementation GDTSplashController
{
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    //    UIView * _adView;
    CGRect adFram;
    NSString * placementId;
    NSString *appId;
    NSDictionary *arguments;
}

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    if ([super init]){
        NSDictionary *dic = args;
        arguments = dic;
        placementId = dic[@"positionId"];
        appId = dic[@"appId"];
        adFram = CGRectMake(0, 0, [dic[@"width"] floatValue], [dic[@"height"]  floatValue]);
        
        self.adView = [[UIView alloc] init];
        _viewId = viewId;
        NSString* channelName = [NSString stringWithFormat:@"flutter_gdt_splash_ad_view_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
            [weakSelf onMethodCall:call result:result];
        }];
    }
    return self;
}

-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
   if([@"renderSplashAd" isEqualToString:call.method]){
       GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppId:appId placementId:placementId];
       splash.delegate = self; //设置代理
       splash.fetchDelay = 3;
       
       self.callback = ^(BOOL res) {
           result(@(res));
       };
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (UIView *)view
{
    return self.adView;
}

#pragma mark - splash delegate
/**
 *  开屏广告成功展示
 */
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"开屏广告成功展示");
}

/**
 *  开屏广告展示失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
     NSLog(@"开屏广告展示失败");
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
     NSLog(@"应用进入后台时回调");
}

/**
 *  开屏广告曝光回调
 */
- (void)splashAdExposured:(GDTSplashAd *)splashAd
{
     NSLog(@"开屏广告曝光回调");
}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd
{ NSLog(@"开屏广告点击回调");
    
}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
     NSLog(@"开屏广告将要关闭回调");
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
     NSLog(@"开屏广告关闭回调");
}

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"开屏广告点击以后即将弹出全屏广告页");
}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"开屏广告点击以后弹出全屏广告页");
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"点击以后全屏广告页将要关闭");
}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"点击以后全屏广告页已经关闭");
}

/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time
{
     NSLog(@"开屏广告剩余时间回调");
}

@end
