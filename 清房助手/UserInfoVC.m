//
//  UserInfoVC.m
//  清房助手
//
//  Created by Larry on 12/30/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "UserInfoVC.h"

@interface UserInfoVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headBackImg;

@end

@implementation UserInfoVC



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
