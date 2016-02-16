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


#define PGY_APPKEY    @"1532dd72458c0cd6552d9ab261f5c7df"  //蒲公英Key
#define UMENG_APPKEY  @"56c286f0e0f55ad0480027fb"  //友盟Key

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  省市资料
 */
@property(nonatomic,strong)  NSDictionary  *provnceIndexDic;


/**
 *  用户资料
 */
@property(nonatomic,strong)  NSDictionary  *usrInfoDic;



/**
 *    权限列表数组
 */

@property(nonatomic,strong)  NSMutableArray  *QFUserPermissionDic_NSMArr;

@end

