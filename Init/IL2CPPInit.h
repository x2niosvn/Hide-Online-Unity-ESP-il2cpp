//
//  IL2CPPInit.h

//
//  Created by AlexZero on 2024
//

#import <Foundation/Foundation.h>
#include <vector>
#include <string>

NS_ASSUME_NONNULL_BEGIN

@interface IL2CPPInit : NSObject

// Precheck methods
+ (void)startPrecheck;
+ (void)showMenuDirectly;
+ (void)resetPrecheckState;
+ (void)updateInitializationProgress;

// ImGui initialization status methods
+ (bool)isShowingInitOverlay;
+ (const char*)getCurrentCheckLabel;
+ (float)getInitializationProgress;
+ (int)getDotCount;
+ (bool)isInitializationComplete;
+ (bool)hasInitializationFailures;
+ (const std::vector<std::string>&)getInitializationFailures;

// Game info methods
+ (NSString *)getGameBundleIdentifier;
+ (NSString *)getGameVersion;
+ (NSString *)getGameDisplayName;

@end

NS_ASSUME_NONNULL_END
