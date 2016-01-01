//
//  test.m
//  清房助手
//
//  Created by Larry on 12/30/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "test.h"

@interface test ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *teleArrs;


@end

@implementation test




- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    
}




- (IBAction)btnClik:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    NSLog(@"%@",btn.titleLabel.text);

}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}



@end
