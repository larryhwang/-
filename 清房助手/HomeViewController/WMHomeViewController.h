//
//  WMHomeViewController.h
//  QQSlideMenu
//
//  Created by wamaker on 15/6/10.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseViewController.h"

@protocol WMHomeViewControllerDelegate <NSObject>
@optional
- (void)leftBtnClicked;

@end

@interface WMHomeViewController : WMBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) UIButton *leftBtn;
@property (weak, nonatomic) id<WMHomeViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
