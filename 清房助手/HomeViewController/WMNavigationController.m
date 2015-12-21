//
//  WMNavigationController.m
//  QQSlideMenu
//
//  Created by wamaker on 15/6/15.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import "WMNavigationController.h"
#import "WMNavigationInteractiveTransition.h"

@interface UINavigationController(UINavigationControllerNeedshouldPopItem)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item;  //扩展方法
@end

@interface WMNavigationController () <UIGestureRecognizerDelegate,UINavigationBarDelegate>
@property (nonatomic, weak) UIPanGestureRecognizer *popRecognizer;
@property (nonatomic, strong) WMNavigationInteractiveTransition *navT;



@end

@implementation WMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = YES ;
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view; //怀疑
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];
    _navT = [[WMNavigationInteractiveTransition alloc] initWithViewController:self];
    [popRecognizer addTarget:_navT action:@selector(handleControllerPop:)];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    /**
     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
     */
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}




- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    UIViewController *vc = self.topViewController;
    NSLog(@"VC：%@",vc);
    NSLog(@"0navigationBar :%@  item: %@",navigationBar,item);
    if ([vc respondsToSelector:@selector(controllerWillPopHandler)])
    {
        
        if ([vc performSelector:@selector(controllerWillPopHandler)])
        {
            NSLog(@"1navigationBar :%@  item: %@",navigationBar,item);
            return [super navigationBar:navigationBar shouldPopItem:item];
        }
        else
        {
            NSLog(@"2navigationBar :%@  item: %@",navigationBar,item);
            return YES;
        }
    }
    else
    {
        NSLog(@"3navigationBar :%@  item: %@",navigationBar,item);
        return [super navigationBar:navigationBar shouldPopItem:item];  //退出
    }
}

#pragma mark －alertViewDelegate

@end
