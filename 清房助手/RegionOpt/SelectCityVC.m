//
//  SelectCityVC.m
//  上传模块测试
//
//  Created by Larry on 15/11/5.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "SelectCityVC.h"
#import "HttpTool.h"
#import "SelectQu.h"
@interface SelectCityVC ()<UITableViewDataSource,UITableViewDelegate,SelectRegionDelegate>

@end

@implementation SelectCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    NSLog(@"城市列表:%@",self.CitiesArr);
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return [_CitiesArr count];
}



#pragma mark -tableDelegate

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   NSDictionary
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *singleCityData = [_CitiesArr objectAtIndex:indexPath.row];
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
    NSDictionary *dict = [_CitiesArr objectAtIndex:indexPath.row];
    NSString *proVNname = dict[@"name"]; //城市名
    NSString *code = dict[@"code"];
    NSString *url = [NSString stringWithFormat:@"http://www.123qf.cn:81/testApp/area/selectArea.api?parentid=%@",code];
    //保存当前数据
    [self.delegate appendName:proVNname];
    [HttpTool QFGet:url parameters:nil success:^(id responseObject) {
        NSArray *arr = responseObject[@"data"];
        SelectQu *selctQ = [SelectQu new];
        selctQ.delegate = self;
        selctQ.QuArr = arr;
        [self.navigationController pushViewController:selctQ animated:YES];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)appendName:(NSString *)locationName {
    [self.delegate appendName:locationName];
}
@end
