//
//  QFNavController.m
//  清房助手
//
//  Created by Larry on 12/20/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "QFNavController.h"

@interface QFNavController ()

@end

@implementation QFNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count) { // 不是根控制器
        
        viewController.hidesBottomBarWhenPushed = YES;
        

    }
    
    [super pushViewController:viewController animated:animated];
    
}




@end
