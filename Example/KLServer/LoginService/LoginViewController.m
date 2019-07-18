//
//  LoginViewController.m
//  KLServer_Example
//
//  Created by KimeeMacmini on 2019/7/16.
//  Copyright © 2019 574068650@qq.com. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.orangeColor;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissLoginView)];
}

- (void)dismissLoginView {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.loginCallBack) {
            self.loginCallBack(YES);
        }
    }];
}

@end
