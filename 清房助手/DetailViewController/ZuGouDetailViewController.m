//
//  ZuGouDetailViewController.m
//  清房助手
//
//  Created by Larry on 12/21/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//
/**
   说明: 本页面是用来展示，求租、求购的详细信息页
 */

#import "ZuGouDetailViewController.h"
#import "ZuGouHeadCell.h"
#import "ZuGouDetailCell.h"
#import "ZuGouDescribeCell.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD+CZ.h"
#import "DSNavigationBar.h"
#import "AFNetworking.h"
#import "SharePopVC.h"
#import "HttpTool.h"
#import "UIImageView+WebCache.h"
#import "LesveMsgVC.h"
#import "ZuGouDetailShangPuCell.h"
#import "OpenShareHeader.h"
#import "AppDelegate.h"

#define  HeavyFont     [UIFont fontWithName:@"Helvetica-Bold" size:25]
#define  ToolHeight  50    //固定底部的大小
#define LeftViewWidth   ScreenWidth/4
#define MiddleViewWidth   ScreenWidth/2
#define RightViewWidth   ScreenWidth/4
#define Padding  8
#define IMGGALLAERY 10
#define DETAILTABLE   11
#define ImgScoviewTag 12

#define ModalViewTag   99

#define DSystenVersion            ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion            ([[UIDevice currentDevice] systemVersion])


@interface ZuGouDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,SharePopdelegate> {
//    isThereOwnerInfo;
}

@property (strong, nonatomic)  UIScrollView *scrollView3;
@property (strong, nonatomic)  UITableView *detailInfoTable;
@property (strong, nonatomic)  NSMutableArray *imagesData;
@property(nonatomic)           CGFloat CellHeight;
@property(nonatomic)           CGFloat DescribeCellHeight;
@property(nonatomic)           CGFloat FreeCellHeight;
@property(nonatomic)           NSInteger ImgTotal;
@property(nonatomic,assign)    BOOL isThereOwnerInfo;
@property(nonatomic,assign)    CellStatus Status;
@property(nonatomic,strong)    NSDictionary  *FangData;
@property(nonatomic,strong)    UIView  *HeaderContent;
@property(nonatomic,strong)    NSDictionary *CurrentSingleData;
@property(nonatomic,strong)    UILabel *Name;
@property(nonatomic,strong)    UILabel *Publisher;
@property(nonatomic,strong)    UILabel *Tele;
@property(nonatomic,strong)      UIButton *CountLabel;
@property(nonatomic,strong)    AFHTTPRequestOperationManager *sharedMgr;
@property(nonatomic,strong)  NSDictionary  *CheckBtnInfoDic;




@end

#define  checkNoBtnHeight  30
#define  checkNoBtnWidght  100
@implementation ZuGouDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTable];
    [self initFootView];
    [self initNavController];
    [self getDataFromNet];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
   

}

-(NSDictionary *)FangData {
    if (_FangData == nil) {
        _FangData = [NSDictionary dictionary];
    }
    return _FangData;
}

-(NSDictionary*)CheckBtnInfoDic {
    if (_CheckBtnInfoDic ==nil) {
        _CheckBtnInfoDic = [NSDictionary new];
    }
    return _CheckBtnInfoDic;
}


//加白布遮挡，会有瑕疵动画
- (void)addWhiteBack {
    UIView *MengBan = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
    MengBan.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:MengBan];
    [self.view bringSubviewToFront:MengBan];
    MengBan.tag = 999;
 
}


/**
 *  设置查看业主信息按钮
 */

-(void)setUpCheckBtn {
    UIButton *checkTeleNoBtn = [[UIButton alloc]init];
    [checkTeleNoBtn addTarget:self action:@selector(CheckBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [checkTeleNoBtn setTitle:@"客户电话  >" forState:UIControlStateNormal];
    checkTeleNoBtn.layer.cornerRadius = 4;
    checkTeleNoBtn.layer.borderWidth  = 1;
    checkTeleNoBtn.layer.borderColor  = [DeafaultColor3 CGColor];
    
    [checkTeleNoBtn setTitleColor:DeafaultColor3 forState:UIControlStateNormal];
    [checkTeleNoBtn setFrame:CGRectMake(ScreenWidth- checkNoBtnWidght -6 , (100 -checkNoBtnHeight)/2 + 64   ,checkNoBtnWidght, checkNoBtnHeight)];
    [self.view addSubview:checkTeleNoBtn];
}


/**
 *  查看按钮被按下
 */
-(void)CheckBtnClick {
    if (_isThereOwnerInfo) {

        
        LesveMsgVC *LMsg  = [[LesveMsgVC alloc]init];
        LMsg.QFownerInfoDic = self.CheckBtnInfoDic;
        
        [self.navigationController pushViewController:LMsg animated:YES];
    }else {
        UIAlertView *AW = [[UIAlertView alloc]initWithTitle:@"未含信息"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
        
        [AW show];
    }
}

/**
 
 *  检查业主信息
 */
-(void)checkKeyuanInfo {
  //  NSString *URL =@"http://www.123qf.cn:81/testApp/fkyuan/selectOwnerInfo.api";
      NSString *URL =@"http://www.123qf.cn/app/fkyuan/selectOwnerInfo.api";
    NSMutableDictionary *pramaDic = [NSMutableDictionary new];
    NSLog(@"FangData:%@",self.FangData);
    pramaDic[@"kid"] = self.FangData[@"id"];
    pramaDic[@"currentpage"] = @"1";
    
        NSLog(@"kid:%@",pramaDic[@"kid"]);
    NSLog(@"Dic:%@",pramaDic);
    [self.sharedMgr POST:URL parameters:pramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        self.CheckBtnInfoDic = responseObject[@"data"];
        NSNumber *flag = responseObject[@"code"];
        NSNumber *Judge =  [NSNumber numberWithInt:1];
        if ([flag isEqualToNumber:Judge]) {
            _isThereOwnerInfo =  YES;
            NSLog(@" xxx  %d",_isThereOwnerInfo);
        }else {
            _isThereOwnerInfo =  NO;
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}





#pragma mark -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *ZeroNo = [NSNumber numberWithInt:0];
    NSNumber *OneNo  = [NSNumber numberWithInt:1];
    NSNumber *TwoNo  = [NSNumber numberWithInt:2];
    
    if ([self.FangData[@"fenlei"] isEqualToNumber:ZeroNo]) {  //住房_Start
        NSDictionary *dic = self.FangData;
        ZuGouHeadCell *Headcell = [[ZuGouHeadCell alloc]init];
        ZuGouDescribeCell *Describecell = [[ZuGouDescribeCell alloc]init];
        ZuGouDetailCell *Detailcell = [[ZuGouDetailCell alloc]init];
        if (indexPath.row ==0) {
            NSNumber *ZeroNo = [NSNumber numberWithInt:0];
            Headcell  =  [[[NSBundle mainBundle]loadNibNamed:@"ZuGouHeadCell" owner:nil options:nil] firstObject];
            Headcell.QFtitle.text  = dic[@"biaoti"];
            
            NSString *price;
            if ([dic[@"pricef"] length]==0 && [dic[@"pricel"] length] == 0) {
                price = @"价格不限";
            } else {
                price =[NSString stringWithFormat:@"%@-%@%@",dic[@"pricef"],dic[@"pricel"],dic[@"unit"]];
            }
            //添加高亮属性
            NSMutableAttributedString *HiligntNo = [[NSMutableAttributedString alloc]initWithString:price];
            NSRange NoRange ;
            if ([dic[@"zugou"] isEqualToNumber:ZeroNo]) {
                //求租
                NoRange = NSMakeRange(0, [price length]-1);
            } else if ([dic[@"pricef"] length]==0 && [dic[@"pricel"] length] == 0) {
                NoRange = NSMakeRange(0, 4);
            }
            else {
                NoRange = NSMakeRange(0, [price length]-2);
            }
            [HiligntNo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NoRange];
            [HiligntNo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ]  range:NoRange];
            
            Headcell.QFprice.text = price;
            [Headcell.QFprice setAttributedText:HiligntNo];
            Headcell.QFweiTuoDate.text = dic[@"weituodate"];
            return Headcell;
        }else if (indexPath.row ==1)
        {
            Detailcell  =  [[[NSBundle mainBundle]loadNibNamed:@"ZuGouDetailCell" owner:nil options:nil] firstObject];
            NSString *test = [NSString stringWithFormat:@"%@%@%@%@",[self judgeNullValue:dic[@"shengfen"]],
                              [self judgeNullValue:dic[@"shi"]],
                              [self judgeNullValue:dic[@"qu"]],
                              [self judgeNullValue:dic[@"region"]]];
            NSLog(@"RegionLabel %@",test);
            Detailcell.regionLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[self judgeNullValue:dic[@"shengfen"]],
                                           [self judgeNullValue:dic[@"shi"]],
                                           [self judgeNullValue:dic[@"qu"]],
                                           [self judgeNullValue:dic[@"region"]]];
            
            
            Detailcell.RoomStyleLabel.text =[NSString stringWithFormat:@"%@室%@厅%@卫%@阳台", [self judgeNullValue: dic[@"fangshu"]],
                                             [self judgeNullValue: dic[@"tingshu"]],
                                             [self judgeNullValue: dic[@"toilets"]],
                                             [self judgeNullValue: dic[@"balconys"]]];   //@"%@室%@厅%阳台";
            NSString *mianjiStr = [self judgeNullValue:dic[@"acreage"]];
            Detailcell.aceaLabel.text =(mianjiStr.length)?[NSString stringWithFormat:@"%@㎡",dic[@"acreage"]]: @"不限";  //如果返回面积为空，则显示面积不限
            Detailcell.DecorationLabel.text = dic[@"zhuangxiuyaoqiu"];  //@"简装修";
            Detailcell.Expritime.text = [NSString stringWithFormat:@"%@个月",dic[@"youxiaoqi"]];   //@"三个月";
            //配套设施
            
            Detailcell.attachMent.text = [self getAttacMentFromDataDic];
            
            return Detailcell;
        }else
        {
            Describecell =  [[[NSBundle mainBundle]loadNibNamed:@"ZuGouDescribeCell" owner:nil options:nil] firstObject];
            Describecell.contentCell.numberOfLines = 0;
            Describecell.contentCell.text = dic[@"fangyuanmiaoshu"];
            return Describecell;
        }

    } //end_住房
     else if ([self.FangData[@"fenlei"] isEqualToNumber:OneNo])
       {  //start_商铺
        NSDictionary *dic = self.FangData;
        ZuGouHeadCell *Headcell = [[ZuGouHeadCell alloc]init];
        ZuGouDescribeCell *Describecell = [[ZuGouDescribeCell alloc]init];
        ZuGouDetailShangPuCell *Detailcell = [[ZuGouDetailShangPuCell alloc]init];
        if (indexPath.row ==0) {
            NSNumber *ZeroNo = [NSNumber numberWithInt:0];
            Headcell  =  [[[NSBundle mainBundle]loadNibNamed:@"ZuGouHeadCell" owner:nil options:nil] firstObject];
            Headcell.QFtitle.text  = dic[@"biaoti"];
            NSString *price =[NSString stringWithFormat:@"%@-%@%@",dic[@"pricef"],dic[@"pricel"],dic[@"unit"]];
            //添加高亮属性
            NSMutableAttributedString *HiligntNo = [[NSMutableAttributedString alloc]initWithString:price];
            NSRange NoRange ;
            if ([dic[@"zugou"] isEqualToNumber:ZeroNo]) {
                //求租
                NoRange = NSMakeRange(0, [price length]-1);
            } else {
                NoRange = NSMakeRange(0, [price length]-2);
            }
            [HiligntNo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NoRange];
            [HiligntNo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ]  range:NoRange];
            
            Headcell.QFprice.text = price;
            [Headcell.QFprice setAttributedText:HiligntNo];
            Headcell.QFweiTuoDate.text = dic[@"weituodate"];
            return Headcell;
        }else if (indexPath.row ==1)
        {
            Detailcell  =  [[[NSBundle mainBundle]loadNibNamed:@"ZuGouDetailShangPuCell" owner:nil options:nil] firstObject];
            NSString *test = [NSString stringWithFormat:@"%@%@%@%@",[self judgeNullValue:dic[@"shengfen"]],
                              [self judgeNullValue:dic[@"shi"]],
                              [self judgeNullValue:dic[@"qu"]],
                              [self judgeNullValue:dic[@"region"]]];
            NSLog(@"RegionLabel %@",test);
            Detailcell.regionLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[self judgeNullValue:dic[@"shengfen"]],
                                           [self judgeNullValue:dic[@"shi"]],
                                           [self judgeNullValue:dic[@"qu"]],
                                           [self judgeNullValue:dic[@"region"]]];
            
            
            Detailcell.RoomStyleLabel.text =dic[@"leixing"];   //@"%@室%@厅%阳台";
            NSString *mianjiStr = [self judgeNullValue:dic[@"acreage"]];
            Detailcell.aceaLabel.text =(mianjiStr.length)?[NSString stringWithFormat:@"%@㎡",dic[@"acreage"]]: @"不限";  //如果返回面积为空，则显示面积不限
            Detailcell.DecorationLabel.text = dic[@"zhuangxiuyaoqiu"];  //@"简装修";
            Detailcell.Expritime.text = [NSString stringWithFormat:@"%@个月",dic[@"youxiaoqi"]];   //@"三个月";
            //配套设施
            
            Detailcell.attachMent.text = [self getAttacMentFromDataDic];
            
            return Detailcell;
        }else
        {
            Describecell =  [[[NSBundle mainBundle]loadNibNamed:@"ZuGouDescribeCell" owner:nil options:nil] firstObject];
            Describecell.contentCell.numberOfLines = 0;
            Describecell.contentCell.text = dic[@"fangyuanmiaoshu"];
            return Describecell;
        }

    }  //end_商铺
     else {    //start_写字楼
         NSDictionary *dic = self.FangData;
         ZuGouHeadCell *Headcell = [[ZuGouHeadCell alloc]init];
         ZuGouDescribeCell *Describecell = [[ZuGouDescribeCell alloc]init];
         ZuGouDetailShangPuCell *Detailcell = [[ZuGouDetailShangPuCell alloc]init];
         if (indexPath.row ==0) {
             NSNumber *ZeroNo = [NSNumber numberWithInt:0];
             Headcell  =  [[[NSBundle mainBundle]loadNibNamed:@"ZuGouHeadCell" owner:nil options:nil] firstObject];
             Headcell.QFtitle.text  = dic[@"biaoti"];
             NSString *price =[NSString stringWithFormat:@"%@-%@%@",dic[@"pricef"],dic[@"pricel"],dic[@"unit"]];
             //添加高亮属性
             NSMutableAttributedString *HiligntNo = [[NSMutableAttributedString alloc]initWithString:price];
             NSRange NoRange ;
             if ([dic[@"zugou"] isEqualToNumber:ZeroNo]) {
                 //求租
                 NoRange = NSMakeRange(0, [price length]-1);
             } else {
                 NoRange = NSMakeRange(0, [price length]-2);
             }
             [HiligntNo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NoRange];
             [HiligntNo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ]  range:NoRange];
             
             Headcell.QFprice.text = price;
             [Headcell.QFprice setAttributedText:HiligntNo];
             Headcell.QFweiTuoDate.text = dic[@"weituodate"];
             return Headcell;
         }else if (indexPath.row ==1)
         {
             Detailcell  =  [[[NSBundle mainBundle]loadNibNamed:@"ZuGouDetailShangPuCell" owner:nil options:nil] firstObject];
             NSString *test = [NSString stringWithFormat:@"%@%@%@%@",[self judgeNullValue:dic[@"shengfen"]],
                               [self judgeNullValue:dic[@"shi"]],
                               [self judgeNullValue:dic[@"qu"]],
                               [self judgeNullValue:dic[@"region"]]];
             NSLog(@"RegionLabel %@",test);
             Detailcell.regionLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[self judgeNullValue:dic[@"shengfen"]],
                                            [self judgeNullValue:dic[@"shi"]],
                                            [self judgeNullValue:dic[@"qu"]],
                                            [self judgeNullValue:dic[@"region"]]];
             
             
             Detailcell.RoomStyleLabel.text =dic[@"leixing"];   //@"%@室%@厅%阳台";
             NSString *mianjiStr = [self judgeNullValue:dic[@"acreage"]];
             Detailcell.aceaLabel.text =(mianjiStr.length)?[NSString stringWithFormat:@"%@㎡",dic[@"acreage"]]: @"不限";  //如果返回面积为空，则显示面积不限
             Detailcell.DecorationLabel.text = dic[@"zhuangxiuyaoqiu"];  //@"简装修";
             Detailcell.Expritime.text = [NSString stringWithFormat:@"%@个月",dic[@"youxiaoqi"]];   //@"三个月";
             //配套设施
             
             Detailcell.attachMent.text = [self getAttacMentFromDataDic];
             
             return Detailcell;
         }else
         {
             Describecell =  [[[NSBundle mainBundle]loadNibNamed:@"ZuGouDescribeCell" owner:nil options:nil] firstObject];
             Describecell.contentCell.numberOfLines = 0;
             Describecell.contentCell.text = dic[@"fangyuanmiaoshu"];
             return Describecell;
         }

    } //end_写字楼

}


-(NSString *)judgeAttachment:(NSString *)Keystring andIsTrue:(BOOL)isTrue {
    if ([Keystring isEqualToString:@"tingchechang"] && isTrue ==YES) {
        return @"停车场";
    } else if ([Keystring isEqualToString:@"jiadian"] && isTrue ==YES){
        return @"家电";
    }else if ([Keystring isEqualToString:@"dianshi"] && isTrue ==YES){
        return @"电视";
    }else if ([Keystring isEqualToString:@"meiqi"] && isTrue ==YES ){
        return @"煤气";
    }else{
        return @"电话";
    }
}

-(NSString *)judgeNullValue:(NSString *)string{
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    else  return string;
}

#pragma mark -表高度返回设置
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 100;
    }
    else if (indexPath.row ==1) {
        if ([self.FangData[@"fenlei"] isEqualToNumber:[NSNumber numberWithInt:1]]||[self.FangData[@"fenlei"] isEqualToNumber:[NSNumber numberWithInt:2]]) {
            return 150;
        } else {
           return  200;
        }
    }
    else  {
        return 100;
    }
}



- (void)initNavController {
    UIButton  *h = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];  //收藏按钮
    UIButton  *ShareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];  //分享按钮
    
    [h addTarget:self action:@selector(StarAction) forControlEvents:UIControlEventTouchUpInside];
    [ShareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img = [UIImage imageNamed:@"pStar"];
    UIImage *ShareIcon = [UIImage imageNamed:@"shareIcon"];
    [h        setImage:img forState:UIControlStateNormal];
    [ShareBtn setImage:ShareIcon forState:UIControlStateNormal];
    UIBarButtonItem *star = [[UIBarButtonItem alloc]initWithCustomView:h];
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithCustomView:ShareBtn];
    UIBarButtonItem *flexSible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexSible.width = 10.f ;

    NSArray *arr = [NSArray arrayWithObjects:share,flexSible,star,nil];
    UIToolbar *rightTool =  [[UIToolbar alloc]init];
    rightTool.barTintColor = [UIColor blueColor];
    rightTool.clipsToBounds = YES ;
    rightTool.opaque = NO ;
    [rightTool setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [rightTool setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
    rightTool.tintColor = [UIColor whiteColor];
    CGFloat tool;
    if (isI6p) {
        tool=78;
    }else{
        tool=68;
    }
    
    [rightTool setFrame:CGRectMake(0, 0, tool, 42.f)];  //78
    [rightTool setItems:arr];
    
    self.navigationItem.rightBarButtonItems = arr;
    DSNavigationBar *TrunscleNavBar = [[DSNavigationBar alloc]init];
    [TrunscleNavBar setNavigationBarWithColor:DeafaultColor2];
    [self.navigationController setValue:TrunscleNavBar forKey:@"navigationBar"];
}


-(void)StarAction {
    //    URL  /user/saveCollectRow.api  //http://www.123qf.cn/app/user/saveCollectRow.api
    //    参数
    //    fid
    //    kid
    NSString *Request = [NSString stringWithFormat:@"http://www.123qf.cn/app/user/saveCollectRow.api?kid=%@",self.FangData[@"id"]];
    if ([[self.FangData allKeys] containsObject:@"zugou"]) { //客源
       Request = [NSString stringWithFormat:@"http://www.123qf.cn/app/user/saveCollectRow.api?kid=%@",self.FangData[@"id"]];
    } else {
       Request = [NSString stringWithFormat:@"http://www.123qf.cn/app/user/saveCollectRow.api?fid=%@",self.FangData[@"id"]];
    }
    
    [self.sharedMgr POST:Request parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([HttpTool isRequestSuccessWith:responseObject andKeyStr:@"zugou"]) {
            [MBProgressHUD showSuccess:@"已收藏,在我的收藏中可见"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


-(void)initTable {
    self.detailInfoTable = [[UITableView alloc]init];
    self.detailInfoTable.tag = DETAILTABLE;
    self.detailInfoTable.delegate = self ;
    self.detailInfoTable.dataSource = self;
    self.detailInfoTable.allowsSelection = NO ;
    [self.detailInfoTable setFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
    self.detailInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self.view addSubview:self.detailInfoTable];
}

-(void)getDataFromNet {
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    self.sharedMgr = mgr ;
 //   NSString *url3 = [NSString stringWithFormat:@"http://www.123qf.cn:81/testApp/keyuan/seekHouse.api?fenlei=%@&keyuan_id=%@",self.fenlei,self.keYuanID];
       NSString *url3 = [NSString stringWithFormat:@"http://www.123qf.cn/app/keyuan/seekHouse.api?fenlei=%@&keyuan_id=%@",self.fenlei,self.keYuanID];
    [MBProgressHUD showMessage:@"加载中"];
    [mgr POST:url3
   parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
#pragma mark -请求成功后的网络处理
       NSLog(@"ZuGou:%@",responseObject);
       
       

       [MBProgressHUD hideHUD];
       UIView *back = [self.view viewWithTag:999];
       [back removeFromSuperview];  //移除白色背景
       self.FangData = responseObject[@"data"];
       [self initFootView];
       if (self.isInner == YES) {  //如果是来自内部XX
           [self checkKeyuanInfo];
           [self setUpCheckBtn];
       }
       [self.detailInfoTable reloadData];
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",error);
       [MBProgressHUD hideHUD];
       [MBProgressHUD showError:@"网络超时，稍后尝试"];
   }];
    ;
}

#pragma 初始化底部工具条
-(void)initFootView {
  UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight-ToolHeight, ScreenWidth, ToolHeight)];
    footer.backgroundColor = [UIColor redColor];
    [self.view addSubview:footer];
    //左边
    UIView *PublisherAndCo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/4, ToolHeight)];
    PublisherAndCo.backgroundColor = DeafaultColor;
    UILabel *Company  = [[UILabel alloc]init];
    self.Publisher = Company ;
    
    Company.textColor = [UIColor whiteColor];
    NSString *Coname = self.FangData[@"publisher"];
    NSLog(@"%@",Coname);
    if ([Coname length]>4) {
        NSRange  range = NSMakeRange(0, 2);
        Coname = [NSString stringWithFormat:@"%@",[Coname substringWithRange:range]];
    }
    Company.text = Coname ;
    UIFont *Deafult = [UIFont systemFontOfSize:17];
    CGSize MaxLeftSzie = CGSizeMake(LeftViewWidth-Padding,ToolHeight-Padding);
    if (Coname == nil) {
        NSLog(@"DEBUG");
    } else {
    }
    CGSize companyLabelSize = [self sizeWithString:Company.text font:Deafult maxSize:MaxLeftSzie];
    
    UILabel *ContactName  = [[UILabel alloc]init];
    NSString *ComNameStr = self.FangData[@"name"];
    self.Name = ContactName;
    ContactName.textColor = [UIColor whiteColor];
    NSLog(@"%@",self.FangData[@"name"]);
    if ([(self.FangData[@"name"]) isKindOfClass:[NSNull class]]) {
        ContactName.text = @"";
    }else {
        if ([ComNameStr length]>4) {
            NSRange  range;
            if (isI5) {
                range = NSMakeRange(0, 3);
            } else if(isI6) {
                range = NSMakeRange(0, 4);
            } else if (isI6p) {
                range = NSMakeRange(0, 5);
            } else if (isI4){
                range = NSMakeRange(0, 3);
            }
            //            NSRange  range = NSMakeRange(3, 4);
            ComNameStr = [NSString stringWithFormat:@"%@..",[ComNameStr substringWithRange:range]];
        }
        
        ContactName.text = ComNameStr;
        //    ContactName.text = @"暴走";
        
    }
    
    CGSize NameLabelSize = [self sizeWithString:ContactName.text font:Deafult maxSize:MaxLeftSzie];
    [ContactName setFrame:CGRectMake((LeftViewWidth -NameLabelSize.width)/2, (Company.frame.origin.y +Company.frame.size.height +2), NameLabelSize.width, NameLabelSize.height)];
    [Company setFrame:CGRectMake((LeftViewWidth -companyLabelSize.width)/2 , (ToolHeight - (companyLabelSize.height + NameLabelSize.height))/2+20, companyLabelSize.width, companyLabelSize.height)];
    [PublisherAndCo addSubview:Company];
    [PublisherAndCo addSubview:ContactName];
    [footer addSubview:PublisherAndCo];
    
    PublisherAndCo.userInteractionEnabled = YES;
    

    [footer addSubview:PublisherAndCo];
    
    
    //中部
    UITapGestureRecognizer *TeleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TeleTap:)];
    UIView *TeleView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/4 +1 , 0, ScreenWidth/2, ToolHeight)];
    UIImageView  *TeleIcon = [[UIImageView alloc]init];
    UILabel *teleLabel = [[UILabel alloc]init];
    self.Tele = teleLabel;
    teleLabel.textColor = [UIColor whiteColor];
    CGSize MaxCenter = CGSizeMake(MiddleViewWidth - Padding,ToolHeight - Padding);
    TeleIcon.image  = [UIImage imageNamed:@"tel"];
    [TeleIcon setFrame:CGRectMake(5, 5, 30, 30)];
    teleLabel.text = self.FangData[@"tel"]; //
    CGSize TeleLabelSize = [self sizeWithString:teleLabel.text font:Deafult maxSize:MaxCenter];
    [TeleIcon setFrame:CGRectMake((MiddleViewWidth -30 -Padding -TeleLabelSize.width)/2 , (ToolHeight - 30)/2,30, 30)];
    [teleLabel setFrame:CGRectMake(TeleIcon.frame.origin.x + Padding - 5 + 30, (ToolHeight - TeleLabelSize.height)/2,TeleLabelSize.width, TeleLabelSize.height)];
    [TeleView addSubview:TeleIcon];
    [TeleView addSubview:teleLabel];
    TeleView.backgroundColor = DeafaultColor3;
    [TeleView addGestureRecognizer:TeleTap];
    [footer addSubview:TeleView];
    
    
    //右部
    
    UITapGestureRecognizer *MsgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MsgTap:)];
    UIView *MsgView =[[UIImageView alloc]initWithFrame:CGRectMake((3*ScreenWidth/4)+2, 0, ScreenWidth/4, ToolHeight)];
    MsgView.userInteractionEnabled = YES;
    MsgView.backgroundColor = DeafaultColor3;
    UIImageView *MsgIcon =[[UIImageView alloc]init];
    MsgIcon.image  = [UIImage imageNamed:@"mail"];
    [MsgIcon setFrame:CGRectMake((LeftViewWidth - 40)/2, (ToolHeight-20)/2, 40, 20)];
    [MsgView addSubview:MsgIcon];
    [footer addSubview:MsgView];
    [MsgView addGestureRecognizer:MsgTap];
    
    
    
    footer.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:footer];
}

#pragma mark -label高度计算
#warning 缺少非空处理,可能引起报错
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

#pragma mark -短信代理
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent: {
            UIAlertView *AW = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"短信已发送"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
            
            [AW show];
        }
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}


#pragma mark -短信执行方法
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}



#pragma mark -发送短信
-(void)MsgTap:(id)sender {
    NSString *tele = @"13622289081";//self.FangData[@"tel"];//self.FangData[@"tel"];//;
    NSArray *ReciverArr = [NSArray arrayWithObjects:tele, nil];
    NSString *content = [NSString stringWithFormat:@"你好,我对\"%@\"这套房产感兴趣，希望做进一步交流^_^ ",_FangData[@"biaoti"]];
    [self showMessageView:ReciverArr title:nil body:content];
}

#pragma mark -拨打电话
-(void)TeleTap:(id)sender {
    NSString *tele =self.FangData[@"tel"];//;
    UIAlertView *AW = [[UIAlertView alloc]initWithTitle:nil
                                                message:tele
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"呼叫", nil];
    AW.tag = 0;
    [AW show];
}


//打电话代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *tele =[NSString stringWithFormat:@"tel://%@", self.FangData[@"tel"]];//;
    if(buttonIndex == 1 && alertView.tag==0 ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tele]];
    } else {
        
        return ;
    }
}

-(NSString *)getAttacMentFromDataDic {
    NSString *str = @"";
    
    if (![self.FangData[@"meiqi"] isKindOfClass:[NSNull class]]&&[self.FangData[@"meiqi"] isEqualToNumber:@(YES)]) {
        str = [str stringByAppendingString:@" 煤气"];
    }
    
    if (![self.FangData[@"kuandai"] isKindOfClass:[NSNull class]]&&[self.FangData[@"kuandai"] isEqualToNumber:@(YES)]) {
        str = [str stringByAppendingString:@" 宽带"];
    }
    
    if (![self.FangData[@"dianti"] isKindOfClass:[NSNull class]]&&[self.FangData[@"dianti"] isEqualToNumber:@(YES)]) {
        str = [str stringByAppendingString:@" 电梯"];
    }
    
    if (![self.FangData[@"tingchechang"] isKindOfClass:[NSNull class]]&&[self.FangData[@"tingchechang"] isEqualToNumber:@(YES)]) {
        str = [str stringByAppendingString:@" 停车场"];
    }
    
    if (![self.FangData[@"dianshi"] isKindOfClass:[NSNull class]]&&[self.FangData[@"dianshi"] isEqualToNumber:@(YES)]) {
        str = [str stringByAppendingString:@" 电视"];
    }
    
    if (![self.FangData[@"jiadian"] isKindOfClass:[NSNull class]]&&[self.FangData[@"jiadian"] isEqualToNumber:@(YES)]) {
        str = [str stringByAppendingString:@" 家电"];
    }
    
    if (![self.FangData[@"dianhua"] isKindOfClass:[NSNull class]]&&[self.FangData[@"dianhua"] isEqualToNumber:@(YES)]) {
        str = [str stringByAppendingString:@" 电话"];
    }
    
    if (![self.FangData[@"lingbaoruzhu"] isKindOfClass:[NSNull class]]&&[self.FangData[@"lingbaoruzhu"] isEqualToNumber:@(YES)]) {
        str = [str stringByAppendingString:@" 拎包即住"];
    }
    return str;
}



-(void)share {
    NSLog(@"分享啊");
    
    UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    modalView.userInteractionEnabled = NO;
    modalView.tag =ModalViewTag;
    modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
    [self.navigationController.view addSubview:modalView];  //这种状况下，向右滑动会触发菜单显示
    NSArray *shareAry = @[@{@"image":@"shareView_wx",
                            @"title":@"微信"},
                          @{@"image":@"shareView_friend",
                            @"title":@"朋友圈"},
                          @{@"image":@"shareView_qq",
                            @"title":@"QQ"},
                          @{@"image":@"shareView_wb",
                            @"title":@"新浪微博"},
                          @{@"image":@"shareView_qzone",
                            @"title":@"QQ空间"},
                          @{@"image":@"shareView_msg",
                            @"title":@"短信"},
                          @{@"image":@"share_copyLink",
                            @"title":@"复制链接"}];
    
    SharePopVC *view = [[SharePopVC alloc]init];
    view.QFImgSAndTittleSDicArr  = shareAry ;
    view.providesPresentationContextTransitionStyle = YES;
    view.definesPresentationContext = YES;
    view.delegate = self;
    view.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    view.DismissView = ^ {
        [modalView removeFromSuperview];
    };
    [self presentViewController:view animated:YES completion:^{
    }];
    
}



-(void)QFsharedWith:(NSInteger)index {
    
    NSString *firstStr ;
    NSString *secondStr ;
    
    NSString *Basic = @"http://www.123qf.cn/front/fkyuan/";
    
    NSNumber *ZeroFlag = [NSNumber numberWithInt:0];
    NSNumber *OneFlag  = [NSNumber numberWithInt:1];
    NSNumber *TwoFlag  = [NSNumber numberWithInt:2];
    
    
    NSLog(@"要分享的数据:%@",self.FangData);
    
    if ([self.FangData[@"zushou"] isEqualToNumber:ZeroFlag]) {
        firstStr = @"cs";
    } else if ([self.FangData[@"zushou"] isEqualToNumber:OneFlag]) {
        firstStr = @"cz";
    } else if ([self.FangData[@"zugou"] isEqualToNumber:OneFlag]) //求购
    {
        firstStr = @"qg";
    } else if ([self.FangData[@"zugou"] isEqualToNumber:ZeroFlag]) {  //求助
        firstStr = @"qz";
    }
    
    
    if ([self.FangData[@"fenlei"] isEqualToNumber:ZeroFlag]) {
        secondStr = @"zz";
    } else if ([self.FangData[@"fenlei"] isEqualToNumber:OneFlag]) {
        secondStr = @"sp";
    }else if ([self.FangData[@"fenlei"] isEqualToNumber:TwoFlag]) {
        secondStr = @"xzl";
    }else {
        secondStr = @"cf";
    }
    
    
    
    AppDelegate *app =  [UIApplication sharedApplication].delegate;
    NSLog(@"%@",app.usrInfoDic);
    OSMessage *msg=[[OSMessage alloc]init];
    msg.title=self.FangData[@"biaoti"];
    // NSString *urlLink = [NSString stringWithFormat:@"http://www.123qf.cn/front/fkyuan/wap_cz_zz.jsp?zhuangtai=1&fid=%@&fenlei=0&userID=%@",self.FangData[@"id"],app.usrInfoDic[@"userid"]];
    
    NSString *urlLink =[NSString stringWithFormat:@"http://www.123qf.cn/front/fkyuan/wap_%@_%@.jsp?zhuangtai=0&fid=%@&fenlei=0&userID=%@",firstStr,secondStr,self.FangData[@"id"],app.usrInfoDic[@"userid"]];
    
    if ([[self.FangData allKeys]containsObject:@"zugou"]) {
       urlLink =[NSString stringWithFormat:@"http://www.123qf.cn/front/fkyuan/wap_%@_%@.jsp?zhuangtai=1&fid=%@&fenlei=0&userID=%@",firstStr,secondStr,self.FangData[@"id"],app.usrInfoDic[@"userid"]];
    } else if([[self.FangData allKeys]containsObject:@"zushou"]) {
       urlLink =[NSString stringWithFormat:@"http://www.123qf.cn/front/fkyuan/wap_%@_%@.jsp?zhuangtai=0&fid=%@&fenlei=0&userID=%@",firstStr,secondStr,self.FangData[@"id"],app.usrInfoDic[@"userid"]];
    }
    
    NSLog(@"urlLink：%@",urlLink);
    msg.link=urlLink;
    
    
    
    UIImageView *imageView = [UIImageView new];
    NSLog(@"%@",self.imagesData);
    if ([self.imagesData count]>1) {  //[self.imagesData count]>0
        [imageView sd_setImageWithURL:self.imagesData[0] placeholderImage:nil];
    } else {
        imageView.image = [UIImage imageNamed:@"DeafaultImage"];
    }
    
    msg.image = imageView.image;
    
    // NSString *recodUrl = @"http://www.123qf.cn/app/share/saveShareUser.api";
    
 //   NSString *RecodrUrl = [NSString stringWithFormat:@"http://www.123qf.cn/app/share/saveShareUser.api?fid=%@",self.FangData[@"id"]];
    NSString *RecodrUrl;
    

    
    if ([[self.FangData allKeys]containsObject:@"zugou"]) {
        RecodrUrl = [NSString stringWithFormat:@"http://www.123qf.cn/app/share/saveShareUser.api?fid=%@",self.FangData[@"id"]];
    } else if([[self.FangData allKeys]containsObject:@"zushou"]) {
        RecodrUrl = [NSString stringWithFormat:@"http://www.123qf.cn/app/share/saveShareUser.api?kid=%@",self.FangData[@"id"]];
    }
    
    //先保存分享的信息
    [self.sharedMgr POST:RecodrUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        switch (index) {
                //微信好友分享
            case 0:
                NSLog(@"序号为0的触发");
                [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                    NSLog(@"微信分享到会话成功：\n%@",message);
                } Fail:^(OSMessage *message, NSError *error) {
                    NSLog(@"微信分享到会话失败：\n%@\n%@",error,message);
                }];
                
                
                break;
            case 1:
                NSLog(@"序号为1的触发");
                [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                    NSLog(@"微信分享到会话成功：\n%@",message);
                } Fail:^(OSMessage *message, NSError *error) {
                    NSLog(@"微信分享到会话失败：\n%@\n%@",error,message);
                }];
                break;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}






@end
