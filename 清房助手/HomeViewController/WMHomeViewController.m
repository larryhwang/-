//
//  WMHomeViewController.m
//  QQSlideMenu
//
//  Created by wamaker on 15/6/10.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import "WMHomeViewController.h"
#import "UIImage+WM.h"
#import <QuartzCore/QuartzCore.h>
#import "QFSearchBar.h"
#import "QFTitleButton.h"
#import "AFNetworking.h"
#import "SalesCell.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"




@interface WMHomeViewController()

@property(nonatomic,strong)  NSArray  *DataArr;

@end

@implementation WMHomeViewController


-(NSArray *)DataArr {
    if (_DataArr ==nil) {
        _DataArr = [NSArray array];
    }
    return _DataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    NSString *url  = @"http://192.168.1.38:8080/qfzsapi/user/homePage.api?weiTuoDate=0&fangxiang=initdata";
    NSString *url2 =@"http://192.168.1.38:8080/qfzsapi/fangyuan/detailsHouse.api?fenLei=0&fangyuan_id=1";
    NSString *url3=@"http://192.168.1.38:8080/qfzsapi/fangyuan/rentalOrBuyHouseSearch.api?weiTuoDate=0&sum=10&fangxiang=refresh&zuShou=0";
    [mgr POST:url3
   parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"%@",responseObject);
       NSArray *DataArra = responseObject[@"data"];
       self.DataArr =DataArra;
       [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    self.navigationItem.backBarButtonItem.title = @"返回";
    UIButton *IconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    IconBtn.frame = CGRectMake(0, 0, 33, 33);
    [IconBtn setBackgroundImage:[[UIImage imageNamed:@"Icon"]getRoundImage] forState:UIControlStateNormal];
    [IconBtn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:IconBtn];
    
    
    QFTitleButton *CityBtn = [[QFTitleButton alloc]init];
    CityBtn.backgroundColor = [UIColor clearColor];
    CityBtn.tintColor = [UIColor whiteColor];
    [CityBtn setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
    [CityBtn setTitle:@"惠州" forState:UIControlStateNormal];
    CityBtn.frame = CGRectMake(0, 0,60,23);
    [CityBtn addTarget:self action:@selector(CitySelect) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:CityBtn];

    
    QFSearchBar *search = [[QFSearchBar alloc]initWithFrame:CGRectMake(0, 0, 180, 27)];
    search.tintColor = DeafaultColor2;
    search.layer.cornerRadius  = 5.0 ;
    search.backgroundColor = [UIColor  lightGrayColor];
    self.navigationItem.titleView = search;

}

- (void)clicked {
    if ([self.HomeVCdelegate respondsToSelector:@selector(leftBtnClicked)]) {
        [self.HomeVCdelegate leftBtnClicked];
    }
}

-(void)CitySelect {
    
}


#pragma mark tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.DataArr.count;
   
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建CELL
    static NSString *ID = @"identifer";
    SalesCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell ==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SalesCell" owner:nil options:nil] firstObject];
        }
    NSDictionary *SingleData = self.DataArr[indexPath.row];
    NSString *imgCollects = SingleData[@"tupian"];
    NSArray *imgArray = [imgCollects componentsSeparatedByString:@","];
    NSString *imgURL = [NSString stringWithFormat:@"http://112.74.64.145/hsf/img/%@",[imgArray firstObject]];
 
    NSString *BigTitle = SingleData[@"biaoti"];
    NSArray *titlePartArra = [BigTitle componentsSeparatedByString:@" "]; //
    
    UIImage  *PlaceHoder = [UIImage imageNamed:@"DeafaultImage"];
    PlaceHoder = [PlaceHoder imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cell.QFImageView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:PlaceHoder];
    cell.title.text = [titlePartArra firstObject];
    cell.area.text  = [NSString stringWithFormat:@"面积:%@㎡",SingleData[@"mianji"]]; //SingleData[@"mianji"];
#warning 几室几厅数据没有返回
    cell.style.text = @"两室";
    cell.elevator.text = @"电梯";
    cell.price.text = [NSString stringWithFormat:@"%@万",SingleData[@"shoujia"]];
    cell.postUer.text =  [NSString stringWithFormat:@"发布人:%@",SingleData[@"publisher"]];
    cell.postTime.text = [NSString stringWithFormat:@"发布时间:%@",SingleData[@"weituodate"]];
    return cell;
}

//点击查看详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // DetailViewController *detail = [[DetailViewController alloc]init];
  //  [self presentViewController:detail animated:YES completion:nil];
   [self.HomeVCdelegate QFshowDetail];
    
}
@end
