//
//  UserInfoVC_iSIX.m
//  清房助手
//
//  Created by Larry on 12/30/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "UserInfoVC_iSIX.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface UserInfoVC_iSIX ()



@property (strong, nonatomic) IBOutlet UIImageView *iCoView;

@property (weak, nonatomic) IBOutlet UILabel *QFuserName;

@property (weak, nonatomic) IBOutlet UILabel *QFcompanyName;

@property (weak, nonatomic) IBOutlet UILabel *QFuserID;

@property (weak, nonatomic) IBOutlet UILabel *QFSex;

@property (weak, nonatomic) IBOutlet UILabel *QFminzu;

@property (weak, nonatomic) IBOutlet UILabel *QFbirthDate;

@property (weak, nonatomic) IBOutlet UILabel *QFemail;

@property (weak, nonatomic) IBOutlet UILabel *QFregion;


@end

@implementation UserInfoVC_iSIX


- (void)viewDidLoad {
    [super viewDidLoad];


    [self displayDataFromNet];

}

-(void)displayDataFromNet {
    //父亲执行了数据加载操作
    [super displayDataFromNet];
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
     self.navigationController.navigationBarHidden = NO;
}



@end
