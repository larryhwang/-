//
//  WMMenuViewController.h
//  QQSlideMenu
//
//  Created by wamaker on 15/6/12.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseViewController.h"

@protocol WMMenuViewControllerDelegate <NSObject>
@optional


/**
 *  个人信息
 */
-(void)transToUserInfo;



/**
 *  房源、客源查询
 */
- (void)transToRentAndSale;

/**
 *  发布
 */
- (void)transToPost;


/**
 *  内部房源
 */
- (void)transtoInnerFang;


/**
 *  内部客源
 */
- (void)transtoInnerKeyuan;



/**
 *  综合业务
 */
- (void)transtoMutiTask;



/**
 *  设置
 */
- (void)transToSetting;



- (void)didSelectItem:(NSString *)title;

- (void)OnlyBack;
- (void)transToPostEdit;

@end

@interface WMMenuViewController : WMBaseViewController
@property (weak, nonatomic) id<WMMenuViewControllerDelegate> delegate;

@end
