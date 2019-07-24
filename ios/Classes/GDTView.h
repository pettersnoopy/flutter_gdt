//
//  GDTView.h
//  barcode_scan
//
//  Created by 杜金彩 on 2019/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTView : NSObject
- (instancetype)initWith:(NSDictionary *)arguments;
- (void)loadAdWith:(NSDictionary *)arguments callback:(void(^)(BOOL result))callback;

@end

NS_ASSUME_NONNULL_END
