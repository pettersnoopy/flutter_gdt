#import "FlutterGdtPlugin.h"
#import "GDTExpressAd.h"
#import "GDTManager.h"
#import "GDTStartSplashAd.h"

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
    } else {
      result(FlutterMethodNotImplemented);
    }
}

@end
