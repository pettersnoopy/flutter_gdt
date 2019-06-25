//
//  GDTExpressAd.m
//  flutter_gdt
//
//  Created by 杜金彩 on 2019/6/24.
//

#import "GDTExpressAd.h"

#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"

@implementation GDTExpressAd
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
    return [[FlutterGDTController alloc]initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
}
@end

@interface FlutterGDTController()<GDTNativeExpressAdDelegete>

@property (nonatomic, strong) NSArray *expressAdViews;
@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;

@property (nonatomic, strong) void (^callback)(BOOL result);
@end

@implementation FlutterGDTController
{
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    UIView * _adView;
    CGRect adFram;
    NSString * placementId;
    NSString *appId;
}

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    if ([super init]){
        NSDictionary *dic = args;
        placementId = dic[@"placementId"];
        appId = dic[@"appId"];
        adFram = CGRectMake(0, 0, [dic[@"width"] floatValue], [dic[@"height"]  floatValue]);
        
        _adView = [[UIView alloc] init];
        _viewId = viewId;
        NSString* channelName = [NSString stringWithFormat:@"flutter_gdt_native_express_ad_view_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
            [weakSelf onMethodCall:call result:result];
        }];
    }
    return self;
}

-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if([@"showNativeExpressAd" isEqualToString:call.method]){
        self.callback = ^(BOOL res) {
            result(@(res));
        };
        self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:appId placementId:placementId adSize:adFram.size];
        self.nativeExpressAd.delegate = self;
        // 配置视频播放属性
        //      self.nativeExpressAd.maxVideoDuration = (NSInteger)self.maxVideoDurationSlider.value;  // 如果需要设置视频最大时长，可以通过这个参数来进行设置
        //      self.nativeExpressAd.videoAutoPlayOnWWAN = self.videoAutoPlaySwitch.on;
        //      self.nativeExpressAd.videoMuted = self.videoMutedSwitch.on;
        [self.nativeExpressAd loadAd:5];
       
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (UIView *)view
{
    return _adView;
}


/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
{
//    if (self.callback) {
    
//    }
//
    NSLog(@"nativeExpressAdViewRenderSuccess");
}

/**
 * 原生模板广告渲染失败
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
{
    self.callback(NO);
    NSLog(@"nativeExpressAdViewRenderFail");
}

-(void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
{
    self.callback(NO);
    NSLog(@"nativeExpressAdFailToLoad%@", error);
}
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView
{
    self.callback(YES);
    NSLog(@"nativeExpressAdViewExposure");
}

- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views
{
    if (views.count <= 0){
        self.callback(NO);
    }
    [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GDTNativeExpressAdView *adView = (GDTNativeExpressAdView *)obj;
        [adView removeFromSuperview];
    }];
    self.expressAdViews = [NSArray arrayWithArray:views];
    
    if (self.expressAdViews.count) {
        [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
            expressView.frame = self->adFram;
            expressView.controller = window.rootViewController;
            [expressView render];
        }];
        [_adView addSubview:self.expressAdViews[0]];
    }
}
@end
