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

/**
 *  跳至出售页面的详情页
 *
 *  @param FangId <#FangId description#>
 *  @param Fenlei <#Fenlei description#>
 *  @param UserId <#UserId description#>
 *  @param name   <#name description#>
 *  @param status <#status description#>
 */
-(void)QFshowDetailWithFangYuanID:(NSString *)FangId andFenlei:(NSString *)Fenlei userID:(NSString *)UserId XiaoquName:(NSString *)name ListStatus:(NSString *)status;




/**
 *  跳至求租／求购详情页
 *
 *  @param fenlei   <#fenlei description#>
 *  @param keyuanId <#keyuanId description#>
 *  @param title    <#title description#>
 */
-(void)QFShowZugouDetailWithFanLei:(NSString *)fenlei andKeyuanID:(NSString *)keyuanId andTitle:(NSString *)title;
@end

@interface WMHomeViewController : WMBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) UIButton *leftBtn;
@property (weak, nonatomic) id<WMHomeViewControllerDelegate> HomeVCdelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign) BOOL isWant;
@property(nonatomic,weak) UIButton *LeftTab;
@property(nonatomic,weak) UIButton *RightTab;

- (void)LeftInit;  //用于侧滑过来的初始化数据
- (void)RightInit;

@end
