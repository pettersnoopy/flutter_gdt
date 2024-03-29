//
//  GDTManager.h
//  barcode_scan
//
//  Created by 杜金彩 on 2019/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *gdtViewDict;

+ (instancetype)sharedManager;

- (void)loadAdWith:(NSDictionary *)arguments callback:(void(^)(BOOL result))callback;


@end

NS_ASSUME_NONNULL_END
