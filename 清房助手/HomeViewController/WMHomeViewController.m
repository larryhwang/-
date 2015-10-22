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
#import "SCNavTabBarController.h"


#define SingleBtnWidth   ScreenWidth/2
#define TopTabBarHeight  32

@interface WMHomeViewController() {
#pragma mark 优化成结构体
    
    BOOL            _isSaleStatus;
    NSMutableArray  *_TabBarBtns;
    UIView          *_bottomLine;
    
}

@property(nonatomic,strong)  NSArray  *DataArr;
@property(nonatomic,strong)  AFHTTPRequestOperationManager  *shareMgr;
@property(nonatomic,assign) BOOL isWant;



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
    _isWant = NO;  //初始，请求的数据为出租/出售
    
    
    
    
    
    _TabBarBtns = [NSMutableArray arrayWithCapacity:2];
    
#warning 整合部分


    
    self.tableView.delegate = self;
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    self.shareMgr = mgr ;
    
    [self SalesTableLoad];
    
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
    

    
#warning 顶部TabBar切换部分
    UIView *TabBarContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, TopTabBarHeight)];
    UIButton *Sales  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LeftTab = Sales ;
    Sales.tag = 0 ;
    [Sales setTitle:@"出售" forState:UIControlStateNormal];
    [Sales setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [Sales setTitleColor:DeafaultColor forState:UIControlStateSelected];
    Sales.selected = YES;
    [Sales setFrame:CGRectMake(0, 0, SingleBtnWidth ,TopTabBarHeight )];
    [Sales addTarget:self action:@selector(TabBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_TabBarBtns addObject:Sales];
    
    
    UIView *HorizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, TopTabBarHeight -2, ScreenWidth, 2)];
    HorizontalLine.backgroundColor = [UIColor grayColor];
    
    UIView *VerticalLine = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2,  5, 2, TopTabBarHeight - 10)];
    VerticalLine.backgroundColor = [UIColor grayColor];
    
    UIView *HilghtLine = [[UIView alloc]initWithFrame:CGRectMake(SingleBtnWidth/4, TopTabBarHeight-2, SingleBtnWidth/2, 2)];
    HilghtLine.backgroundColor = DeafaultColor ;
    _bottomLine = HilghtLine;
    
    
    UIButton *Rent  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.RightTab = Rent;
    Rent.tag  = 1 ;
    [Rent setTitle:@"出租" forState:UIControlStateNormal];
    [Rent setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [Rent setTitleColor:DeafaultColor forState:UIControlStateSelected];
    [Rent setFrame:CGRectMake(SingleBtnWidth, 0, SingleBtnWidth  ,TopTabBarHeight )];
    [Rent addTarget:self action:@selector(TabBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_TabBarBtns addObject:Rent];
    
    [TabBarContentView addSubview:Sales];
    [TabBarContentView addSubview:Rent];
    [TabBarContentView addSubview:HorizontalLine];
    [TabBarContentView addSubview:VerticalLine];
    [TabBarContentView addSubview:HilghtLine];
    TabBarContentView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:TabBarContentView];
    
    
    
#warning 测试返回数据
    NSString *url4  =@"http://192.168.1.38:8080/qfzsapi/keyuan/seekHouse.api?fenLei=2&keyuan_id=7";
    [self.shareMgr POST:url4
             parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"客源详情%@",responseObject);
               
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];
}


-(void)SalesTableLoad {
    //左选项卡
//       if (_isWant) {
//        url3 = @"";
//    } else{
//        url3 = @"";
//    }

    NSString *url3=@"http://www.123qf.cn/testApp/fangyuan/rentalOrBuyHouseSearch.api?weiTuoDate=0&sum=10&fangxiang=initdata&zuShou=0";  //这是出售列表
#warning 缺少进度加载状态
    
    [self.shareMgr POST:url3
   parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"出售信息%@",responseObject);
       NSArray *DataArra = responseObject[@"data"];
       self.DataArr =DataArra;
       [self.tableView reloadData];
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",error);
   }];

}


-(void)RenTableLoad {
    //右选项卡
        NSString *url3=@"http://192.168.1.38:8080/qfzsapi/fangyuan/rentalOrBuyHouseSearch.api?weiTuoDate=0&sum=10&fangxiang=refresh&zuShou=1";
        [self.shareMgr POST:url3
                 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"%@",responseObject);
                     NSArray *DataArra = responseObject[@"data"];
                     self.DataArr =DataArra;
                     [self.tableView reloadData];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"%@",error);
                 }];
}

-(void)TabBarBtnClick :(UIButton *)btn {
    btn.selected = YES ;
    UIButton *anotherBtn = btn.tag ?  _TabBarBtns[0]: _TabBarBtns[1] ;
    [UIView animateWithDuration:0.3f animations:^{
        anotherBtn.selected = NO;
        [_bottomLine setFrame:CGRectMake(btn.frame.origin.x + SingleBtnWidth/4, TopTabBarHeight -2 , SingleBtnWidth/2, 2)];
    }];
    if (btn.tag == 0) {  //出售
       // [self SalesTableLoad];
        NSLog(@"出售");
    }else {
      //  [self RenTableLoad];
        NSLog(@"出租");
    }
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
    NSDictionary *SingleData = self.DataArr[indexPath.row];
    NSString *Id = SingleData[@"id"];   //将房源ID传过去
    NSString *userID = SingleData[@"userid"];
    NSString *Category = [NSString stringWithFormat:@"%@",SingleData[@"fenlei"]];
    
    [self.HomeVCdelegate QFshowDetailWithFangYuanID:Id andFenlei:Category userID:userID];

}
@end
