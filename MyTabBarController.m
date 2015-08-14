//
//  MyTabBarController.m
//  Connotation
//
//  Created by LZXuan on 15-7-14.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "MyTabBarController.h"
#import "BaseViewController.h"

@implementation MyTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
}
- (void)createViewControllers {
    NSArray *categorys = @[kJokes,kPics,kVideos,kGirls];
    NSArray *imageNames = @[@"圣斗士",@"海贼王",@"火影忍者",@"美女"];
    NSArray *titles = @[@"段子",@"趣图",@"视频",@"美女"];
    NSArray *vcNames = @[@"JokesViewController",@"PicsViewController",@"VideoViewController",@"GirlsViewController"];
    
    NSMutableArray *vcArr = [[NSMutableArray alloc] init];
    
    //运用OC的动态机制 Class  id
    for (NSInteger i = 0; i < vcNames.count; i++) {
        //把一个类名字符串转化为 Class类型
        Class vcClass = NSClassFromString(vcNames[i]);
        //Class类型的变量 可以执行 所表示类的  类方法
        //父类指针 指向子类对象
        BaseViewController * vc = [[vcClass alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        //导航条上的标题 导航的子视图控制器设置
        vc.navigationItem.title = titles[i];
        //传入分类
        vc.category = categorys[i];
        
        
        //设置标签栏
        //tabBarController的子视图控制器设置
        nav.tabBarItem.title = titles[i];
        nav.tabBarItem.image = [[UIImage imageNamed:imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageNames[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [vcArr addObject:nav];
    }
    self.viewControllers = vcArr;
}


@end




