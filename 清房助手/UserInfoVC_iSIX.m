//
//  UserInfoVC_iSIX.m
//  清房助手
//
//  Created by Larry on 12/30/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "UserInfoVC_iSIX.h"
#import "Masonry.h"

@interface UserInfoVC_iSIX ()



@property (weak, nonatomic) IBOutlet UIImageView *iCoView;






@end

@implementation UserInfoVC_iSIX

-(void)setQFDataDic:(NSDictionary *)QFDataDic {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.iCoView.layer.cornerRadius = 35;
     self.iCoView.layer.masksToBounds = YES;
    self.navigationController.navigationBarHidden = YES;
}




- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
     self.navigationController.navigationBarHidden = NO;
}




@end
