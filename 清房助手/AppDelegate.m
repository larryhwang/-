//
//  AppDelegate.m
//  清房助手
//
//  Created by Larry on 15/10/8.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WMCommon.h"
#import "HomeViewController.h"
#import "DetailViewController.h"
#import "PostViewController.h"
#import "SaleOutPostEditForm.h"
#import "CZNewFeatureController.h"

#import "GBWXPayManager.h"

#import "OpenShareHeader.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


-(NSMutableArray *)QFUserPermissionDic_NSMArr {
        if (_QFUserPermissionDic_NSMArr == nil) {
            _QFUserPermissionDic_NSMArr = [NSMutableArray new];
        }
        return _QFUserPermissionDic_NSMArr;
}
//  关闭用户手势反馈，默认为开启。
//  [[PgyManager sharedPgyManager] setEnableFeedback:NO];

//  设置用户反馈激活模式为三指拖动，默认为摇一摇。
//  [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeThreeFingersPan];

//  设置用户反馈界面的颜色，会影响到Title的背景颜色和录音按钮的边框颜色，默认为0x37C5A1(绿色)。
//  [[PgyManager sharedPgyManager] setThemeColor:[UIColor blackColor]];

//  设置摇一摇灵敏度，数字越小，灵敏度越高，默认为2.3。
//  [[PgyManager sharedPgyManager] setShakingThreshold:3.0];

//  是否显示蒲公英SDK的Debug Log，如果遇到SDK无法正常工作的情况可以开启此标志以确认原因，默认为关闭。
//  [[PgyManager sharedPgyManager] setEnableDebugLog:YES];

//  启动SDK
//  设置三指拖动激活摇一摇需在此调用之前


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
    
    [NSThread sleepForTimeInterval:2.0];
      self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    WMCommon *common = [WMCommon getInstance];
    common.screenW = [[UIScreen mainScreen] bounds].size.width;
    common.screenH = [[UIScreen mainScreen] bounds].size.height;
     NSLog(@"通知信息:%@",launchOptions);
    
    if(launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {  // 从被杀死的状态中调起的话 如果从通知，其他应用调用起来
        NSLog(@"%@",launchOptions);  //执行特定跳转
        UIApplication *app = [UIApplication sharedApplication];
        // 应用程序右上角数字
        app.applicationIconBadgeNumber = 0;
    }
    
    
    LoginViewController *login = [LoginViewController new];
    CZNewFeatureController *featurePage = [[CZNewFeatureController alloc]init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SecondLanch"]) {
        self.window.rootViewController = login;
    }else {
        self.window.rootViewController = featurePage;    //第一次启动则进入新特性
     [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"SecondLanch"];
    }
   [self.window  makeKeyAndVisible];

   

#pragma 蒲公英内测信息
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];  //检查更新
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
    
    
#pragma 向微信注册 - 支付功能
    [WXApi registerApp:APP_ID withDescription:nil];
    
    
    
#pragma mark - 微信分享注册
    [OpenShare connectWeixinWithAppId:APP_ID];
    
    
    
  //  [self registerLocalNotification:10];
    [self  registerRemoteNotification];
    return YES;
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    if (application.applicationState ==UIApplicationStateActive) return ;  //如果在前台接受到通知就直接返回
    if (application.applicationState ==UIApplicationStateInactive) {      //在程序未杀死且处于后台时接到通知
        NSLog(@"这里执行跳转");
        HomeViewController *MainVC = (HomeViewController *) application.keyWindow.rootViewController;
        [MainVC transtoMyMsg];
    }
}


#pragma mark - 微信支付回调
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXpayresult" object:@"1"];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"WXpayresult" object:@"0"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }

}


/** 蒲公英:
 *  检查更新回调
 *
 *  @param response 检查更新的返回结果
 */
- (void)updateMethod:(NSDictionary *)response
{
    NSLog(@"Pgy Dic :%@",response);
    if (response[@"downloadURL"]) {
        
        NSString *message = response[@"releaseNote"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil,
                                  nil];
        
        [alertView show];
    }

    //    调用checkUpdateWithDelegete后可用此方法来更新本地的版本号，如果有更新的话，在调用了此方法后再次调用将不提示更新信息。
    //        [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
    
    
    
    
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    
    return  [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //流量过大，暂时屏蔽后台同时请求
    
//    UIApplication*   app = [UIApplication sharedApplication];
//    __block    UIBackgroundTaskIdentifier bgTask;
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTask != UIBackgroundTaskInvalid)
//            {
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTask != UIBackgroundTaskInvalid)
//            {
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//    });

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    application.applicationIconBadgeNumber = 0;

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)registerLocalNotification:(NSInteger)alertTime {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody =  @"您有新消息";
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication]respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


-(void)registerRemoteNotification {
    if (DSystenVersion >=8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeBadge |UIUserNotificationTypeAlert categories:nil];
        //请求通知权限的授权
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        //注册远程通知
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"通知密钥:%@",deviceToken);
}

@end
