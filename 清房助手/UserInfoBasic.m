//
//  UserInfoBasic.m
//  清房助手
//
//  Created by Larry on 12/31/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "UserInfoBasic.h"

@interface UserInfoBasic ()

@end

@implementation UserInfoBasic

- (void)viewDidLoad {
    [super viewDidLoad];
 //   self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}





-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
@end
