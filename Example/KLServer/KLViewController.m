//
//  KLViewController.m
//  KLServer
//
//  Created by Kalanhall@163.com on 07/18/2019.
//  Copyright (c) 2019 Kalanhall@163.com. All rights reserved.
//

#import "KLViewController.h"
#import "KLServer+LoginService.h"

@interface KLViewController ()

@end

@implementation KLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIViewController *vc = [KLServer.sharedServer fetchLoginViewController:@{@"title":@"登录页"} callBack:^(BOOL success) {
        NSLog(@"登录成功状态：%@", @(success));
    }];
    UINavigationController *nav = [UINavigationController.alloc initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
