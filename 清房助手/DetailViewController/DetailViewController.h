//
//  DetailViewController.h
//  清房助手
//
//  Created by Larry on 15/10/12.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+CZ.h"
#import "DSNavigationBar.h"



@interface DetailViewController : UIViewController

@property(nonatomic,copy)  NSString  *DisplayId;
@property(nonatomic,copy)  NSString  *FenLei;
@property(nonatomic,copy)  NSString   *uerID;
@property(nonatomic,copy)  NSString  *PreTitle;

/**
 *  用于判读是否是内部XX，如果是则要显示查看信息按钮
 */
@property(nonatomic,assign) BOOL  isInner;

@end
