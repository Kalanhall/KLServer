//
//  KLServer+LoginService.h
//  KLServer_Example
//
//  Created by KimeeMacmini on 2019/7/16.
//  Copyright © 2019 574068650@qq.com. All rights reserved.
//

#import <KLServer/KLServer.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLServer (LoginService)

- (UIViewController *)fetchLoginViewController:(nullable NSDictionary *)parameters callBack:(nullable void (^)(BOOL success))callBack;

@end

NS_ASSUME_NONNULL_END
