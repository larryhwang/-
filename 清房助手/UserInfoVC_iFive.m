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

@end

@implementation UserInfoVC_iFive


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(handleGesture)];
  //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
      NSLog(@"TTTTT：%d",self.navigationController.interactivePopGestureRecognizer.enabled);
    self.iCoView.layer.cornerRadius = 25;
    self.iCoView.layer.masksToBounds = YES;


}


-(void)handleGesture {
    NSLog(@"fuck,手势");
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

@end
