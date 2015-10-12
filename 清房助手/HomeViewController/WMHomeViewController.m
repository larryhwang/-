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
    [mgr POST:url
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
    if ([self.delegate respondsToSelector:@selector(leftBtnClicked)]) {
        [self.delegate leftBtnClicked];
    }
}

-(void)CitySelect {
    
}


#pragma mark tableViewDelegate



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"数量获取%d",self.DataArr.count);
     return self.DataArr.count;
   
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    

//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell ==nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
//    ETWeiBoStatus *dd = self.ModelArray[indexPath.row];
//    NSLog(@"%@",dd.user.profile_image_url);
//    [cell.imageView sd_setImageWithURL:dd.user.profile_image_url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
//    cell.textLabel.text = dd.text;
    
    NSLog(@"single cell is seting");
    // 1.创建CELL
    static NSString *ID = @"identifer";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell ==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
    NSDictionary *SingleData = self.DataArr[indexPath.row];
    cell.textLabel.text    = SingleData[@"biaoti"];
    return cell;
}

@end
