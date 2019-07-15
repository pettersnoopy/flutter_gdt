//
//  GDTManager.h
//  barcode_scan
//
//  Created by 杜金彩 on 2019/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTManager : NSObject

@property(nonatomic, strong) NSArray *gdtViews;
@property(nonatomic, strong) NSDictionary *arguments;
@property (nonatomic, strong) UIView *adView;

@property (nonatomic, strong) void (^callback)(BOOL result);

+ (instancetype)sharedManager;

- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
