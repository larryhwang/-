//
//  UserInfo_iSIXP.m
//  清房助手
//
//  Created by Larry on 12/31/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "UserInfo_iSIXP.h"

@interface UserInfo_iSIXP ()
@property (weak, nonatomic) IBOutlet UIImageView *iCoView;
@end

@implementation UserInfo_iSIXP

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.iCoView.layer.cornerRadius = 35;
    self.iCoView.layer.masksToBounds = YES;
    self.navigationController.navigationBarHidden = YES;
}




- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
     self.navigationController.navigationBarHidden = NO;
}


@end
