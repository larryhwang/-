//
//  WMHomeViewController.m
//  QQSlideMenu
//
//  Created by wamaker on 15/6/10.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import "WMHomeViewController.h"
#import "UIImage+WM.h"
#import <QuartzCore/QuartzCore.h>
#import "QFSearchBar.h"
#import "QFTitleButton.h"

@implementation WMHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem.title = @"返回";
    
    UIButton *IconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    IconBtn.frame = CGRectMake(0, 0, 33, 33);
    [IconBtn setBackgroundImage:[[UIImage imageNamed:@"Icon"]getRoundImage] forState:UIControlStateNormal];
    [IconBtn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:IconBtn];
    
    
    QFTitleButton *CityBtn = [[QFTitleButton alloc]init];
    CityBtn.backgroundColor = [UIColor clearColor];
    CityBtn.tintColor = [UIColor whiteColor];
    [CityBtn setImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
    [CityBtn setTitle:@"惠州" forState:UIControlStateNormal];
    CityBtn.frame = CGRectMake(0, 0,60,23);
    [CityBtn addTarget:self action:@selector(CitySelect) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:CityBtn];

    
    QFSearchBar *search = [[QFSearchBar alloc]initWithFrame:CGRectMake(0, 0, 180, 27)];
    search.tintColor = DeafaultColor2;
    search.layer.cornerRadius  = 5.0 ;
    search.backgroundColor = [UIColor  lightGrayColor];
    self.navigationItem.titleView = search;

}

- (void)clicked {
    if ([self.delegate respondsToSelector:@selector(leftBtnClicked)]) {
        [self.delegate leftBtnClicked];
    }
}

-(void)CitySelect {
    
}

@end
