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

#import "LesveMsgVC.h"


#define  HeavyFont     [UIFont fontWithName:@"Helvetica-Bold" size:25]
#define  ToolHeight  50    //固定底部的大小
#define LeftViewWidth   ScreenWidth/4
#define MiddleViewWidth   ScreenWidth/2
#define RightViewWidth   ScreenWidth/4
#define Padding  8
#define IMGGALLAERY 10
#define DETAILTABLE   11
#define ImgScoviewTag 12


#define DSystenVersion            ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion            ([[UIDevice currentDevice] systemVersion])


@interface ZuGouDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic)  UIScrollView *scrollView3;
@property (strong, nonatomic)  UITableView *detailInfoTable;
@property (strong, nonatomic)  NSMutableArray *imagesData;
@property(nonatomic)           CGFloat CellHeight;
@property(nonatomic)           CGFloat DescribeCellHeight;
@property(nonatomic)           CGFloat FreeCellHeight;
@property(nonatomic)           NSInteger ImgTotal;
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
 //   [self addWhiteBack];   //为加载前的白色背景
 //   [self navigationController];   //变更一下导航栏
    [self initTable];
    [self initFootView];
    [self initNavController];
    [self getDataFromNet];
    if (self.isInner == YES) {
        [self setUpCheckBtn];
    }
    [self setUpCheckBtn];
    
    
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
 *  查看业主信息
 */

-(void)CheckBtn {
    //http://www.123qf.cn:81/testApp/fkyuan/selectOwnerInfo.api?kid=5&currentpage=1
    
//    self.sharedMgr po
    NSString *URL =@"http://www.123qf.cn:81/testApp/fkyuan/selectOwnerInfo.api";
    NSMutableDictionary *pramaDic = [NSMutableDictionary new];
    pramaDic[@"kid"] = self.FangData[@"id"];
    pramaDic[@"currentpage"] = @"1";
        NSLog(@"发钱:%@",pramaDic);
    [self.sharedMgr POST:URL parameters:pramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"SeeOwnList :%@",responseObject);
        NSString *flagStr = responseObject[@"msg"];
        NSString *data = responseObject[@"data"];
        if ([flagStr isEqualToString:@"无数据"] ) {
            UIAlertView *AW = [[UIAlertView alloc]initWithTitle:@"未含信息"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
            
            [AW show];
        } else{
            self.CheckBtnInfoDic = responseObject[@"data"];
            
            LesveMsgVC *LMsg = [[LesveMsgVC alloc]init];
            NSDictionary *dict = responseObject[@"data"];
            LMsg.OwnerInfoDic= dict[@"OwnerInfo"];
            
            [self.navigationController pushViewController:LMsg animated:YES];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
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

/**
 *  查看业主信息
 */



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

//{"code":1,"msg":"对应fy_id存在详情","data":{"region":"河南岸","tingchechang":true,"biaoti":"1500-2000元2房 2厅","tingshu":2,"kuandai":null,"tel":"13516666006","shengfen":"广东省","userid":"13480556006","pricef":1500,"acreage":null,"jiadian":true,"publisher":"曾剑军","fangshu":2,"id":5,"dianshi":null,"name":"悦和地产","mingcheng":null,"qu":"惠城区","shi":"惠州市","tupian":null,"zhuangxiuyaoqiu":"精装修","weituodate":"2015-11-02 10:31:45","meiqi":null,"leixing":null,"zugou":false,"dianhua":null,"fangyuanmiaoshu":"以沃尔玛附近为佳","pricel":2000,"unit":"元","balconys":1,"fenlei":0,"youxiaoqi":1,"toilets":1,"dianti":null}}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.FangData;
        ZuGouHeadCell *Headcell = [[ZuGouHeadCell alloc]init];
        ZuGouDescribeCell *Describecell = [[ZuGouDescribeCell alloc]init];
        ZuGouDetailCell *Detailcell = [[ZuGouDetailCell alloc]init];
    if (indexPath.row ==0) {
        Headcell  =  [[[NSBundle mainBundle]loadNibNamed:@"ZuGouHeadCell" owner:nil options:nil] firstObject];
        Headcell.QFtitle.text  = dic[@"biaoti"];
        NSString *price =[NSString stringWithFormat:@"%@-%@%@",dic[@"pricef"],dic[@"pricel"],dic[@"unit"]];
              //添加高亮属性
                NSMutableAttributedString *HiligntNo = [[NSMutableAttributedString alloc]initWithString:price];
                NSRange NoRange = NSMakeRange(0, [price length]-1);
                [HiligntNo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NoRange];
                [HiligntNo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ]  range:NoRange];
        
        Headcell.QFprice.text = price;
        [Headcell.QFprice setAttributedText:HiligntNo];
        Headcell.QFweiTuoDate.text = dic[@"weituodate"];
        return Headcell;
    }else if (indexPath.row ==1){
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
        Detailcell.aceaLabel.text =(mianjiStr.length)?dic[@"acreage"]: @"不限";  //如果返回面积为空，则显示面积不限
        Detailcell.DecorationLabel.text = dic[@"zhuangxiuyaoqiu"];  //@"简装修";
        Detailcell.Expritime.text = [NSString stringWithFormat:@"%@个月",dic[@"youxiaoqi"]];   //@"三个月";
        //配套设施
        Detailcell.attachMent.text =[NSString stringWithFormat:@"%@ %@ %@ %@ %@", [self judgeAttachment:@"tingchechang" andIsTrue:dic[@"tingchechang"]],
                                     [self judgeAttachment:@"jiadian" andIsTrue:dic[@"jiadian"]],
                                     [self judgeAttachment:@"dianshi" andIsTrue:dic[@"dianshi"]],
                                     [self judgeAttachment:@"meiqi" andIsTrue:dic[@"meiqi"]],
                                     [self judgeAttachment:@"dianhua" andIsTrue:dic[@"dianhua"]]];

        
        
        
        //@"%@室%@厅%阳台";
        return Detailcell;
    }else{
        Describecell =  [[[NSBundle mainBundle]loadNibNamed:@"ZuGouDescribeCell" owner:nil options:nil] firstObject];
        Describecell.contentCell.numberOfLines = 0;
        Describecell.contentCell.text = dic[@"fangyuanmiaoshu"];
        return Describecell;
    }
    
//    UITableViewCell *cell  = [[UITableViewCell alloc]init];
//    cell.textLabel.text = @"哈哈哈";
//    return cell;
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
        return  200;
    }
    else  {
        return 100;
    }
}

- (void)initNavController {
    UIButton  *h = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    UIImage *img = [UIImage imageNamed:@"pStar"];
    [h setImage:img forState:UIControlStateNormal];
    UIBarButtonItem *star = [[UIBarButtonItem alloc]initWithCustomView:h];
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    UIBarButtonItem *flexSible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexSible.width = 4.f ;
    NSArray *arr = [NSArray arrayWithObjects:star,flexSible,share,nil];
    UIToolbar *rightTool =  [[UIToolbar alloc]init];
    rightTool.barTintColor = [UIColor blueColor];
    rightTool.clipsToBounds = YES ;
    rightTool.opaque = NO ;
    [rightTool setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [rightTool setShadowImage:[UIImage new]
           forToolbarPosition:UIToolbarPositionAny];
    rightTool.tintColor = [UIColor whiteColor];
    CGFloat tool;
    if (isI6p) {
        tool=78;
    }else{
        tool=68;
    }
    
    [rightTool setFrame:CGRectMake(0, 0, tool, 42.f)];  //78
    [rightTool setItems:arr];
    UIBarButtonItem *Right = [[UIBarButtonItem alloc]initWithCustomView:rightTool];
    self.navigationItem.rightBarButtonItem = Right ;
    DSNavigationBar *TrunscleNavBar = [[DSNavigationBar alloc]init];
    [TrunscleNavBar setNavigationBarWithColor:DeafaultColor2];
    [self.navigationController setValue:TrunscleNavBar forKey:@"navigationBar"];
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
//    http://www.123qf.cn:81/testApp/keyuan/seekHouse.api?fenlei=0&keyuan_id=5
    NSString *url3 = [NSString stringWithFormat:@"http://www.123qf.cn:81/testApp/keyuan/seekHouse.api?fenlei=%@&keyuan_id=%@",self.fenlei   ,self.keYuanID];
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
       [self.detailInfoTable reloadData];

       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",error);
   }];
    ;
}

#pragma 初始化底部工具条
-(void)initFootView {
  UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight-ToolHeight, ScreenWidth, ToolHeight)];
 // UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight/2, ScreenWidth, ToolHeight)];
    
 //    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ToolHeight)];
    footer.backgroundColor = [UIColor redColor];
    [self.view addSubview:footer];
    //左边
    UIView *PublisherAndCo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/4, ToolHeight)];
    PublisherAndCo.backgroundColor = DeafaultColor;
    UILabel *Company  = [[UILabel alloc]init];
    self.Publisher = Company ;
    
    Company.textColor = [UIColor whiteColor];
    NSString *Coname = @"益和地产";//self.FangData[@"name"];
    NSLog(@"%@",Coname);
    if ([Coname length]>4) {
        NSRange  range = NSMakeRange(0, 3);
        Coname = [NSString stringWithFormat:@"%@..",[Coname substringWithRange:range]];
    }
    Company.text = Coname ;  //@"丰登地产";
    //  Company.text = @"地产";
    UIFont *Deafult = [UIFont systemFontOfSize:17];
    CGSize MaxLeftSzie = CGSizeMake(LeftViewWidth-Padding,ToolHeight-Padding);
    if (Coname == nil) {
        NSLog(@"DEBUG");
    } else {
    }
    CGSize companyLabelSize = [self sizeWithString:Company.text font:Deafult maxSize:MaxLeftSzie];
    
    UILabel *ContactName  = [[UILabel alloc]init];
    self.Name = ContactName;
    ContactName.textColor = [UIColor whiteColor];
    NSLog(@"%@",self.FangData[@"publisher"]);
    if ([(self.FangData[@"publisher"]) isKindOfClass:[NSNull class]]) {
        ContactName.text = @"";
    }else {
        ContactName.text = @"张泽";//self.FangData[@"publisher"];
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
    teleLabel.text = @"18720984176"; //self.FangData[@"tel"]; //
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
@end
