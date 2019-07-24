//
//  GDTView.m
//  barcode_scan
//
//  Created by 杜金彩 on 2019/7/24.
//

#import "GDTView.h"
#import "GDTManager.h"
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"

@interface GDTView ()<GDTNativeExpressAdDelegete>

@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;

@property(nonatomic, strong) NSArray *gdtViews;

@property(nonatomic, strong) NSDictionary *arguments;

@property (nonatomic, strong) void (^callback)(BOOL result);

@end

@implementation GDTView
{
    int64_t _viewId;
    CGRect adFram;
    NSString * placementId;
    NSString *appId;
}

- (void)dealloc
{
    NSLog(@"-----dealloc");
}
- (instancetype)initWith:(NSDictionary *)arguments
{
    self = [super init];
    if (self) {
        
        self.arguments = arguments;
    }
    return self;
}

- (void)loadAdWith:(NSDictionary *)arguments callback:(nonnull void (^)(BOOL))callback
{
    self.arguments = arguments;
    self.callback = callback;
    placementId = self.arguments[@"positionId"];
    appId = self.arguments[@"appId"];
    adFram = CGRectMake(0, 0, [self.arguments[@"width"] floatValue], [self.arguments[@"height"]  floatValue]);
    
    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:appId placementId:placementId adSize:adFram.size];
    self.nativeExpressAd.delegate = self;
    [self.nativeExpressAd loadAd:5];
}


/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
{
    //    if (self.callback) {·
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
    if (self.callback) {
        
        self.callback(NO);
        self.callback = nil;
    }
    
    NSLog(@"nativeExpressAdFailToLoad%@", error);
}
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewExposure");
}


- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views
{
    NSLog(@"nativeExpressAdSuccessToLoad");
    self.gdtViews = [NSArray arrayWithArray:views];
    
    if (self.gdtViews.count) {
        [self.gdtViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
            expressView.frame = self->adFram;
            expressView.controller = window.rootViewController;
            [expressView render];
        }];
        NSString *key = [NSString stringWithFormat:@"%@",self.arguments[@"positionId"]];
        [[GDTManager sharedManager].gdtViewDict setObject:self.gdtViews[0] forKey:key];
    }
    
    if (self.callback) {
        self.callback(YES);
    }
}

@end
