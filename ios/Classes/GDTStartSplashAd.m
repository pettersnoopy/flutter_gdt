//
//  GDTStartSplashAd.m
//  flutter_gdt
//
//  Created by 杜金彩 on 2019/8/20.
//

#import "GDTStartSplashAd.h"
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

@interface GDTSplashController()

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
      
       [[NSUserDefaults standardUserDefaults] setObject:appId forKey:@"GDTSplashAppId"];
        [[NSUserDefaults standardUserDefaults] setObject:placementId forKey:@"GDTSplashPlacementId"];
       [[NSUserDefaults standardUserDefaults]synchronize];
//   result()
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (UIView *)view
{
    return self.adView;
}

@end
