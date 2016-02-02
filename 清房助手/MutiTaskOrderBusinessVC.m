//
//  MutiTaskOrderBusinessVC.m
//  清房助手
//
//  Created by Larry on 12/22/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

// 说明:本页面用来描述售后业务两大功能的选择

#import "MutiTaskOrderBusinessVC.h"
#import "CommitOrderVC.h"

#import "TypesSelect.h"
#import "QFMyOrderTableVC.h"

#import "PermissionTool.h"
@interface MutiTaskOrderBusinessVC ()<UITableViewDataSource,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *QFtable;

@end

@implementation MutiTaskOrderBusinessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @" ";
    self.navigationItem.backBarButtonItem = backItem;

    


}



#pragma mark MethodDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([PermissionTool isHavePermisson:@"订单跟踪(负责人)"]) {
        return 1;
    } else  {
       return 2;
    }
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    if ([PermissionTool isHavePermisson:@"订单跟踪(负责人)"]) {
         cell.textLabel.text = @"订单跟踪(负责人)";
    } else {
       if (indexPath.row ==0) {
          cell.textLabel.text  =@"提交订单";
        } else {
          cell.textLabel.text = @"我的订单";
        }
    }
   
 
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //解除遗留灰色
    
    if([PermissionTool isHavePermisson:@"订单跟踪(负责人)"]) {
        //我的订单
        QFMyOrderTableVC *OrderListTableVC = [[QFMyOrderTableVC alloc]init];
        
        
        [self.navigationController pushViewController:OrderListTableVC animated:YES];
        

    } else {
        
        if (indexPath.row ==0) {
            //提交订单
            CommitOrderVC *commitVC = [[CommitOrderVC alloc]init];
            commitVC.title = @"提交订单";
            
            
            [self.navigationController pushViewController:commitVC animated:YES];
            
            
        } else if (indexPath.row ==1) {
            //我的订单
            QFMyOrderTableVC *OrderListTableVC = [[QFMyOrderTableVC alloc]init];
            
            
            [self.navigationController pushViewController:OrderListTableVC animated:YES];
            
        }
        

    }
    
    
}

@end
