//
//  LoginService.m
//  KLServer_Example
//
//  Created by KimeeMacmini on 2019/7/16.
//  Copyright © 2019 574068650@qq.com. All rights reserved.
//

#import "LoginService.h"
#import "LoginViewController.h"

@implementation LoginService

- (UIViewController *)nativeToFetchLoginViewController:(nullable NSDictionary *)parameters {
    LoginViewController *vc = LoginViewController.alloc.init;
    vc.title = parameters[@"title"];
    vc.loginCallBack = parameters[@"callBack"];
    return vc;
}

@end
