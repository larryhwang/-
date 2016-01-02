//
//  UserInfoVC_iFive.m
//  清房助手
//
//  Created by Larry on 12/31/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "UserInfoVC_iFive.h"

@interface UserInfoVC_iFive ()

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

@implementation UserInfoVC_iFive


- (void)viewDidLoad {
    [super viewDidLoad];
    [super displayDataFromNet];


}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
     self.navigationController.navigationBarHidden = NO;
}


@end
