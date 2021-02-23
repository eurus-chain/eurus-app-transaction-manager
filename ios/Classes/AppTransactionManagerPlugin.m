#import "AppTransactionManagerPlugin.h"
#if __has_include(<app_transaction_manager/app_transaction_manager-Swift.h>)
#import <app_transaction_manager/app_transaction_manager-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "app_transaction_manager-Swift.h"
#endif

@implementation AppTransactionManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppTransactionManagerPlugin registerWithRegistrar:registrar];
}
@end
