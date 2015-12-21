//
//  InnerBasicViewController.m
//  清房助手
//
//  Created by Larry on 12/20/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

/**
   说明: 1.本页面是TaBar下四个VC的类  ，
 */

#import "InnerBasicViewController.h"
#import "HomeViewController.h"
#import "InnerCustomer.h"
#import "MBProgressHUD+CZ.h"
#import "AFNetworking.h"
#import "PopSeletedView.h"
#import "TableViewController.h"
#import "HomeViewController.h"
#import "FilterViewController.h"
#import "DetailViewController.h"


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
#import "TableViewController.h"
#import "PopSeletedView.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>


#import "KeyuanCell.h"
#import "LesveMsgVC.h"
#import "ZuGouDetailViewController.h"

#define  checkNoBtnHeight  30
#define  checkNoBtnWidght  100

@interface InnerBasicViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString   *_LeftListUrl;
    NSString   *_RightListUrl;
    NSString   *_CurentUrl;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)  AFHTTPRequestOperationManager            *shareMgr;
@property(nonatomic,strong)  NSMutableDictionary                      *pramaDic;
@property(nonatomic,strong)  NSArray                                 *DataArr;

@end

@implementation InnerBasicViewController

-(NSMutableDictionary*)pramaDic {
    if (_pramaDic ==nil) {
        _pramaDic = [NSMutableDictionary new];
    }
    return _pramaDic;
}

-(AFHTTPRequestOperationManager *)shareMgr {
    if (_shareMgr ==nil) {
        _shareMgr = [AFHTTPRequestOperationManager new];
    }
    return _shareMgr;
}


-(NSArray*)DataArr {
    if (_DataArr ==nil) {
        _DataArr = [NSArray new];
    }
    return _DataArr;
}

-(id)initWithUrl:(NSString *)CurrentTableUrl;{
        self = [super init];
    UIButton *RightBarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 27)];
    NSLog(@"QIAN ：rightBtn : %@", RightBarBtn);
    NSLog(@"NavController:%@",self.navigationController);
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"筛选"]];
    [img setFrame:CGRectMake(0, 0, 27, 27)];
    [RightBarBtn addSubview:img];
    [RightBarBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [RightBarBtn addTarget:self action:@selector(ConditionsFilter) forControlEvents:UIControlEventTouchUpInside];
    [RightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RightBarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
    UIBarButtonItem *gripeBarBtn = [[UIBarButtonItem alloc]initWithCustomView:RightBarBtn];
    self.navigationItem.rightBarButtonItem =gripeBarBtn;
    NSLog(@"HOU ：rightBtn : %@", self.navigationItem.rightBarButtonItem);
    
    //导航栏颜色
    self.navigationController.navigationBar.barTintColor = [DeafaultColor2 colorWithAlphaComponent:0.5];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    //返回按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Dissback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationController.navigationBar.barTintColor = [DeafaultColor2 colorWithAlphaComponent:0.5];
    self.navigationController.navigationItem.leftBarButtonItem = back ;
    self.navigationItem.leftBarButtonItem = back ;
    
    
    //搜索
    TableViewController *tableVC = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
    NSLog(@"tableVC:%@",tableVC);
    self.ResultTableView = tableVC;
    _searchVC = [[UISearchController alloc]initWithSearchResultsController:tableVC];
    NSLog(@"_searchVC:%@",_searchVC);
    _searchVC.searchResultsUpdater = tableVC;
    _searchVC.hidesNavigationBarDuringPresentation = NO;
    [_searchVC.searchBar sizeToFit];
    self.navigationItem.titleView = _searchVC.searchBar;
    self.definesPresentationContext = YES; //2152632369
    
        _CurentUrl  = CurrentTableUrl ;
        return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavColor];
    [self LoadNetDataWithCurentURl];
    [self setUpCheckBtn];
    self.edgesForExtendedLayout = UIRectEdgeNone ;
}

-(void)setUpCheckBtn {
    UIButton *checkTeleNoBtn = [[UIButton alloc]init];
    [checkTeleNoBtn addTarget:self action:@selector(CheckBtn) forControlEvents:UIControlEventTouchUpInside];
    [checkTeleNoBtn setTitle:@"客户电话  >" forState:UIControlStateNormal];
    checkTeleNoBtn.layer.cornerRadius = 4;
    checkTeleNoBtn.layer.borderWidth  = 1;
    checkTeleNoBtn.layer.borderColor  = [DeafaultColor3 CGColor];
    
    [checkTeleNoBtn setTitleColor:DeafaultColor3 forState:UIControlStateNormal];
    [checkTeleNoBtn setFrame:CGRectMake(ScreenWidth- checkNoBtnWidght -6 , (100 -checkNoBtnHeight)/2 + 64   ,checkNoBtnWidght, checkNoBtnHeight)];
    [self.view addSubview:checkTeleNoBtn];
}

-(void)CheckBtn {
    LesveMsgVC *LMsg = [[LesveMsgVC alloc]init];
    LMsg.ownerNameStr= @"刘强东";
    LMsg.ownerTeleStr = @"1876561233";
    [self.navigationController pushViewController:LMsg animated:YES];
}

-(void)initNavColor {
    // 奇怪导航栏的颜色在init 里面修改不不了 ，只能在 ViewDidLoad 里面了
    self.navigationController.navigationBar.barTintColor = [DeafaultColor2 colorWithAlphaComponent:0.5];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    //跳转时隐藏
    

}

//返回系统首页
-(void)Dissback {
    [self dismissViewControllerAnimated:YES completion:nil];
    HomeViewController *home = [HomeViewController new];
    KeyWindow.rootViewController = home;
}


#pragma mark TableMethodDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //  return 15;
       return self.DataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *SingleData = self.DataArr[indexPath.row];
    if (_type ==FangYuan) {
        //展示房源的列表
        static NSString *ID = @"identifer";
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
        NSString *imgURL = [NSString stringWithFormat:@"http://www.123qf.cn/testWeb/img/%@/userfile/qfzs/fy/mini/%@",SingleData[@"userid"],[imgArray firstObject]];
        
        
        NSString *BigTitle = [NSString stringWithFormat:@"%@",SingleData[@"biaoti"]];
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


    }else {
        //展示客源的列表
//        static NSString *ID = @"identifer";
//        
//        KeyuanCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
//        if (cell ==nil) {
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"KeyuanCell" owner:nil options:nil] firstObject];
//        }
//        cell.titileLabel.text =@"求购一套廉价的住房";
//        cell.acreaLabel.text =@"面积:110㎡";
//        cell.roomsContLabel.text = @"2室2厅1阳台";
//        cell.attachmentLabel.text =@"洗衣机 冰箱";
//        cell.requestDescrbeLabel.text = @"阳光采光要好";
//        cell.priceLabel.text = @"110万";
//        cell.publisherLabel.text = @"内马尔";
//        cell.postTimeLabel.text =@"2015-12-10 10:32:28";
//        return cell;
        
        
        
        
      
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
        
        cell.titileLabel.text =[NSString stringWithFormat:@"%@",SingleData[@"biaoti"]]; //[self judgeNullValue:SingleData[@"biaoti"]]; //SingleData[@"biaoti"];
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
        
        
        
    }


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
#pragma mark 点击后进入详情页

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%d",_type);
    //有可能是房源的详情页，也有可能是客源详情页
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //解除遗留灰色
    NSDictionary *SingleData = self.DataArr[indexPath.row];
    
    if (_type ==FangYuan) {
        //展示房源的详情页面
        NSString *Id = SingleData[@"id"];   //将房源ID传过去
        NSString *userID = SingleData[@"userid"];
        NSString *name = [self judgeNullValue:SingleData[@"mingcheng"]];
        NSString *Category = [NSString stringWithFormat:@"%@",SingleData[@"fenlei"]];
        
        DetailViewController *test = [DetailViewController new];
        test.title = name;
        test.PreTitle = @"出售";
        test.DisplayId = Id;
        test.FenLei = Category;
        test.uerID = userID;
        [self.navigationController pushViewController:test animated:YES];
    }else {
        //展示客源的详情页面
        ZuGouDetailViewController *VC  = [[ZuGouDetailViewController alloc]init];
        VC.title = SingleData[@"biaoti"];
        VC.fenlei = SingleData[@"fenlei"];
        VC.keYuanID = SingleData[@"id"];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    
    
    
    
    

}

-(NSString *)judgeNullValue:(NSString *)string{
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    else  return string;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //解除遗留灰色
//    NSDictionary *SingleData = self.DataArr[indexPath.row];
//    NSString *Id = SingleData[@"id"];   //将房源ID传过去
//    NSString *userID = SingleData[@"userid"];
//    NSString *name = [self judgeNullValue:SingleData[@"mingcheng"]];
//    NSString *Category = [NSString stringWithFormat:@"%@",SingleData[@"fenlei"]];
//    [self.HomeVCdelegate QFshowDetailWithFangYuanID:Id andFenlei:Category userID:userID XiaoquName:name ListStatus:_preName];
//}



//-(void)QFshowDetailWithFangYuanID:(NSString *)FangId andFenlei:(NSString *)Fenlei userID:(NSString *)UserId XiaoquName:(NSString *)name ListStatus:(NSString *)status {
//    DetailViewController *test = [DetailViewController new];
//    test.title = name;
//    test.PreTitle = status;
//    test.DisplayId = FangId;
//    test.FenLei = Fenlei;
//    test.uerID = UserId;
//    [self.messageNav pushViewController:test animated:YES];
//}

/**
 *  加载网络数据
 */
- (void) LoadNetDataWithCurentURl{
    [MBProgressHUD showMessage:@"正在加载"];
    NSLog(@"即将上线:%@,  %@",_CurentUrl,self.pramaDic);
    [self.shareMgr POST:_CurentUrl
             parameters: self.pramaDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [MBProgressHUD hideHUD];
                 NSLog(@"右选项卡%@",responseObject);
                 NSArray *DataArra = responseObject[@"data"];
                 self.DataArr = [DataArra copy];
                 if ([DataArra isKindOfClass:[NSArray class]]) {
                     NSLog(@"tabBarData : %@",responseObject);
                     [self.tableView reloadData];
                 }else {
                     self.DataArr = @[];
                     [self.tableView reloadData];
                     UIAlertView *aleat=[[UIAlertView alloc] initWithTitle:@"提醒" message:@"暂无相关信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [aleat show];
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];
}


-(void)ConditionsFilter{
   [MBProgressHUD showSuccess:@"建设中"];
}




@end
