#import "FlutterGdtPlugin.h"
#import "GDTExpressAd.h"

@interface FlutterGdtPlugin ()

@end

@implementation FlutterGdtPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [registrar registerViewFactory:[[GDTExpressAd alloc] initWithMessenger:registrar.messenger] withId:@"flutter_gdt_native_express_ad_view"];
}




@end
