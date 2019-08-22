#import "FlutterGdtPlugin.h"
#import "GDTExpressAd.h"
#import "GDTManager.h"
#import "GDTStartSplashAd.h"
#import "GDTSplashAd.h"
@interface FlutterGdtPlugin ()<GDTSplashAdDelegate>

@end
@implementation FlutterGdtPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"flutter_gdt"
            binaryMessenger:[registrar messenger]];
    FlutterGdtPlugin* instance = [[FlutterGdtPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];

    [registrar registerViewFactory:[[GDTExpressAd alloc] initWithMessenger:registrar.messenger] withId:@"flutter_gdt_native_express_ad_view"];
    [registrar registerViewFactory:[[GDTStartSplashAd alloc] initWithMessenger:registrar.messenger] withId:@"flutter_gdt_splash_ad_view"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"checkPermissions" isEqualToString:call.method]) {
      result(@(YES));
    } else if ([@"preloadNativeExpress" isEqualToString:call.method]) {
        [[GDTManager sharedManager] loadAdWith:call.arguments callback:^(BOOL res) {
             NSLog(@"preload gdtad%@ dict%@",@(res), [GDTManager sharedManager].gdtViewDict);
        }];
      result(@(YES));
    } else if([@"loadActivitySplashAd" isEqualToString:call.method]){
        [self loadSplashAdWith:call.arguments];
    }
    else {
      result(FlutterMethodNotImplemented);
    }
}

#pragma mark - 开屏广告
- (void)loadSplashAdWith:(NSDictionary*)dic
{
    NSString *appId = dic[@"appId"]; //[[NSUserDefaults standardUserDefaults] objectForKey:@"GDTSplashAppId"];
    NSString *placementId = dic[@"positionId"];
    if (appId == nil || [appId isEqualToString:@""] || placementId == nil || [placementId isEqualToString:@""]){
        return;
    }
    GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppId:appId placementId:placementId];
    splash.delegate = self; //设置代理
    
    splash.fetchDelay = 3; //开发者可以设置开屏拉取时间，超时则放弃展示
    //［可选］拉取并展示全屏开屏广告
    //[splashAd loadAdAndShowInWindow:self.window];
    //设置开屏底部自定义LogoView，展示半屏开屏广告
    UIView* _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome_logo"]];
    logo.frame = CGRectMake(0, 0, 181, 52);
    [_bottomView addSubview:logo];
    logo.center = _bottomView.center;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [splash loadAdAndShowInWindow:[UIApplication sharedApplication].delegate.window withBottomView:_bottomView];
}

/**
 *  开屏广告展示失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"splashAdFailToPresent--%@",error);
}

@end
