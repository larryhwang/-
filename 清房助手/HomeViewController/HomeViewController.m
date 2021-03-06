//
//  HomeViewController.m
//  QQSlideMenu
//
//  Created by wamaker on 15/6/10.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import "HomeViewController.h"
#import "WMHomeViewController.h"
#import "WMMenuViewController.h"
#import "WMNavigationController.h"
#import "WMCommon.h"
#import "DetailViewController.h"
#import "PostViewController.h"

typedef enum Slidestate {
    kStateHome,
    kStateMenu
}Slidestate;

static const CGFloat viewSlideHorizonRatio = 0.75;
static const CGFloat viewHeightNarrowRatio = 0.80;
static const CGFloat menuStartNarrowRatio  = 0.70;

@interface HomeViewController () <WMHomeViewControllerDelegate, WMMenuViewControllerDelegate>
@property (assign, nonatomic) Slidestate   sta;              // 状态(Home or Menu)
@property (assign, nonatomic) CGFloat distance;         // 距离左边的边距
@property (assign, nonatomic) CGFloat leftDistance;
@property (assign, nonatomic) CGFloat menuCenterXStart; // menu起始中点的X
@property (assign, nonatomic) CGFloat menuCenterXEnd;   // menu缩放结束中点的X
@property (assign, nonatomic) CGFloat panStartX;        // 拖动开始的x值

@property (strong, nonatomic) WMCommon               *common;
@property (strong, nonatomic) WMHomeViewController   *homeVC;
@property (strong, nonatomic) WMMenuViewController   *menuVC;
@property (strong, nonatomic) WMNavigationController *messageNav;
@property (strong, nonatomic) UIView                 *cover;
@property (strong, nonatomic) UITabBarController     *tabBarController;
@property(nonatomic,assign) BOOL isOut;

@end

@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.common = [WMCommon getInstance];
    self.sta = kStateHome;
    self.distance = 0;
    self.menuCenterXStart = self.common.screenW * menuStartNarrowRatio / 2.0;
    self.menuCenterXEnd = self.view.center.x;
    self.leftDistance = self.common.screenW * viewSlideHorizonRatio;
    
    // 设置背景
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-logo(4)"]];
    bg.frame        = [[UIScreen mainScreen] bounds];
    [self.view addSubview:bg];
    
    // 设置menu的view
    self.menuVC = [[WMMenuViewController alloc] init];
    self.menuVC.delegate = self;
    self.menuVC.view.frame = [[UIScreen mainScreen] bounds];
    self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuStartNarrowRatio, menuStartNarrowRatio);
    self.menuVC.view.center = CGPointMake(self.menuCenterXStart, self.menuVC.view.center.y);
    [self.view addSubview:self.menuVC.view];
    
    // 设置遮盖
    self.cover = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.cover.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.cover];
    
    // 添加tabBarController
    self.tabBarController = [[UITabBarController alloc] init];
    
    self.homeVC = [[WMHomeViewController alloc] init];
    self.homeVC.view.frame = [[UIScreen mainScreen] bounds];
    self.homeVC.HomeVCdelegate = self;
    
    // 设置控制器的状态，添加手势操作
    self.messageNav = [[WMNavigationController alloc] initWithRootViewController:self.homeVC];
#pragma mark -导航栏颜色
    self.messageNav.navigationBar.barTintColor = [DeafaultColor2 colorWithAlphaComponent:0.5];
    self.messageNav.navigationBar.alpha = 0.5 ;
    self.messageNav.navigationBar.tintColor = [UIColor whiteColor];
    [self.messageNav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.messageNav.tabBarItem.title = @"消息";
    self.messageNav.tabBarItem.image = [UIImage imageNamed:@"tab_recent_nor"];
    
    [self.tabBarController addChildViewController:self.messageNav];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.tabBarController.view addGestureRecognizer:pan];
    [self.view addSubview:self.tabBarController.view];
}

/**
 *  设置statusbar的状态
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/**
 *  处理拖动事件
 *
 *  @param recognizer
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // 当滑动水平X大于75时禁止滑动
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartX = [recognizer locationInView:self.view].x;
    }
    if (self.sta == kStateHome && self.panStartX >= 75) {
        return;
    }
    
    CGFloat x = [recognizer translationInView:self.view].x;
    // 禁止在主界面的时候向左滑动
    if (self.sta == kStateHome && x < 0) {
        return;
    }
    
    CGFloat dis = self.distance + x;
    // 当手势停止时执行操作
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (dis >= self.common.screenW * viewSlideHorizonRatio / 2.0) {
            [self showMenu];
        } else {
            [self showHome];
        }
        return;
    }
    
    CGFloat proportion = (viewHeightNarrowRatio - 1) * dis / self.leftDistance + 1;
    if (proportion < viewHeightNarrowRatio || proportion > 1) {
        return;
    }
    self.tabBarController.view.center = CGPointMake(self.view.center.x + dis, self.view.center.y);
    self.tabBarController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
    
    self.homeVC.leftBtn.alpha = self.cover.alpha = 1 - dis / self.leftDistance;
    
    CGFloat menuProportion = dis * (1 - menuStartNarrowRatio) / self.leftDistance + menuStartNarrowRatio;
    CGFloat menuCenterMove = dis * (self.menuCenterXEnd - self.menuCenterXStart) / self.leftDistance;
    self.menuVC.view.center = CGPointMake(self.menuCenterXStart + menuCenterMove, self.view.center.y);
    self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
}

/**
 *  展示侧边栏
 */
- (void)showMenu {
    self.distance = self.leftDistance;
    self.sta = kStateMenu;
    [self doSlide:viewHeightNarrowRatio];
}

/**
 *  展示主界面
 */
- (void)showHome {
    self.distance = 0;
    self.sta = kStateHome;
    [self doSlide:1];
}

/**
 *  实施自动滑动
 *
 *  @param proportion 滑动比例
 */
- (void)doSlide:(CGFloat)proportion {
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBarController.view.center = CGPointMake(self.view.center.x + self.distance, self.view.center.y);
        self.tabBarController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
        self.homeVC.leftBtn.alpha = self.cover.alpha = proportion == 1 ? 1 : 0;
        CGFloat menuCenterX;
        CGFloat menuProportion;
        if (proportion == 1) {
            menuCenterX = self.menuCenterXStart;
            menuProportion = menuStartNarrowRatio;
        } else {
            menuCenterX = self.menuCenterXEnd;
            menuProportion = 1;
        }
        self.menuVC.view.center = CGPointMake(menuCenterX, self.view.center.y);
        self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - WMHomeViewController代理方法
- (void)leftBtnClicked {
    [self showMenu];
}

#pragma mark - WMMenuViewController代理方法

#pragma mark -侧栏菜单点击实现办法


- (void)transToRentAndSale {
    UIButton *left  = self.homeVC.LeftTab;
    UIButton *right = self.homeVC.RightTab;
    [left  setTitle: @"求购" forState:UIControlStateNormal];
    [right setTitle: @"求租" forState:UIControlStateNormal];
    self.homeVC.isWant = YES ;
     [self.homeVC LeftInit];
    //还需更改表的初始数据
    [self showHome];
    
}

-(void)transToPost {
    PostViewController *PostVC = [[PostViewController alloc]init];
    PostVC.hidesBottomBarWhenPushed =  YES;
    [self.messageNav pushViewController:PostVC animated:NO];
    [self showHome];
}

- (void)transToPostEdit{
//    WMOtherViewController *other = [[WMOtherViewController alloc] init];
//    other.navTitle = title;
//    other.hidesBottomBarWhenPushed = YES;
//    [self.messageNav pushViewController:other animated:NO];
//    [self showHome];
}

- (void)OnlyBack {  //回到首页(出租、出售)
    UIButton *left  = self.homeVC.LeftTab;
    UIButton *right = self.homeVC.RightTab;
    [left  setTitle: @"出售" forState:UIControlStateNormal];
    [right setTitle: @"出租" forState:UIControlStateNormal];
    self.homeVC.isWant = NO;
   [self.homeVC LeftInit];
   [self showHome];
}

#pragma mark - 表格点击后代理方法 
/**
 *  加载详情页
 *
 *  @param Id     房源ID
 *  @param Fenlei 分类ID
 */


-(void)QFshowDetailWithFangYuanID:(NSString *)FangId andFenlei:(NSString *)Fenlei userID:(NSString *)UserId XiaoquName:(NSString *)name ListStatus:(NSString *)status {
    DetailViewController *test = [DetailViewController new];
    
    test.title = name;
    test.PreTitle = status;
    test.DisplayId = FangId;
    test.FenLei = Fenlei;
    test.uerID = UserId;
    [self.messageNav pushViewController:test animated:YES];
}



@end
