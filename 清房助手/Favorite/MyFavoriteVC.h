//
//  MyFavoriteVC.h
//  清房助手
//
//  Created by Larry on 2/5/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "WMHomeViewController.h"

@interface MyFavoriteVC : UIViewController


@property (weak, nonatomic) UIButton *leftBtn;
@property (weak, nonatomic) id<WMHomeViewControllerDelegate> HomeVCdelegate;
@property(nonatomic,assign) BOOL isWant;
@property(nonatomic,weak) UIButton *LeftTab;
@property(nonatomic,weak) UIButton *RightTab;

@end
