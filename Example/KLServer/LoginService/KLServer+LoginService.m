//
//  KLServer+LoginService.m
//  KLServer_Example
//
//  Created by KimeeMacmini on 2019/7/16.
//  Copyright © 2019 574068650@qq.com. All rights reserved.
//

#import "KLServer+LoginService.h"

@implementation KLServer (LoginService)

- (UIViewController *)fetchLoginViewController:(nullable NSDictionary *)parameters callBack:(void (^)(BOOL success))callBack {
    
    NSMutableDictionary *temp = nil;
    if (callBack) {
        temp = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [temp setObject:callBack forKey:@"callBack"];
    }
    
    UIViewController *vc = [self performService:@"LoginService"
                                           task:@"nativeToFetchLoginViewController"
                                         params:temp
                             shouldCacheService:NO];
    
    if (vc == nil) {
        vc = UIViewController.alloc.init;
    }
    
    return vc;
}

@end
