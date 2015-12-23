//
//  MutiTaskOrderBusinessVC.m
//  清房助手
//
//  Created by Larry on 12/22/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "MutiTaskOrderBusinessVC.h"
#import "CommitOrderVC.h"

#import "TypesSelect.h"


@interface MutiTaskOrderBusinessVC ()<UITableViewDataSource,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *QFtable;

@end

@implementation MutiTaskOrderBusinessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSLog(@"导航栏:%@",self.navigationController);
    
    CGRect origin = CGRectMake(0, 100, ScreenWidth, 200);
    CGRect popOrigin = CGRectMake(60, 79+20 , ScreenWidth, 200);
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TypesSelect" owner:self options:nil];
    TypesSelect *popView  = [nibs lastObject];
    popView.backgroundColor = [UIColor redColor];
    [self.view addSubview:popView];
    [popView setFrame:popOrigin];

}



#pragma mark MethodDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row ==0) {
        cell.textLabel.text  =@"提交订单";
        
    } else {
        cell.textLabel.text = @"我的订单";
    }
 
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //解除遗留灰色
    if (indexPath.row ==0) {
      //提交订单
        CommitOrderVC *commitVC = [[CommitOrderVC alloc]init];
        commitVC.title = @"提交订单";
        [self.navigationController pushViewController:commitVC animated:YES];
    } else if (indexPath.row ==1) {
        
      //我的订单
    }

    
}

@end
