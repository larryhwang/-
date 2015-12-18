//
//  AppDelegate.h
//  清房助手
//
//  Created by Larry on 15/10/8.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#define PGY_APPKEY  @"1532dd72458c0cd6552d9ab261f5c7df"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)  NSDictionary  *provnceIndexDic;


@end

