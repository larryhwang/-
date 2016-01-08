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
#import "SettingPage_TableVC.h"
#import "InnerTabBarController.h"
#import "ZuGouDetailViewController.h"


#import "UserInfoVC_iSIX.h"
#import "UserInfoVC_iFive.h"
#import "UserInfo_iSIXP.h"
#import "UserInfo_Four.h"

#import "MutiTaskOrderBusinessVC.h"

#import "AppDelegate.h"

#import "MBProgressHUD+CZ.h"

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

/**
 *  权限列表
 */
@property(nonatomic,weak) NSArray *QFlimits;

@end

@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.QFlimits =  app.QFUserPermissionDic_NSMArr;
    NSLog(@"哈哈:%@",self.QFlimits);
    
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
   // self.view.userInteractionEnabled = NO;
    self.homeVC.view.userInteractionEnabled = NO;  //当侧滑过去时，首页的界面变的不可以交互
    [self doSlide:viewHeightNarrowRatio];
}

/**
 *  展示主界面
 */
- (void)showHome {
    self.distance = 0;
    self.sta = kStateHome;
//    self.view.userInteractionEnabled = YES;
    self.homeVC.view.userInteractionEnabled = YES;
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



/**
 *  跳转到个人信息
 */

-(void)transToUserInfo {
    UserInfoBasic  *infoVC = NULL;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (isI6) {
        infoVC = [[UserInfoVC_iSIX alloc]init];
        infoVC.QFDataDic = appDelegate.usrInfoDic;

    } else if (isI5){
        infoVC = [[UserInfoVC_iFive alloc]init];
        infoVC.QFDataDic = appDelegate.usrInfoDic;
    } else if (isI6p) {
        infoVC = [[UserInfo_iSIXP alloc]init];
        infoVC.QFDataDic = appDelegate.usrInfoDic;
    } else if (isI4) {
        infoVC = [[UserInfo_Four alloc]init];
        infoVC.QFDataDic = appDelegate.usrInfoDic;
    }
    infoVC.title = @"个人信息";
    [self.messageNav pushViewController:infoVC animated:NO];
    self.messageNav.interactivePopGestureRecognizer.enabled = NO;
    [self showHome];
}


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


/**
 *  跳转到  信息发布
 */
-(void)transToPost {
//        NSString *match = @"imagexyz-999.png";
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", match];
//        NSArray *results = [directoryContents filteredArrayUsingPredicate:predicate];﻿
    

    if ([self isFunctionPersmisionWithTitle:@"信息发布"]) {
        PostViewController *PostVC = [[PostViewController alloc]init];
        PostVC.title = @"发布";
        PostVC.hidesBottomBarWhenPushed =  YES;
        [self.messageNav pushViewController:PostVC animated:NO];
        [self showHome];
    }else{
        [MBProgressHUD showError:@"权限不足，请联系管理员"];
    }
    

}




/**
 *  跳转到 内部房源
 */
-(void)transtoInnerFang {
    InnerTabBarController *innerTabarVC_FANG =[[InnerTabBarController alloc]initWithTabBarType:FangYuan];
    [self showHome];
    KeyWindow.rootViewController = innerTabarVC_FANG;
}



/**
 *  跳转到 综合业务
 */
-(void)transtoMutiTask {
    
    if([self isFunctionPersmisionWithTitle:@"售后业务"]){
        MutiTaskOrderBusinessVC *OrderTask = [[MutiTaskOrderBusinessVC alloc]init];
        OrderTask.title =@"售后业务";
        [self showHome];
        [self.messageNav pushViewController:OrderTask animated:YES];
    } else {
        [MBProgressHUD showError:@"权限不足，请联系管理员"];
    }
}



/**
 *  跳转到 内部客源
 */
-(void)transtoInnerKeyuan {

    InnerTabBarController *innerTabarVC_KE =[[InnerTabBarController alloc]initWithTabBarType:Keyuan];
    [self showHome];
    KeyWindow.rootViewController = innerTabarVC_KE;
}



-(void)transToSetting {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SettingInterface" bundle:[NSBundle mainBundle]];
    UIViewController *SettingViewController = (UIViewController*)[storyboard instantiateViewControllerWithIdentifier:@"settingPage"];
     SettingViewController.title = @"设置";
    [self.messageNav pushViewController:SettingViewController animated:NO];
    [self showHome];
}

- (void)transToPostEdit{

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

-(void)QFShowZugouDetailWithFanLei:(NSString *)fenlei andKeyuanID:(NSString *)keyuanId andTitle:(NSString *)title{
    ZuGouDetailViewController *VC  = [[ZuGouDetailViewController alloc]init];
    VC.title = title;
    VC.fenlei = fenlei;
    VC.keYuanID = keyuanId;
    [self.messageNav pushViewController:VC animated:YES];
}

/**
 *  用于判断功能是否具有权限
 *
 *  @param name 功能名称
 *
 *  @return bool值
 */
-(BOOL) isFunctionPersmisionWithTitle:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", name];
    NSArray *results = [self.QFlimits filteredArrayUsingPredicate:predicate];
    if (results) {
        return YES;
    }else {
        return NO;
    }
}
@end
