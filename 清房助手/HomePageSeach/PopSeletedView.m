//
//  PopSeletedView.m
//  清房助手
//
//  Created by Larry on 12/15/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "PopSeletedView.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@implementation PopSeletedView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    if (self) {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        self.frame = window.bounds;
//        [window addSubview:self];
//        UIButton *CoverBtn = [[UIButton alloc]initWithFrame:window.frame];
//        [CoverBtn addTarget:self action:@selector(menumiss) forControlEvents:UIControlEventTouchUpInside];
//        CoverBtn.alpha  = 0.3;
//        [self addSubview:CoverBtn];
//    }
    return self;
}



-(void)menumiss{
    NSLog(@"界面退出");
}

@end
