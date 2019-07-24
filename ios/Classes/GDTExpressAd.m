//
//  GDTExpressAd.m
//  flutter_gdt
//
//  Created by 杜金彩 on 2019/6/24.
//

#import "GDTExpressAd.h"

#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
#import "GDTManager.h"

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
@property (nonatomic, strong) UIView *adView;
@end

@implementation FlutterGDTController
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
        NSString *key = [NSString stringWithFormat:@"%@",placementId];
        if ([[GDTManager sharedManager].gdtViewDict.allKeys containsObject:key]) {
            [self.adView addSubview:[GDTManager sharedManager].gdtViewDict[key]];
            result(@(YES));
            [[GDTManager sharedManager] loadAdWith:arguments callback:^(BOOL res) {
                 NSLog(@"preload gdtad%@",@(res));
            }];
        } else {
            __weak typeof(self) weakSelf = self;
            [[GDTManager sharedManager] loadAdWith:arguments callback:^(BOOL res) {
                if (res) {
                    [weakSelf.adView addSubview:[GDTManager sharedManager].gdtViewDict[key]];
                }
                result(@(res));
                [[GDTManager sharedManager] loadAdWith:self->arguments callback:^(BOOL res) {
                    NSLog(@"preload gdtad%@",@(res));
                }];
            }];
        }
       
       
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (UIView *)view
{
    return self.adView;
}

@end
