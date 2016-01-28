//
//  SharePopVC.m
//  清房助手
//
//  Created by Larry on 1/28/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "SharePopVC.h"
#import "commonFile.h"

@interface SharePopVC ()

@end

@implementation SharePopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *popContentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 300, Screen_width, 300)];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 54)];
    CGPoint headViewPoint = CGPointMake(Screen_width/2, 54/2);

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 15)];
    label.center = headViewPoint;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, headerView.frame.size.width, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [headerView addSubview:lineLabel];

    
    [popContentView addSubview:headerView];
    
   
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 300-54, Screen_width, 54)];
    CGPoint footViewPoint = CGPointMake(Screen_width/2, 54/2);
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 54)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn setTitleColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    btn.center =  footViewPoint ;
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];

    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0.5, footView.frame.size.width, 0.5)];
    lineLabel2.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [footView addSubview:lineLabel2];
    
    
    popContentView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:btn];
    [popContentView addSubview:footView];
    
    
    [self.view addSubview:popContentView];
}


-(void)diss {
    self.DismissView();
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
