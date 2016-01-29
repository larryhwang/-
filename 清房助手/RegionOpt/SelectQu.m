//
//  SelectQu.m
//  上传模块测试
//
//  Created by Larry on 15/11/5.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "SelectQu.h"
#import "HttpTool.h"
#import "SelectJie.h"

@interface SelectQu ()<UITableViewDataSource,UITableViewDelegate,SelectRegionDelegate>

@end

@implementation SelectQu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [_QuArr count];
}



#pragma mark -tableDelegate

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   NSDictionary
    static NSString *CellIdentifier = @"Cell";
    
    NSDictionary *singleCityData = [_QuArr objectAtIndex:indexPath.row];
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
    
    //打印导航栏全部视图 :
    NSLog(@"NavArrs:%@",self.navigationController.viewControllers);

    //推向选择街道
    NSLog(@"当前导航%@",self.navigationController);
    
    
    
    NSDictionary *dict = [_QuArr objectAtIndex:indexPath.row];
    NSString *proVNname = dict[@"name"]; //城市名
    NSString *code = dict[@"code"];
    [self.delegate appendName:proVNname];     //保存当前选择的城市名
 //   NSString *url = [NSString stringWithFormat:@"http://www.123qf.cn:81/testApp/area/selectArea.api?parentid=%@",code];
       NSString *url = [NSString stringWithFormat:@"http://www.123qf.cn/app/area/selectArea.api?parentid=%@",code];
    if ([proVNname isEqualToString:@"市辖区"]) {
        UIViewController *ed = [self.navigationController.viewControllers objectAtIndex:3]; //奇怪的是，序号是0也是一样的
        [self.navigationController popToViewController:ed animated:YES];
    } else{
        [HttpTool QFGet:url parameters:nil success:^(id responseObject) {
        NSArray *arr = responseObject[@"data"];
        SelectJie   *selctJ = [SelectJie new];
            selctJ.delegate = self;
            //
            NSLog(@"街:%@",self.delegate);
        selctJ.JieArr = arr;
        [self.navigationController pushViewController:selctJ animated:YES];             //界面跳转
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    }
}

-(void)appendName:(NSString *)locationName {
    [self.delegate appendName:locationName];
}
@end
