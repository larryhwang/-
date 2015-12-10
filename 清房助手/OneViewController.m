//
//  OneViewController.m
//  清房助手
//
//  Created by Larry on 12/9/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_FilterOptions_ARR;
}

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _FilterOptions_ARR = @[@"区域",@"用途",@"价格",@"面积",@"电梯"];
   //用途:  住宅／写字楼／商铺／厂房
   //商铺:  价格

}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}




@end
