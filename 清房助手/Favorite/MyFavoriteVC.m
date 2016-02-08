//
//  MyFavoriteVC.m
//  清房助手
//
//  Created by Larry on 2/5/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "MyFavoriteVC.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "MBProgressHUD+CZ.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "SalesCell.h"
#import "KeyuanCell.h"

#import "UITableViewRowAction+JZExtension.h"

#define SingleBtnWidth   ScreenWidth/2
#define TopTabBarHeight  32

@interface MyFavoriteVC ()<UITableViewDataSource,UITableViewDelegate>
{
#pragma mark 优化成结构体
    BOOL                 _popStatus;   //区域选择是否
    NSMutableArray      *_TabBarBtns;
    NSMutableDictionary *_updateLocationParam;
    UIView              *_bottomLine;
    NSString            *_preName;
    UISearchController  *_searchVC;
    
}

@property(nonatomic,strong)  NSArray                           *DataArr;
@property(nonatomic,strong)  AFHTTPRequestOperationManager     *shareMgr;
@property(nonatomic,copy)    NSString                          *userID;
@property(nonatomic,assign)  CellStatus                        status;
@property(nonatomic,copy)    NSString                          *CurrentRuest;
@property(nonatomic,strong)  NSMutableDictionary                      *pramaDic;


@property(nonatomic,strong)  NSMutableArray  *LocationNameDicPartOne_NSarr;
@property(nonatomic,strong)  NSMutableArray  *LocationNameDicPartTwo_NSarr;

@property(nonatomic,strong)  UITableView  *tableView;

@property(nonatomic,weak) UIView *sharedModelView;
@property(nonatomic,assign) int currentPage;

@property(nonatomic,assign) BOOL isFangyuan;


@end

@implementation MyFavoriteVC

-(NSMutableDictionary *)pramaDic {
    if (_pramaDic ==nil) {
        _pramaDic = [NSMutableDictionary new];
    }
    return _pramaDic;
}

-(NSArray *)DataArr {
    if (_DataArr ==nil) {
        _DataArr = [NSArray array];
        
    }
    return _DataArr;
}

-(NSMutableArray*)LocationNameDic_NSArr {
    if (_LocationNameDicPartOne_NSarr ==nil) {
        _LocationNameDicPartOne_NSarr = [NSMutableArray new];
    }
    return _LocationNameDicPartOne_NSarr;
}

-(NSMutableArray*)LocationNameDicPartTwo_NSarr {
    if (_LocationNameDicPartTwo_NSarr ==nil) {
        _LocationNameDicPartTwo_NSarr = [NSMutableArray new];
    }
    return _LocationNameDicPartTwo_NSarr;
}




- (void)ParameterInit {
    _isWant = NO;  //初始，请求的数据为出租/出售
    _status = SalesOut ;  //初始，
    _TabBarBtns = [NSMutableArray arrayWithCapacity:2];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 32, ScreenWidth, ScreenHeight - 32)];
    self.tableView = table;
   [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval  = 8.0;
    self.shareMgr = mgr ;
    _CurrentRuest =@"http://www.123qf.cn/app/user/selectCollectRow.api";
    self.currentPage = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
       [self ParameterInit];
       [self TopTabBarUISet];
    [self tableInit];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    NSLog(@"%@",self.navigationController);
    NSLog(@"%@",self.navigationController.viewControllers);
     NSLog(@"DEBUG");
 

}




- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self setEditing:false animated:true];
        
        NSLog(@"%@",action.title);
        
        if(indexPath.row ==0) {
            NSLog(@"0");
        }
        
        if(indexPath.row ==1) {
            NSLog(@"1");
        }
        
        if(indexPath.row ==2) {
            NSLog(@"2");
        }
    };

    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消" handler:rowActionHandler];
    UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    return @[action2,action3];
}

- (void)TopTabBarUISet {
    UIView *TabBarContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, TopTabBarHeight)];
    UIButton *Sales  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LeftTab = Sales ;
    Sales.tag = 0 ;
    [Sales setTitle:@"房源" forState:UIControlStateNormal];
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
    [Rent setTitle:@"客源" forState:UIControlStateNormal];
    [Rent setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [Rent setTitleColor:DeafaultColor forState:UIControlStateSelected];
    [Rent setFrame:CGRectMake(SingleBtnWidth, 0, SingleBtnWidth,TopTabBarHeight )];
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

-(void)TabBarBtnClick :(UIButton *)btn {
    btn.selected = YES ;
    UIButton *anotherBtn = btn.tag ? _TabBarBtns[0]: _TabBarBtns[1] ;
    [UIView animateWithDuration:0.3f animations:^{
        anotherBtn.selected = NO;
        [_bottomLine setFrame:CGRectMake(btn.frame.origin.x + SingleBtnWidth/4, TopTabBarHeight -2 , SingleBtnWidth/2, 2)];
    }];
    if (btn.tag == 0) {  //出售
        [self LeftTableLoad];

    }else {
        [self RightTableLoad];

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.DataArr count];
}



- (void)tableInit {
    [self LeftTableLoad];
}


-(void)LeftTableLoad {
    self.currentPage = 1;
    _isFangyuan = YES ;
        NSMutableDictionary *parameters = [NSMutableDictionary new];
     //   if(_pramaDic ==nil) {  //即初始化
            NSDictionary *dict = @{
                                   @"isfangyuan":@"1",
                                   @"sum":@"8",
                                   @"currentpage":[NSString stringWithFormat:@"%d",self.currentPage]};
            [parameters setValuesForKeysWithDictionary:dict];
            self.pramaDic = parameters;
        
    self.isFangyuan  = YES;
    [self LoadNetDataWithCurentURl];
}

-(void)RightTableLoad {
    self.currentPage = 1;
    self.isFangyuan = NO ;
    [self.pramaDic setObject:@"0" forKey:@"isfangyuan"];
    [self.pramaDic setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"currentpage"];
    [self LoadNetDataWithCurentURl];
}



- (void)LoadNetDataWithCurentURl{
    [MBProgressHUD showMessage:@"正在加载"];
    NSLog(@"即将上线:%@,  %@",_CurrentRuest,self.pramaDic);
    //设置网络超时
    self.shareMgr.requestSerializer.timeoutInterval = 4.0;
    [self.shareMgr POST:self.CurrentRuest
             parameters: self.pramaDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [MBProgressHUD hideHUD];
                 NSLog(@"网络数据:%@",responseObject);
                 NSArray *DataArra = responseObject[@"data"];
                 if ([DataArra isKindOfClass:[NSArray class]]) {
                     self.userID  = responseObject[@""];
                     self.DataArr = DataArra;
                     [self.tableView reloadData];
                 }else {
                     [MBProgressHUD hideHUD];
                     self.DataArr = @[];
                     [self.tableView reloadData];
                     UIAlertView *aleat=[[UIAlertView alloc] initWithTitle:@"提醒" message:@"暂无相关信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [aleat show];
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:@"网络超时，稍后尝试"];
                 NSLog(@"%@",error);
                 NSLog(@"网络超时");
             }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *SingleData = self.DataArr[indexPath.row];
    
    

    NSLog(@"zushou:%@",SingleData[@"zushou"]);
    
    if(_isFangyuan) {
        if ([(NSNumber *)SingleData[@"zushou"] isEqualToNumber:[NSNumber numberWithBool:true]]) {  //1
            _status = RentOut  ; //出zu
        } else {
            _status = SalesOut;  //出shou
        }
    } else if(!_isFangyuan){
        if ((BOOL)SingleData[@"zugou"]) {
            _status =WantRent ; //求租
        } else {
            _status =WantBuy ;  //求购
        }
    }
    
    
    if (_status ==SalesOut) {
//        UITableViewCell
        _preName = @"[出售]";
        static NSString *ID = @"UITableViewCell";
        SalesCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell ==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SalesCell" owner:nil options:nil] firstObject];
        }
        
#pragma mark 售价高亮属性
        NSString *PriceString = [NSString stringWithFormat:@"%@万元",SingleData[@"shoujia"]];
        NSMutableAttributedString *HiligntNo = [[NSMutableAttributedString alloc]initWithString:PriceString];
        NSRange NoRange = NSMakeRange(0, [PriceString length]-2);
        [HiligntNo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NoRange];
        [HiligntNo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ]  range:NoRange];
        
        NSString *imgCollects = SingleData[@"tupian"];
        NSArray *imgArray = [imgCollects componentsSeparatedByString:@","];
        NSString *imgURL = [NSString stringWithFormat:@"http://www.123qf.cn/img/%@/userfile/qfzs/fy/mini/%@",SingleData[@"userid"],[imgArray firstObject]];
        
        
        NSString *BigTitle = [NSString stringWithFormat:@"%@%@",_preName,SingleData[@"biaoti"]];
        NSArray *titlePartArra = [BigTitle componentsSeparatedByString:@" "]; //
        UIImage  *PlaceHoder = [UIImage imageNamed:@"DeafaultImage"];
        PlaceHoder = [PlaceHoder imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [cell.QFImageView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:PlaceHoder];
        cell.title.text = [titlePartArra firstObject];
        cell.area.text  = [NSString stringWithFormat:@"面积:%@㎡",SingleData[@"mianji"]];
        [cell.style setHidden:YES];
        cell.style.text = [NSString stringWithFormat:@"%@室%@厅%@卫%@阳台", [self judgeNullValue: SingleData[@"fangshu"]],
                           [self judgeNullValue: SingleData[@"tingshu"]],
                           [self judgeNullValue: SingleData[@"toilets"]],
                           [self judgeNullValue: SingleData[@"balconys"]]];//@"%@室%@厅%阳台";;
        
        if([SingleData[@"dianti"] isKindOfClass:[NSNull class]]){
            cell.elevator.text = @"";
        } else {
            cell.elevator.text = @"电梯";
        }
        [cell.elevator setHidden:YES];
        
        cell.price.text =[NSString stringWithFormat:@"%@万",PriceString];
        [cell.price setAttributedText:HiligntNo];
        
        NSString *Publisher =SingleData[@"publisher"];
        if ([Publisher isKindOfClass:[NSNull class]]) {
            cell.postUer.text = @"佚名";
        }else{
            cell.postUer.text =[NSString stringWithFormat:@"发布人:%@",SingleData[@"publisher"]];
            [cell.postUer setHidden:YES];
        }
        cell.postTime.text = [NSString stringWithFormat:@"发布时间:%@",SingleData[@"weituodate"]];
        return cell;
        
        
        
    } else if (_status ==RentOut) {
        _preName = @"[出租]";
        //这里服务器暂无数据
        static NSString *ID = @"identifer";
        SalesCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell ==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SalesCell" owner:nil options:nil] firstObject];
        }
        
#pragma mark 售价高亮属性
        NSString *PriceString = [NSString stringWithFormat:@"%@元/月",SingleData[@"shoujia"]];
        NSMutableAttributedString *HiligntNo = [[NSMutableAttributedString alloc]initWithString:PriceString];
        NSRange NoRange = NSMakeRange(0, [PriceString length]-3);
        [HiligntNo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NoRange];
        [HiligntNo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16 ]  range:NoRange];
        
        NSString *imgCollects = SingleData[@"tupian"];
        NSArray *imgArray = [imgCollects componentsSeparatedByString:@","];
        NSString *imgURL = [NSString stringWithFormat:@"http://www.123qf.cn/img/%@/userfile/qfzs/fy/mini/%@",SingleData[@"userid"],[imgArray firstObject]];
        
        
        NSString *BigTitle = [NSString stringWithFormat:@"%@%@",_preName,SingleData[@"biaoti"]];
        NSArray *titlePartArra = [BigTitle componentsSeparatedByString:@" "]; //
        UIImage  *PlaceHoder = [UIImage imageNamed:@"DeafaultImage"];
        PlaceHoder = [PlaceHoder imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [cell.QFImageView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:PlaceHoder];
        cell.title.text = [titlePartArra firstObject];
        cell.area.text  = [NSString stringWithFormat:@"面积:%@㎡",SingleData[@"mianji"]];
        [cell.style setHidden:YES];
        cell.style.text = [NSString stringWithFormat:@"%@室%@厅%@卫%@阳台", [self judgeNullValue: SingleData[@"fangshu"]],
                           [self judgeNullValue: SingleData[@"tingshu"]],
                           [self judgeNullValue: SingleData[@"toilets"]],
                           [self judgeNullValue: SingleData[@"balconys"]]];//@"%@室%@厅%阳台";;
        
        
        if([SingleData[@"dianti"] isKindOfClass:[NSNull class]]){
            cell.elevator.text = @"";
        } else {
            cell.elevator.text = @"电梯";
        }
        [cell.elevator setHidden:YES];
        
        
        
        cell.price.text =[NSString stringWithFormat:@"%@万",PriceString];
        [cell.price setAttributedText:HiligntNo];
        
        NSString *Publisher =SingleData[@"publisher"];
        [cell.postUer setHidden:YES];
        if ([Publisher isKindOfClass:[NSNull class]]) {
            cell.postUer.text = @"佚名";
        }else{
            cell.postUer.text =[NSString stringWithFormat:@"发布人:%@",SingleData[@"publisher"]];
        }
        cell.postTime.text = [NSString stringWithFormat:@"发布时间:%@",SingleData[@"weituodate"]];
        return cell;
        
    } else if (_status ==WantBuy) {
        _preName =@"[求购]";
        static NSString *ID = @"identiferWantBuy";
        
        KeyuanCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell ==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KeyuanCell" owner:nil options:nil] firstObject];
        }
        
        
        //  NSString
        
        NSString *PriceString = [NSString stringWithFormat:@"%@万元",SingleData[@"pricel"]];
        NSMutableAttributedString *HiligntNo = [[NSMutableAttributedString alloc]initWithString:PriceString];
        NSRange NoRange = NSMakeRange(0, [PriceString length]-2);
        [HiligntNo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NoRange];
        [HiligntNo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ]  range:NoRange];
        
        cell.titileLabel.text =[NSString stringWithFormat:@"%@%@",_preName,SingleData[@"biaoti"]]; //[self judgeNullValue:SingleData[@"biaoti"]]; //SingleData[@"biaoti"];
        cell.acreaLabel.text =[NSString stringWithFormat:@"面积:%@㎡",[self judgeNullValue: SingleData[@"acreage"]]];//@"面积:110㎡";
        cell.roomsContLabel.text = [NSString stringWithFormat:@"%@室%@厅%@卫%@阳台", [self judgeNullValue: SingleData[@"fangshu"]],
                                    [self judgeNullValue: SingleData[@"tingshu"]],
                                    [self judgeNullValue: SingleData[@"toilets"]],
                                    [self judgeNullValue: SingleData[@"balconys"]]];//@"%@室%@厅%阳台";
        
        
        
        
        cell.attachmentLabel.text =@"   ";
        cell.requestDescrbeLabel.text = [self judgeNullValue:SingleData[@"fangyuanmiaoshu"]];   // @"阳光采光要好";
        cell.priceLabel.text = PriceString;//@"110万";
        [cell.priceLabel setAttributedText:HiligntNo]; //将红色属性添加进去
        cell.publisherLabel.text = [self judgeNullValue:SingleData[@"publisher"]]; //@"内马尔";
        cell.postTimeLabel.text  = [self judgeNullValue:SingleData[@"weituodate"]];  //@"2015-12-10 10:32:28";
        return cell;
        
    }else {
        _preName =@"[求租]";
        static NSString *ID = @"identiferWantRent";
        
        KeyuanCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell ==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KeyuanCell" owner:nil options:nil] firstObject];
        }
        
        
        //  NSString
        
        NSString *PriceString = [NSString stringWithFormat:@"%@元/月",SingleData[@"pricel"]];
        NSMutableAttributedString *HiligntNo = [[NSMutableAttributedString alloc]initWithString:PriceString];
        NSRange NoRange = NSMakeRange(0, [PriceString length]-2);
        [HiligntNo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NoRange];
        [HiligntNo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ]  range:NoRange];
        
        cell.titileLabel.text =[NSString stringWithFormat:@"%@%@",_preName,SingleData[@"biaoti"]]; //[self judgeNullValue:SingleData[@"biaoti"]]; //SingleData[@"biaoti"];
        cell.acreaLabel.text =[NSString stringWithFormat:@"面积:%@㎡",[self judgeNullValue: SingleData[@"acreage"]]];//@"面积:110㎡";
        cell.roomsContLabel.text = [NSString stringWithFormat:@"%@室%@厅%@阳台", [self judgeNullValue: SingleData[@"fangshu"]],
                                    [self judgeNullValue: SingleData[@"fangshu"]],
                                    [self judgeNullValue: SingleData[@"fangshu"]]];//@"%@室%@厅%阳台";
        
        
        
        
        cell.attachmentLabel.text =@"   ";
        cell.requestDescrbeLabel.text = [self judgeNullValue:SingleData[@"fangyuanmiaoshu"]];   // @"阳光采光要好";
        cell.priceLabel.text = PriceString;//@"110万";
        [cell.priceLabel setAttributedText:HiligntNo]; //将红色属性添加进去
        cell.publisherLabel.text = [self judgeNullValue:SingleData[@"publisher"]]; //@"内马尔";
        cell.postTimeLabel.text  = [self judgeNullValue:SingleData[@"weituodate"]];  //@"2015-12-10 10:32:28";
        return cell;
        
        
        
    }

}



-(NSString *)judgeNullValue:(NSString *)string{
    if ([string isKindOfClass:[NSNull class]]) {
            return @"";
    }
    else  return string;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //解除遗留灰色
    
    //   self.HomeVCdelegate = nil;
    NSDictionary *SingleData = self.DataArr[indexPath.row];
    if (_status ==SalesOut) {
        //出售详情页
        NSString *Id = SingleData[@"id"];   //将房源ID传过去
        NSString *userID = SingleData[@"userid"];
        NSString *name = [self judgeNullValue:SingleData[@"mingcheng"]];
        NSString *Category = [NSString stringWithFormat:@"%@",SingleData[@"fenlei"]];
        [self.HomeVCdelegate QFshowDetailWithFangYuanID:Id andFenlei:Category userID:userID XiaoquName:name ListStatus:_preName];
    } else if (_status == RentOut) {
        //出租详情页  (服务器暂无数据，小灰手机也没有参考的)
        
        NSString *Id = SingleData[@"id"];   //将房源ID传过去
        NSString *userID = SingleData[@"userid"];
        NSString *name = [self judgeNullValue:SingleData[@"mingcheng"]];
        NSString *Category = [NSString stringWithFormat:@"%@",SingleData[@"fenlei"]];
        [self.HomeVCdelegate QFshowDetailWithFangYuanID:Id andFenlei:Category userID:userID XiaoquName:name ListStatus:_preName];
        
    } else if (_status == WantBuy) {
        //求购详情页
        
        [self.HomeVCdelegate QFShowZugouDetailWithFanLei:SingleData[@"fenlei"] andKeyuanID:SingleData[@"id"] andTitle:SingleData[@"biaoti"]];
        
        
    }else {
        //求租详情页
        _preName =@"[求组]";
        [self.HomeVCdelegate QFShowZugouDetailWithFanLei:SingleData[@"fenlei"] andKeyuanID:SingleData[@"id"] andTitle:SingleData[@"bitoti"]];
        
    }
}

-(void)loadMoreData {
    _currentPage ++;
    [self.pramaDic setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"currentpage"];
    [self.shareMgr POST:self.CurrentRuest parameters:self.pramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"追加:%@",responseObject);
        [self.tableView footerEndRefreshing];
        if ([(NSString *)responseObject[@"code"]isEqualToString:@"1"]) {
            NSArray *appendArr = responseObject[@"data"];
            self.DataArr = [self.DataArr arrayByAddingObjectsFromArray:appendArr];
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showError:@"无更多数据了哟"];
            // NSLog(@"无更多数据了哟");
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.tableView headerEndRefreshing];
        [MBProgressHUD showError:@"网络超时，稍后尝试"];
        NSLog(@"%@",error);
        NSLog(@"网络超时");
        NSLog(@"%@",error);
    }];
    NSLog(@"上拉");
}


-(void)canleStar {
    
}


//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

////进入编辑模式，按下出现的编辑按钮后
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView setEditing:NO animated:YES];
//}

//以下方法可以不是必须要实现，添加如下方法可实现特定效果：

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
