//
//  SelectJie.m
//  上传模块测试
//
//  Created by Larry on 15/11/5.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "SelectJie.h"
#import "HttpTool.h"


@interface SelectJie ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SelectJie

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone ;
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [_JieArr count];
}



#pragma mark -tableDelegate

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   NSDictionary
    static NSString *CellIdentifier = @"Cell";
    
    NSDictionary *singleCityData = [_JieArr objectAtIndex:indexPath.row];
    //  NSLog(@"%@")
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }

    cell.textLabel.text = singleCityData[@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", singleCityData[@"code"]];
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *dict = [_JieArr objectAtIndex:indexPath.row];
    NSString *proVNname = dict[@"name"]; //街道名
    self.delegate = [self.navigationController.viewControllers objectAtIndex:0]; //传值到编辑首页
    //保存当前数据
    [self.delegate appendName:proVNname];
    [self.delegate updateTableData];
    UIViewController *ed = self;
     //跳回编辑界面
    [self.navigationController popToViewController:ed animated:YES];

}

-(void)appendName:(NSString *)locationName {
    [self.delegate appendName:locationName];
}
@end
