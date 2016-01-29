//
//  SelectRegionVC.m
//  上传模块测试
//
//  Created by Larry on 15/10/31.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "SelectRegionVC.h"
#import "SelectCityVC.h"
#import "HttpTool.h"
#import "LocateTool.h"
#import "commonFile.h"

#import "SelectQu.h"



#define SCREEN_WIDTH                  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                 ([UIScreen mainScreen].bounds.size.height)
#define ContenterHeight 255
#define ButtonHeight 90
#define Pading 40



@interface SelectRegionVC ()<UITableViewDataSource,UITableViewDelegate,SelectRegionDelegate>
@property(nonatomic,strong)  UILabel  *cityLable;
@end

@implementation SelectRegionVC

- (void)viewDidLoad {
   self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
    NSArray *Charters = [self.indexData allKeys];
    self.indexChara = [Charters sortedArrayUsingSelector:@selector(compare:)];
    
    
    UIView *curentCity = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH -20 ,90)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 60)];
    [title setFont:[UIFont systemFontOfSize:13]];
    title.text = @"GRS";
    [title setTextColor:[UIColor brownColor]];
    [curentCity addSubview:title];
    
    UILabel *CurrentCityNameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    [CurrentCityNameLable setFont:[UIFont systemFontOfSize:26]];
    CurrentCityNameLable.center = curentCity.center;
    self.cityLable = CurrentCityNameLable;
    
    NSUserDefaults *DefaultHandle = [NSUserDefaults standardUserDefaults];
    NSString *currentCityName = [DefaultHandle objectForKey:CurrentCityName];
    if ([currentCityName length]>0) {
        CurrentCityNameLable.text  = currentCityName;
    }else {
        CurrentCityNameLable.text  = @"正在定位";
        LocateTool *Locat = [LocateTool sharedLocateTool];
        Locat.update = ^(NSString *cityName){
            CurrentCityNameLable.text = cityName;  //更新界面值
        };
        [Locat StartGetCityName];
        NSLog(@"%@",[Locat GetCityName]);
    }
    [title setTextColor:[UIColor blackColor]];
    [curentCity addSubview:CurrentCityNameLable];
    
    //GPS 定位的View 添加事件
    UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
    [curentCity addGestureRecognizer:tagGesture];
    
    
    curentCity.backgroundColor = [UIColor whiteColor];
    self.LocationNameTable.tableHeaderView = curentCity;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark -tableDelegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{

    return self.indexChara;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 10)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    NSString *key = [_indexChara objectAtIndex:section];

    titleLabel.text = key;
    [bgView addSubview:titleLabel];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_indexChara count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *str;
    str = [self.indexChara objectAtIndex:section];
    NSArray *citySection = [_indexData objectForKey:str];
    return [citySection count];
}



#pragma mark -tableDelegate

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 //   NSDictionary
    static NSString *CellIdentifier = @"Cell";
    NSString *str  = [_indexChara objectAtIndex:indexPath.section];
     NSLog(@"biao字母%@",str);
    NSArray *provns = _indexData[str];  //字典－>数组－>字典 －>"code"，"name" 字段
    NSDictionary *singleCityData = [provns objectAtIndex:indexPath.row];
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

//索引列点击事件

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSLog(@"===%@  ===%d",title,index);
    //点击索引，列表跳转到对应索引的行
//    
[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
     atScrollPosition:UITableViewScrollPositionMiddle animated:YES]; //UITableViewScrollPositionBottom
    return index;
    
}

#pragma mark 点击省份后干什么

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *indexCharater = _indexChara[indexPath.section] ;
    NSArray *indexCities = [_indexData objectForKey:indexCharater];
    NSDictionary *dict = [indexCities objectAtIndex:indexPath.row];
    NSString *proVNname = dict[@"name"];
    NSString *code = dict[@"code"];
  //  NSString *url = [NSString stringWithFormat:@"http://www.123qf.cn:81/testApp/area/selectArea.api?parentid=%@",code];
      NSString *url = [NSString stringWithFormat:@"http://www.123qf.cn/app/area/selectArea.api?parentid=%@",code];
    //保存当前数据
    [self.delegate appendName:proVNname];
    NSLog(@"delegate:%@",self.delegate);
    //页面跳转
    SelectCityVC *SelectCity = [SelectCityVC new];
    SelectCity.delegate = self;
  
    [HttpTool QFGet:url parameters:nil success:^(id responseObject) {
        NSArray *passArr = responseObject[@"data"];
        SelectCity.CitiesArr = passArr ;
         [self.navigationController pushViewController:SelectCity animated:YES];
        NSLog(@"DEBUG");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)appendName:(NSString *)locationName {
    [self.delegate appendName:locationName];
}



/**
 *  点击惠州市
 */
-(void)Actiondo {   // 0 1 2 3 4
    
    NSLog(@"获取到GPS定位到了，准备回去");
    NSString *name = self.cityLable.text;
    [self.delegate appendName:@"广东省"];
    [self.delegate appendName:@"惠州市"];
   //跳转到区域
   //  NSString *url =@"http://www.123qf.cn:81/testApp/area/selectArea.api?parentid=4413";
      NSString *url =@"http://www.123qf.cn/app/area/selectArea.api?parentid=4413";
    
    SelectQu *SelectCity = [SelectQu new];
    SelectCity.delegate = self;
    
    [HttpTool QFGet:url parameters:nil success:^(id responseObject) {
        NSArray *passArr = responseObject[@"data"];
        SelectCity.QuArr = passArr ;
        [self.navigationController pushViewController:SelectCity animated:YES];
        NSLog(@"DEBUG");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

@end
