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


@end
