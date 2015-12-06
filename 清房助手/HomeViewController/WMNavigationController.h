//
//  WMNavigationController.h
//  QQSlideMenu
//
//  Created by wamaker on 15/6/15.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMNavigationControllerDelegate <NSObject>
@optional
- (BOOL)controllerWillPopHandler;
@end

@interface WMNavigationController : UINavigationController

@end
