//
//  BaseViewController.m
//  Connotation
//
//  Created by LZXuan on 15-7-14.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航的背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"bg_navbar_blue"] forBarMetrics:UIBarMetricsDefault];
    
}
@end








