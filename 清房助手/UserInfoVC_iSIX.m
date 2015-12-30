//
//  UserInfoVC.m
//  清房助手
//
//  Created by Larry on 12/30/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "UserInfoVC_iSIX.h"
#import "Masonry.h"

@interface UserInfoVC_iSIX ()



@end

@implementation UserInfoVC_iSIX




- (void)viewDidLoad {
    [super viewDidLoad];

    

    
    



    self.navigationController.navigationBarHidden = YES;
}


- (IBAction)test:(id)sender {
    NSLog(@"%@",self.navigationController);
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

@end
