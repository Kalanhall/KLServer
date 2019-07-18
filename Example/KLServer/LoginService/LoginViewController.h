//
//  LoginViewController.h
//  KLServer_Example
//
//  Created by KimeeMacmini on 2019/7/16.
//  Copyright © 2019 574068650@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

@property (copy, nonatomic) void (^loginCallBack)(BOOL success);

@end

NS_ASSUME_NONNULL_END
