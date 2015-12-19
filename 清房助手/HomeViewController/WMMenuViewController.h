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
- (void)transToRentAndSale;
- (void)transToPost;
- (void)transtoInnerFang;
- (void)transtoInnerKeyuan;
- (void)transToSetting;
- (void)didSelectItem:(NSString *)title;
- (void)OnlyBack;
- (void)transToPostEdit;

@end

@interface WMMenuViewController : WMBaseViewController
@property (weak, nonatomic) id<WMMenuViewControllerDelegate> delegate;

@end
