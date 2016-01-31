//
//  DetailViewController.m
//  清房助手
//
//  Created by Larry on 15/10/12.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "DescribeCell.h"
#import "FactoryDetailCell.h"
#import "FactoryLoactionCell.h"
#import "FlatDetailCell.h"
#import "FlatLocationCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+UILabel_SizeWithTest.h"
#import "FreeCell.h"
#import <MessageUI/MessageUI.h>
#import "MJRefresh.h"
#import "LesveMsgVC.h"


#import "AppDelegate.h"

#import "SharePopVC.h"



#import "PopSelectViewController.h"

#import "AppDelegate.h"
#import "OpenShareHeader.h"

#define  HeavyFont     [UIFont fontWithName:@"Helvetica-Bold" size:25]
#define  ToolHeight  50    //固定底部的大小
#define LeftViewWidth   ScreenWidth/4
#define MiddleViewWidth   ScreenWidth/2
#define RightViewWidth   ScreenWidth/4
#define Padding  8
#define IMGGALLAERY 10
#define DETAILTABLE   11
#define ImgScoviewTag 12

#define  checkNoBtnHeight  30
#define  checkNoBtnWidght  100

#define DSystenVersion            ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion            ([[UIDevice currentDevice] systemVersion])

#define ModalViewTag   99


@interface DetailViewController ()
<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,SharePopdelegate>
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
@property(nonatomic,strong)  AFHTTPRequestOperationManager  *sharedMgr;
@property(nonatomic,strong)  NSDictionary  *CheckBtnInfoDic;



@end

@implementation DetailViewController


-(NSDictionary *)FangData {
    if (_FangData == nil) {
        _FangData = [NSDictionary dictionary];
    }
    return _FangData;
}

-(void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES ;
}

-(NSDictionary*)CheckBtnInfoDic {
    if (_CheckBtnInfoDic ==nil) {
        _CheckBtnInfoDic = [NSDictionary new];
    }
    return _CheckBtnInfoDic;
}


- (void)viewDidLoad {
//       NSLog(@"官方:%s",__FUNCTION__);
   // NSLog(@"官方");
    [super viewDidLoad];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSLog(@"权限列表:%@",appDelegate.QFUserPermissionDic_NSMArr);
    
    
    [self initNavController];
    [self initTable];
    [self addWhiteBack];  //背景加载
    [self getDataFromNet];
    [self initHeadScorlImage];

    
}
#pragma mark -初始化导航栏(收藏和分享)
- (void)initNavController {
    UIButton  *h = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];  //收藏按钮
    UIImage *img = [UIImage imageNamed:@"pStar"];
    [h setImage:img forState:UIControlStateNormal];
    UIBarButtonItem *star = [[UIBarButtonItem alloc]initWithCustomView:h];
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    
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



-(void)share {
    NSLog(@"分享啊");
    
    UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    modalView.userInteractionEnabled = NO;
    modalView.tag =ModalViewTag;
    modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
   [self.navigationController.view addSubview:modalView];  //这种状况下，向右滑动会触发菜单显示
  //  [self.view addSubview:modalView];
    
    
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
#pragma mark -初始化表
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
     mgr.requestSerializer.timeoutInterval  = 5.0;
    self.sharedMgr = mgr;
  //  NSString *url3 = [NSString stringWithFormat:@"http://www.123qf.cn:81/testApp/fangyuan/detailsHouse.api?fenlei=%@&fangyuan_id=%@",self.FenLei,self.DisplayId];
    
       NSString *url3 = [NSString stringWithFormat:@"http://www.123qf.cn/app/fangyuan/detailsHouse.api?fenlei=%@&fangyuan_id=%@",self.FenLei,self.DisplayId];
    [MBProgressHUD showMessage:@"加载中"];
    [mgr POST:url3
   parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
#pragma mark -请求成功后的网络处理
       NSLog(@"%@",responseObject);
       [MBProgressHUD hideHUD];
       UIView *back = [self.view viewWithTag:999];
       [back removeFromSuperview];
       self.FangData = responseObject[@"data"];
       NSLog(@"单个数据详情%@",self.FangData);
       NSString *collect = self.FangData[@"tupian"];
       NSArray *imgArray = [collect componentsSeparatedByString:@","];
       self.ImgTotal = [imgArray count];
       for (NSString *imgName in imgArray) {//http://www.123qf.cn/img/    http://www.123qf.cn/testWeb/img/
           NSString *ImgfullUrl = [NSString stringWithFormat:@"http://www.123qf.cn/img/%@/userfile/qfzs/fy/mini/%@",self.uerID,imgName];
           NSLog(@"详情页的图片地址%@",ImgfullUrl);
           [self.imagesData addObject:ImgfullUrl];
       }   //所有图片地址
       
       CGSize size = CGSizeMake(ScreenWidth, 1000);
       NSString *context = self.FangData[@"fangyuanmiaoshu"];
       NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
       CGSize labelSize = [context boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
       self.CellHeight = labelSize.height ;
       [self.detailInfoTable reloadData];
       [self viewDidLayoutSubviews];     //设置滚动视图的横向大小
       [self CountReset];
       [self initFootView];
       [self setupScrollViewImages];   //设置滚动视图内图片
       
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

    //左边
    UIView *PublisherAndCo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/4, ToolHeight)];
    PublisherAndCo.backgroundColor = DeafaultColor;
    UILabel *Company  = [[UILabel alloc]init];
    self.Publisher = Company ;
 
    Company.textColor = [UIColor whiteColor];
    NSString *Coname = self.FangData[@"name"];
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
        ContactName.text = self.FangData[@"publisher"];
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
    teleLabel.text = self.FangData[@"tel"]; //@"18720984176";
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

#pragma mark -发送短信
-(void)MsgTap:(id)sender {
    NSString *tele = self.FangData[@"tel"];//self.FangData[@"tel"];//;
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *tele =[NSString stringWithFormat:@"tel://%@", self.FangData[@"tel"]];//;
    if(buttonIndex == 1 && alertView.tag==0 ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tele]];
    } else {

        return ;
    }



}


-(void)initHeadScorlImage {
    UIView *HeaderContent = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight/3 + 50)];
    self.HeaderContent = HeaderContent;
    self.scrollView3  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight/3 +50)];
    [HeaderContent addSubview:self.scrollView3];
    
    self.scrollView3.pagingEnabled = YES ;
    self.scrollView3.delegate = self ;
    self.scrollView3.tag = ImgScoviewTag;
    self.scrollView3.showsHorizontalScrollIndicator  =  NO ;
    self.imagesData = [NSMutableArray array];
    self.detailInfoTable.tableHeaderView = HeaderContent;
    [self initCountLabel];  //计数标签
}

#pragma mark -layoutMethod
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView3.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView3.frame) * self.imagesData.count, CGRectGetHeight(self.scrollView3.frame));
}


#pragma mark -ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag ==ImgScoviewTag) {
        NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        NSLog(@"当前页:%d",pageIndex);
        NSString  *nowSelected =[NSString stringWithFormat:@"%ld/%ld",pageIndex + 1,(long)self.ImgTotal];
        [self.CountLabel setTitle:nowSelected forState:UIControlStateNormal];
        self.CountLabel.titleLabel.text = nowSelected ;
        NSMutableAttributedString *HeavyNo = [[NSMutableAttributedString alloc]initWithString:nowSelected];
        NSRange rangeHeavyPart =  NSMakeRange(0, 2);
        [HeavyNo addAttribute:NSFontAttributeName value:HeavyFont range:rangeHeavyPart];
        [self.CountLabel.titleLabel setAttributedText:HeavyNo];
    }else {
        return ;
    }
}


#pragma mark - Utils
- (void)setupScrollViewImages
{
    NSLog(@"%@",self.imagesData);
    [self.imagesData enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView3.frame) * idx, 0, CGRectGetWidth(self.scrollView3.frame), CGRectGetHeight(self.scrollView3.frame))];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ScanGallery)];
        [imageView addGestureRecognizer:tapGesture];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:self.imagesData[idx] placeholderImage:[UIImage imageNamed:@"DeafaultImage"]];
        [self.scrollView3 addSubview:imageView];
    }];
    NSLog(@"完成滚动图设置");
}

-(void)ScanGallery {
   // NSLog(@"图片被点击了 %d",selecedImg.tag);
}

#pragma mark -表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(void)CheckBtn {
    //http://www.123qf.cn:81/testApp/fkyuan/selectOwnerInfo.api?kid=5&currentpage=1
    
    //    self.sharedMgr po
 //   NSString *URL =@"http://www.123qf.cn:81/testApp/fkyuan/selectOwnerInfo.api";
       NSString *URL =@"http://www.123qf.cn/app/fkyuan/selectOwnerInfo.api";
    NSMutableDictionary *pramaDic = [NSMutableDictionary new];
    pramaDic[@"fid"] = self.FangData[@"id"];
    pramaDic[@"currentpage"] = @"1";
    NSLog(@"发钱:%@",pramaDic);
    [self.sharedMgr POST:URL parameters:pramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"SeeOwnList :%@",responseObject);
        NSString *flagStr = responseObject[@"msg"];
        if ([flagStr isEqualToString:@"无数据"]) {
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
            LMsg.QFownerInfoDic= dict[@"OwnerInfo"];
            
            [self.navigationController pushViewController:LMsg animated:YES];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)checkOwnerInfo {
  //  NSString *URL =@"http://www.123qf.cn:81/testApp/fkyuan/selectOwnerInfo.api";
      NSString *URL =@"http://www.123qf.cn/app/fkyuan/selectOwnerInfo.api";
    NSMutableDictionary *pramaDic = [NSMutableDictionary new];
    pramaDic[@"fid"] = self.FangData[@"id"];
    pramaDic[@"currentpage"] = @"1";
    NSLog(@"发钱:%@",pramaDic);
    [self.sharedMgr POST:URL parameters:pramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"SeeOwnList :%@",responseObject);
        NSString *flagStr = responseObject[@"msg"];
        if ([flagStr isEqualToString:@"无数据"]) {
            UIAlertView *AW = [[UIAlertView alloc]initWithTitle:@"未含信息"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
            
            [AW show];
        } else{
            self.CheckBtnInfoDic = responseObject[@"data"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)setCheckBtn:(UITableViewCell *)cell {
    UIButton *checkTeleNoBtn = [[UIButton alloc]init];
    [checkTeleNoBtn addTarget:self action:@selector(CheckBtn) forControlEvents:UIControlEventTouchUpInside];
    [checkTeleNoBtn setTitle:@"业主信息  >" forState:UIControlStateNormal];
    checkTeleNoBtn.layer.cornerRadius = 4;
    checkTeleNoBtn.layer.borderWidth  = 1;
    checkTeleNoBtn.layer.borderColor  = [DeafaultColor3 CGColor];
    [checkTeleNoBtn setTitleColor:DeafaultColor3 forState:UIControlStateNormal];
    [checkTeleNoBtn setFrame:CGRectMake(2*ScreenWidth/3 ,35  ,checkNoBtnWidght, checkNoBtnHeight)];

    [cell addSubview:checkTeleNoBtn];
}

#pragma mark -表中单元格设置
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
#pragma mark -住宅类
  //  if ([self.FenLei isEqualToString:@"0"]) {  // start_住宅类
        FlatLocationCell  *LocationCell  = [FlatLocationCell new];
        FlatDetailCell   *DetailCell = [FlatDetailCell new];
    DescribeCell  *DescribieCell = NULL;
    NSLog(@"描述字段:%@",self.FangData[@"fangyuanmiaoshu"]);
    
#warning 描述地方
    NSString *miaoshuStr =  self.FangData[@"fangyuanmiaoshu"];
    NSRange isHaveHTML = [miaoshuStr rangeOfString:@"style"];
    //判断是不是网页
    if(isHaveHTML.length) {
        DescribieCell = [DescribeCell freeCellWithHtmlStr:miaoshuStr];   //+(instancetype)freeCellWithHtmlStr:(NSString *)htmlStr]
        self.DescribeCellHeight = 200;
    }else {
        DescribieCell = [DescribeCell freeCellWithTitle:@"描述" andContext:self.FangData[@"fangyuanmiaoshu"]];
        self.DescribeCellHeight = DescribieCell.CellHight;
        DescribieCell.iSSeparetorLine = NO ;
    }
        FreeCell  *testCell = [FreeCell freeCellWithTitle:@"地址" andContext:self.FangData[@"dizhi"]];
        self.FreeCellHeight  = testCell.CellHight;
        LocationCell  =  [[[NSBundle mainBundle]loadNibNamed:@"FlatLocationCell" owner:nil options:nil] firstObject];
        DetailCell = [[[NSBundle mainBundle]loadNibNamed:@"FlatDetailCell" owner:nil options:nil] firstObject];
        if (indexPath.row ==0) {
            LocationCell.Title.text = [NSString stringWithFormat:@"%@%@",self.PreTitle,self.FangData[@"biaoti"]];
            LocationCell.PostTime.text = self.FangData[@"weituodate"];
            LocationCell.Region.text = self.FangData[@"qu"];
            LocationCell.LouPanName.text = [self judgeNullValue:self.FangData[@"mingcheng"]];
            if(self.isInner)
            [self setCheckBtn:LocationCell]; //如果是内部请求,添加查看按钮
            
            
#pragma mark -价格高亮属性
            NSString *StringPrice = nil;
            NSRange   RedPart ;
            NSNumber *no = [NSNumber numberWithInt:0];
            if([(NSNumber *)self.FangData[@"zushou"] isEqualToNumber:no]) {
                StringPrice = [NSString stringWithFormat:@"%@万(可按揭)",self.FangData[@"shoujia"]];
                RedPart = NSMakeRange(0, [StringPrice length] -6);
            } else{
                StringPrice = [NSString stringWithFormat:@"%@元/月",self.FangData[@"shoujia"]];
                RedPart = NSMakeRange(0, [StringPrice length] -3);

            }
            
            
         //   NSRange   RedPart = NSMakeRange(0, [StringPrice length] -1 );
            NSMutableAttributedString *priceAttri = [[NSMutableAttributedString alloc]initWithString:StringPrice];
            [priceAttri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23 ] range:RedPart];
            [priceAttri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:RedPart];
            LocationCell.Price.text = StringPrice;
            [LocationCell.Price setAttributedText:priceAttri];
            
#pragma mark -添加查看业主信息
            return LocationCell;
        }else if (indexPath.row ==1) {
            return testCell;
        }else if (indexPath.row ==2){
            DetailCell.FlatType.text = [NSString stringWithFormat:@"%@房%@厅",self.FangData[@"fangshu"],self.FangData[@"tingshu"]];
            DetailCell.Decrorelation.text = self.FangData[@"zhuangxiu"];
            DetailCell.FloatNo.text =  [NSString stringWithFormat:@"%@/%@层 ",self.FangData[@"louceng"],self.FangData[@"zonglouceng"]];
            DetailCell.LookTime.text = self.FangData[@"kanfangtime"];
            //带有HTML，考虑加载HTML啊
            DetailCell.WithFacility.text = [self getAttacMentFromDataDic];
            DetailCell.ExtryTime.text =[NSString stringWithFormat:@"%@个月",self.FangData[@"youxiaoqi"]];
            NSString *chaoxingStr = self.FangData[@"chaoxiang"];
            DetailCell.Direction.text = [self judgeNullValue:chaoxingStr];
            DetailCell.Area.text = [NSString stringWithFormat:@"%@㎡",self.FangData[@"mianji"]];
            DetailCell.Type.text = self.FangData[@"leixing"];
            return DetailCell;
        }
        else {
            return DescribieCell;
        }
 //   } //end_住宅类
#pragma mark -商铺类
//     else if([self.FenLei isEqualToString:@"1"]) {  //商铺类
//        FactoryLoactionCell *cell = [[FactoryLoactionCell alloc]init];
//        cell.textLabel.text = @"fuck";
//        return cell;
//    }
//     else if ([self.FenLei isEqualToString:@"2"]) {  //写字楼
//         
//     }
//     else {
//         //工厂
//     }
   
}



#pragma mark -表高度返回设置
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row==0) {
        return 116.0;
    }
   else if (indexPath.row ==1) {
       return  self.FreeCellHeight + 5;
    }
   else if (indexPath.row ==2) {
           return 131;
   }
  else {
      //return self.DescribeCellHeight + 10 ;
      if(isI5){
         return self.DescribeCellHeight + 60 ;
  } else {
         return self.DescribeCellHeight + ToolHeight + 5 ;
  }
}
}


#pragma mark -计数器的初始化
-(void)initCountLabel {
    UIButton *CurrentCountLable  = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-50, ScreenHeight/3 + 5, 40, 40)];
    self.CountLabel = CurrentCountLable ;
    self.CountLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    [CurrentCountLable setTitle:[NSString stringWithFormat:@"1/1"] forState:UIControlStateNormal];
    
    //加粗选中数字
    NSMutableAttributedString *HeavyNo = [[NSMutableAttributedString alloc]initWithString:CurrentCountLable.titleLabel.text];
    NSRange rangeHeavyPart =  NSMakeRange(0, 2);
    [HeavyNo addAttribute:NSFontAttributeName value:HeavyFont range:rangeHeavyPart];
    [CurrentCountLable.titleLabel setAttributedText:HeavyNo];
    [CurrentCountLable.titleLabel setTextColor:[UIColor whiteColor]];
    CurrentCountLable.titleLabel.textAlignment =  NSTextAlignmentCenter ;
    CurrentCountLable.layer.cornerRadius  = 20;
    CurrentCountLable.layer.masksToBounds = YES ;
    [self.HeaderContent addSubview: self.CountLabel];
}


#pragma mark -计数器重置
-(void)CountReset {
    [self.CountLabel setTitle:[NSString stringWithFormat:@"1/%ld",(long)self.ImgTotal] forState:UIControlStateNormal];
    [self scrollViewDidScroll:self.scrollView3];
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



#pragma mark -白底背景，用于延迟的填充背景
- (void)addWhiteBack {
    UIView *MengBan = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
    [self.view addSubview:MengBan];
    [self.view bringSubviewToFront:MengBan];
    MengBan.tag = 999;
    MengBan.backgroundColor = [UIColor whiteColor];
}

-(NSString *)judgeNullValue:(NSString *)string{
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    else  return string;
}


-(void)dealloc {
    
 self.scrollView3.delegate = nil;
 self.detailInfoTable.delegate = nil;
    
}


#pragma mark -sharedPopDelegate

-(void)removeDimBack {
    
}

-(void)QFsharedWith:(NSInteger)index {
    
    AppDelegate *app =  [UIApplication sharedApplication].delegate;
    NSLog(@"%@",app.usrInfoDic);
    OSMessage *msg=[[OSMessage alloc]init];
    msg.title=self.FangData[@"biaoti"];
    NSString *urlLink = [NSString stringWithFormat:@"http://www.123qf.cn/front/fkyuan/wap_cz_zz.jsp?zhuangtai=0&fid=%@&fenlei=0&userID=%@",self.FangData[@"id"],app.usrInfoDic[@"userid"]];
    NSLog(@"%@",urlLink);
    msg.link=urlLink;
    
    UIImageView *imageView = [UIImageView new];
    [imageView sd_setImageWithURL:self.imagesData[0] placeholderImage:nil];
    msg.image = imageView.image;
    
   // NSString *recodUrl = @"http://www.123qf.cn/app/share/saveShareUser.api";
    NSString *RecodrUrl = [NSString stringWithFormat:@"http://www.123qf.cn/app/share/saveShareUser.api?fid=%@",self.FangData[@"id"]];
  
    
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


-(NSString *)getAttacMentFromDataDic {
    NSString *str = @"";

    //    &meiqi=true
    //    &kuandai=true
    //    &dianti=true
    //    &tingchechang=true
    //    &dianshi=true
    //    &jiadian=true
    //    &dianhua=true
    //    &lingbaoruzhu=true
    
    if (![self.FangData[@"meiqi"] isKindOfClass:[NSNull class]]) {
        str = [str stringByAppendingString:@" 煤气"];
    }
    
    if (![self.FangData[@"kuandai"] isKindOfClass:[NSNull class]]) {
        str = [str stringByAppendingString:@" 宽带"];
    }
    
    if (![self.FangData[@"dianti"] isKindOfClass:[NSNull class]]) {
        str = [str stringByAppendingString:@" 电梯"];
    }
    
    if (![self.FangData[@"tingchechang"] isKindOfClass:[NSNull class]]) {
        str = [str stringByAppendingString:@" 停车场"];
    }
    
    if (![self.FangData[@"dianshi"] isKindOfClass:[NSNull class]]) {
        str = [str stringByAppendingString:@" 电视"];
    }
    
    if (![self.FangData[@"jiadian"] isKindOfClass:[NSNull class]]) {
        str = [str stringByAppendingString:@" 家电"];
    }
    
    if (![self.FangData[@"dianhua"] isKindOfClass:[NSNull class]]) {
        str = [str stringByAppendingString:@" 电话"];
    }
    
    if (![self.FangData[@"lingbaoruzhu"] isKindOfClass:[NSNull class]]) {
        str = [str stringByAppendingString:@" 拎包即住"];
    }
    
    return str;
}

@end
