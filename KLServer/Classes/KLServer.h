//
//  KLServer.h
//  KLServer
//
//  Created by Kalan on 2019/3/13.
//  Copyright © 2019年 Kalan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kKLServerParamsKey;

@interface KLServer : NSObject

+ (instancetype)sharedServer;

// 远程App调用入口
- (id)performTaskWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;
// 本地组件调用入口
- (id)performService:(NSString *)serviceName task:(NSString *)taskName params:(nullable NSDictionary *)params shouldCacheService:(BOOL)shouldCacheService;
- (void)releaseCachedServiceWithServiceName:(NSString *)serviceName;

@end

NS_ASSUME_NONNULL_END
