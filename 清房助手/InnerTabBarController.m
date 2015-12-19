//
//  InnerTabBarController.m
//  清房助手
//
//  Created by Larry on 12/19/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "InnerTabBarController.h"
#import "InnerCustomer.h"
#import "InnerFangVC.h"


@interface InnerTabBarController ()

@end

@implementation InnerTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllChildViewController];
}





- (void)setUpAllChildViewController
{
    InnerCustomer *innerCustomer = [[InnerCustomer alloc]init] ;
    [self setUpOneChildViewController:innerCustomer image:[UIImage imageNamed:@"company"] title:@"公司"];
    
    
    InnerFangVC *innerFangVC = [[InnerFangVC alloc]init];
    [self setUpOneChildViewController:innerFangVC image:[UIImage imageNamed:@"person"] title:@"个人"];
}


- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image  title:(NSString *)title
{
    //    // navigationItem模型
    //    vc.navigationItem.title = title;
    //
    //    // 设置子控件对应tabBarItem的模型属性
    //    vc.tabBarItem.title = title;
    vc.title = title;
    vc.tabBarItem.image = image;
    
    // 保存tabBarItem模型到数组
    // [self.items addObject:vc.tabBarItem];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

@end
