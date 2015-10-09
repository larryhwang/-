//
//  WMHomeViewController.m
//  QQSlideMenu
//
//  Created by wamaker on 15/6/10.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import "WMHomeViewController.h"
#import "UIImage+WM.h"

@implementation WMHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem.title = @"返回";
    
    UIButton *IconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    IconBtn.frame = CGRectMake(0, 0, 33, 33);
    [IconBtn setBackgroundImage:[[UIImage imageNamed:@"Icon"]getRoundImage] forState:UIControlStateNormal];
    [IconBtn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:IconBtn];
    

}

- (void)clicked {
    if ([self.delegate respondsToSelector:@selector(leftBtnClicked)]) {
        [self.delegate leftBtnClicked];
    }
}

@end
