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

@property (weak, nonatomic) IBOutlet UILabel *QFuserName;

@property (weak, nonatomic) IBOutlet UILabel *QFcompanyName;

@property (weak, nonatomic) IBOutlet UILabel *QFuserID;

@property (weak, nonatomic) IBOutlet UILabel *QFSex;

@property (weak, nonatomic) IBOutlet UILabel *QFminzu;

@property (weak, nonatomic) IBOutlet UILabel *QFbirthDate;

@property (weak, nonatomic) IBOutlet UILabel *QFemail;

@property (weak, nonatomic) IBOutlet UILabel *QFregion;

@end

@implementation UserInfo_Four

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iCoView.layer.cornerRadius = 25;
    self.iCoView.layer.masksToBounds = YES;
    self.navigationController.navigationBarHidden = YES;
    [self displayDataFromNet];
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

@end
