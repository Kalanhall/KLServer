//
//  KLServer.m
//  KLServer
//
//  Created by Kalan on 2019/3/13.
//  Copyright © 2019年 Kalan. All rights reserved.
//

#import "KLServer.h"
#import <objc/runtime.h>

NSString * const kKLServerParamsKey = @"kKLServerParamsKey";

@interface KLServer ()

@property (nonatomic, strong) NSMutableDictionary *cachedService;

@end

@implementation KLServer

#pragma mark - public methods
+ (instancetype)sharedServer
{
    static KLServer *server;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server = [[KLServer alloc] init];
    });
    return server;
}

/*
 scheme://[service]/[task]?[params]
 
 url sample:
 aaa://serviceA/taskB?id=1234
 */

- (id)performTaskWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *taskName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([taskName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    // 这个demo针对URL的路由处理非常简单，就只是取对应的service名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result = [self performService:url.host task:taskName params:params shouldCacheService:NO];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

- (id)performService:(NSString *)serviceName task:(NSString *)taskName params:(NSDictionary *)params shouldCacheService:(BOOL)shouldCacheService
{
    NSString *swiftModuleName = params[kKLServerParamsKey];
    
    // generate service
    NSString *serviceClassString = nil;
    if (swiftModuleName.length > 0) {
        serviceClassString = [NSString stringWithFormat:@"%@.%@", swiftModuleName, serviceName];
    } else {
        serviceClassString = [NSString stringWithFormat:@"%@", serviceName];
    }
    NSObject *service = self.cachedService[serviceClassString];
    if (service == nil) {
        Class serviceClass = NSClassFromString(serviceClassString);
        service = [[serviceClass alloc] init];
    }

    // generate task
    NSString *taskString = [NSString stringWithFormat:@"%@:", taskName];
    SEL task = NSSelectorFromString(taskString);
    
    if (service == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的service，就直接return了。实际开发过程中是可以事先给一个固定的service专门用于在这个时候顶上，然后处理这种请求的
        [self noServicetaskResponseWithserviceString:serviceClassString selectorString:taskString originParams:params];
        return nil;
    }
    
    if (shouldCacheService) {
        self.cachedService[serviceClassString] = service;
    }

    if ([service respondsToSelector:task]) {
        return [self safePerformtask:task service:service params:params];
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应service的notFound方法统一处理
        SEL task = NSSelectorFromString(@"notFound:");
        if ([service respondsToSelector:task]) {
            return [self safePerformtask:task service:service params:params];
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的service顶上的。
            [self noServicetaskResponseWithserviceString:serviceClassString selectorString:taskString originParams:params];
            [self.cachedService removeObjectForKey:serviceClassString];
            return nil;
        }
    }
}

- (void)releaseCachedServiceWithServiceName:(NSString *)serviceName
{
    NSString *serviceClassString = [NSString stringWithFormat:@"%@", serviceName];
    [self.cachedService removeObjectForKey:serviceClassString];
}

#pragma mark - private methods
- (void)noServicetaskResponseWithserviceString:(NSString *)serviceString selectorString:(NSString *)selectorString originParams:(NSDictionary *)originParams
{
    // MARK: 没有发现服务时的处理
    SEL task = NSSelectorFromString(@"taskResponse:");
    NSObject *service = [[NSClassFromString(@"NoServiceTask") alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"originParams"] = originParams;
    params[@"serviceString"] = serviceString;
    params[@"selectorString"] = selectorString;
    
    [self safePerformtask:task service:service params:params];
}

- (id)safePerformtask:(SEL)task service:(NSObject *)service params:(NSDictionary *)params
{
    NSMethodSignature* methodSig = [service methodSignatureForSelector:task];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];

    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:task];
        [invocation setTarget:service];
        [invocation invoke];
        return nil;
    }

    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:task];
        [invocation setTarget:service];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:task];
        [invocation setTarget:service];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:task];
        [invocation setTarget:service];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:task];
        [invocation setTarget:service];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [service performSelector:task withObject:params];
#pragma clang diagnostic pop
}

#pragma mark - getters and setters
- (NSMutableDictionary *)cachedService
{
    if (_cachedService == nil) {
        _cachedService = [[NSMutableDictionary alloc] init];
    }
    return _cachedService;
}

@end
