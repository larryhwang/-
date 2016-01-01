//
//  UserInfo_Four.m
//  清房助手
//
//  Created by Larry on 12/31/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "UserInfo_Four.h"

@interface UserInfo_Four ()
@property (weak, nonatomic) IBOutlet UIImageView *iCoView;

@end

@implementation UserInfo_Four

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iCoView.layer.cornerRadius = 25;
    self.iCoView.layer.masksToBounds = YES;
    self.navigationController.navigationBarHidden = YES;
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

@end
