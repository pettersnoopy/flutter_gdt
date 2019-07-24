//
//  GDTManager.m
//  barcode_scan
//
//  Created by 杜金彩 on 2019/7/15.
//

#import "GDTManager.h"
#import "GDTView.h"

@interface GDTManager ()

@property (nonatomic, strong) GDTView *gdt;
@property(nonatomic, strong) NSMutableArray *gdtArrays;
@end

@implementation GDTManager


+ (instancetype)sharedManager
{
    static GDTManager *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GDTManager alloc] init];
        
    });
    return sharedInstance;
}

- (void)loadAdWith:(NSDictionary *)arguments callback:(nonnull void (^)(BOOL))callback
{
    GDTView *gdt = [[GDTView alloc]initWith:arguments];
    [gdt loadAdWith:arguments callback:callback];
    [self.gdtArrays addObject:gdt];
}

- (NSMutableDictionary *)gdtViewDict
{
    if (!_gdtViewDict) {
        _gdtViewDict = [NSMutableDictionary dictionary];
    }
    return _gdtViewDict;
}

- (NSMutableArray *)gdtArrays
{
    if (!_gdtArrays) {
        _gdtArrays = [NSMutableArray array];
    }
    return _gdtArrays;
}

@end
