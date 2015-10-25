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
#import "MJRefresh.h"
#import "MBProgressHUD+CZ.h"

#define SingleBtnWidth   ScreenWidth/2
#define TopTabBarHeight  32
typedef NS_ENUM(NSInteger, CellStatus) {
    SalesOut = 0,   //出售
    RentOut = 1,    //出租
    WantBuy = 2,   //求购
    WantRent = 3  //求租
};



@interface WMHomeViewController() {
#pragma mark 优化成结构体
    
    BOOL            _isSaleStatus;
    NSMutableArray  *_TabBarBtns;
    UIView          *_bottomLine;
    
}

@property(nonatomic,strong)  NSArray  *DataArr;
@property(nonatomic,strong)  AFHTTPRequestOperationManager  *shareMgr;
@property(nonatomic,copy) NSString *userID;
@property(nonatomic,assign) CellStatus status;
@property(nonatomic,copy)  NSString *CurrentRuest;




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

    [self ParameterInit];
    [self TopTabBarUISet];  //顶部切换设置
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    


  //  [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
  //  [self.tableView headerBeginRefreshing];
  //  [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    

    
    [self tableInit];  //页面初始化
    
  //  self.navigationItem.backBarButtonItem.title = @"返回";
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


- (void)ParameterInit {
    _isWant = NO;  //初始，请求的数据为出租/出售
    _status = SalesOut ;  //初始，
    _TabBarBtns = [NSMutableArray arrayWithCapacity:2];
    self.tableView.delegate = self;
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    self.shareMgr = mgr ;
}


#warning 顶部TabBar切换部分
- (void)TopTabBarUISet {
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

}

- (void)tableInit {
    [MBProgressHUD showMessage:@"正在加载"];
    [self LeftTableLoad];
}


-(void)LeftTableLoad {
    if (_isWant == NO) {
        _status = SalesOut ;
   _CurrentRuest=@"http://www.123qf.cn/testApp/fangyuan/rentalOrBuyHouseSearch.api?weiTuoDate=0&sum=10&fangxiang=initdata&zuShou=0";  //这是出售列表
    }else {
         _status = WantBuy;
  _CurrentRuest = @"http://www.123qf.cn/testApp/keyuan/rentalOrBuyHouseSearch.api?weiTuoDate=0&sum=20&fangxiang=initdata&zuGou=0";   //求购列表
    }

    [self LoadNetDataWithCurentURl];
}

#warning 缺少进度加载状态
- (void) LoadNetDataWithURl:(NSString *)url{
    [self.shareMgr POST:url
             parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"右选项卡%@",responseObject);
                 NSArray *DataArra = responseObject[@"data"];
                 self.userID = responseObject[@""];
                 self.DataArr =DataArra;
                 [self.tableView reloadData];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];

}

- (void) LoadNetDataWithCurentURl{
    [MBProgressHUD showMessage:@"正在加载"];
    [self.shareMgr POST:self.CurrentRuest
             parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [MBProgressHUD hideHUD];
                 NSLog(@"右选项卡%@",responseObject);
                 NSArray *DataArra = responseObject[@"data"];
                 self.userID = responseObject[@""];
                 self.DataArr =DataArra;
                 [self.tableView reloadData];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];
    
}


-(void)RightTableLoad {
    if (_isWant == NO) {
        _status = RentOut;
        self.CurrentRuest= @"http://www.123qf.cn/testApp/fangyuan/rentalOrBuyHouseSearch.api?weiTuoDate=0&sum=10&fangxiang=initdata&zuShou=1";  //出租列表
    }else {
        _status = WantRent;
        self.CurrentRuest= @"http://www.123qf.cn/testApp/keyuan/rentalOrBuyHouseSearch.api?weiTuoDate=0&sum=20&fangxiang=initdata&zuGou=1";  //求租列表
    }
    [self LoadNetDataWithCurentURl];
}

#pragma mark -顶部TabBar 切换
-(void)TabBarBtnClick :(UIButton *)btn {
    btn.selected = YES ;
    UIButton *anotherBtn = btn.tag ? _TabBarBtns[0]: _TabBarBtns[1] ;
    [UIView animateWithDuration:0.3f animations:^{
        anotherBtn.selected = NO;
        [_bottomLine setFrame:CGRectMake(btn.frame.origin.x + SingleBtnWidth/4, TopTabBarHeight -2 , SingleBtnWidth/2, 2)];
    }];
    if (btn.tag == 0) {  //出售
        [self LeftTableLoad];
        NSLog(@"出售");
    }else {
        [self RightTableLoad];
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


#pragma mark -tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.DataArr.count;
   
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *preName = nil;
    
    if (_status ==SalesOut) {
        preName = @"[出售]";
    } else if (_status ==RentOut) {
        preName = @"[出租]";
    } else if (_status ==WantBuy) {
        preName =@"[求购]";
    }else {
        preName =@"[求助]";
    }

    
    // 1.创建CELL
    static NSString *ID = @"identifer";
    SalesCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell ==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SalesCell" owner:nil options:nil] firstObject];
        }
    NSDictionary *SingleData = self.DataArr[indexPath.row];
#pragma mark 售价高亮属性
    NSString *PriceString = [NSString stringWithFormat:@"%@万元",SingleData[@"shoujia"]];
    NSMutableAttributedString *HiligntNo = [[NSMutableAttributedString alloc]initWithString:PriceString];
    NSRange NoRange = NSMakeRange(0, [PriceString length]-1);
    [HiligntNo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NoRange];
    [HiligntNo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ]  range:NoRange];

    NSString *imgCollects = SingleData[@"tupian"];
    NSArray *imgArray = [imgCollects componentsSeparatedByString:@","];
    NSString *imgURL = [NSString stringWithFormat:@"http://www.123qf.cn/testWeb/img/%@/userfile/qfzs/fy/mini/%@",SingleData[@"userid"],[imgArray firstObject]];
 
    
    NSString *BigTitle = [NSString stringWithFormat:@"%@%@",preName,SingleData[@"biaoti"]];
    NSArray *titlePartArra = [BigTitle componentsSeparatedByString:@" "]; //
    UIImage  *PlaceHoder = [UIImage imageNamed:@"DeafaultImage"];
    PlaceHoder = [PlaceHoder imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   
    [cell.QFImageView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:PlaceHoder];
    cell.title.text = [titlePartArra firstObject];
    cell.area.text  = [NSString stringWithFormat:@"面积:%@㎡",SingleData[@"mianji"]]; //SingleData[@"mianji"];
#warning 几室几厅数据没有返回
    cell.style.text = @"两室";
    cell.elevator.text = @"电梯";
    cell.price.text =[NSString stringWithFormat:@"%@万",PriceString];
    [cell.price setAttributedText:HiligntNo];
    
    NSString *Publisher =SingleData[@"publisher"];
    if ([Publisher isKindOfClass:[NSNull class]]) {
         cell.postUer.text = @"佚名";
    }else{
        cell.postUer.text =[NSString stringWithFormat:@"发布人:%@",SingleData[@"publisher"]];
    }
    cell.postTime.text = [NSString stringWithFormat:@"发布时间:%@",SingleData[@"weituodate"]];
    return cell;
}

#pragma mark -点击查看详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *SingleData = self.DataArr[indexPath.row];
    NSString *Id = SingleData[@"id"];   //将房源ID传过去
    NSString *userID = SingleData[@"userid"];
    NSString *name = SingleData[@"mingcheng"];
    NSString *Category = [NSString stringWithFormat:@"%@",SingleData[@"fenlei"]];
  //  [self.HomeVCdelegate QFshowDetailWithFangYuanID:Id andFenlei:Category userID:userID];
    [self.HomeVCdelegate QFshowDetailWithFangYuanID:Id andFenlei:Category userID:userID XiaoquName:name];

}

#pragma mark -下拉与上拉方法
- (void)refreshData {
    NSLog(@"下拉");
 //   [self SalesTableLoad];
}

-(void)loadMoreData {
    NSLog(@"上拉");
}



#pragma mark -侧滑过来的数据初始化

-(void)LeftInit {
    [self TabBarBtnClick:self.LeftTab];
}

- (void)RightInit {
    [self TabBarBtnClick:self.RightTab];
}

@end
