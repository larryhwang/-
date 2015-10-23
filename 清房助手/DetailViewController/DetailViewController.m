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


#define  HeavyFont     [UIFont fontWithName:@"Helvetica-Bold" size:25]
#define  ToolHeight  50    //固定底部的大小
#define LeftViewWidth   ScreenWidth/4
#define MiddleViewWidth   ScreenWidth/2
#define RightViewWidth   ScreenWidth/4
#define Padding  8


@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic)  UITableView *detailInfoTable;
@property (strong, nonatomic) NSMutableArray *imagesData;
@property(nonatomic,weak)  UIButton *CountLabel;
@property (strong, nonatomic)  UIScrollView *scrollView3;
@property(nonatomic,strong)  NSDictionary  *FangData;
@property(nonatomic) CGFloat CellHeight;
@property(nonatomic) CGFloat FreeCellHeight;
@property(nonatomic) CGFloat DescribeCellHeight;
@property(nonatomic,strong)  UIView  *HeaderContent;
@property(nonatomic) NSInteger ImgTotal;

@property(nonatomic,strong) UILabel *Publisher;
@property(nonatomic,strong) UILabel *Name;
@property(nonatomic,strong) UILabel *Tele;



@end

@implementation DetailViewController


-(NSDictionary *)FangData {
    if (_FangData == nil) {
        _FangData = [NSDictionary dictionary];
    }
    return _FangData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTable];

    [self initHeadScorlImage];
    [self getDataFromNet];
  //  [self initFootView];
    
}



#pragma mark -初始化表




-(void)initTable {
    self.detailInfoTable = [[UITableView alloc]init];
    self.detailInfoTable.delegate = self ;
    self.detailInfoTable.dataSource = self;
    self.detailInfoTable.allowsSelection = NO ;
//    if (<#condition#>) {
//        <#statements#> isI5?607
//    }
#warning 表高度
    [self.detailInfoTable setFrame:CGRectMake(0, 0, ScreenWidth, 568)];
    self.detailInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self.view addSubview:self.detailInfoTable];
}


-(void)getDataFromNet {
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    NSString *url3 = [NSString stringWithFormat:@"http://www.123qf.cn/testApp/fangyuan/detailsHouse.api?fenLei=%@&fangyuan_id=%@",self.FenLei,self.DisplayId];
    
    [mgr POST:url3
   parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
#warning 请求成功后的网络处理
       self.FangData = responseObject[@"data"];
       NSLog(@"单个数据详情%@",self.FangData);
       NSString *collect = self.FangData[@"tupian"];
       NSArray *imgArray = [collect componentsSeparatedByString:@","];
       self.ImgTotal = [imgArray count];
       for (NSString *imgName in imgArray) {
           //http://www.123qf.cn/testWeb/img/13719678138/userfile/qfzs/fy/mini/hsf_20151016135218_0.jpg
           //http://112.74.64.145/hsf/img/%@",imgName
           NSString *ImgfullUrl = [NSString stringWithFormat:@"http://www.123qf.cn/testWeb/img/%@/userfile/qfzs/fy/mini/%@",self.uerID,imgName];
           [self.imagesData addObject:ImgfullUrl];
       }   //所有图片地址
       
       
       CGSize size = CGSizeMake(ScreenWidth, 1000);
       NSString *context = self.FangData[@"fangyuanmiaoshu"];
       NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
       CGSize labelSize = [context boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
       self.CellHeight = labelSize.height ;
       [self.detailInfoTable reloadData];
       [self viewDidLayoutSubviews];     //设置滚动视图的横向大小
       [self setupScrollViewImages];   //设置滚动视图内图片
       [self CountReset];
       [self initFootView];
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",error);
   }];
    ;
}


#pragma 初始化底部工具条
-(void)initFootView {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight-ToolHeight, ScreenWidth, ToolHeight)];
    UITapGestureRecognizer *TeleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TeleTap:)];
    //左边
    UIView *PublisherAndCo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/4, ToolHeight)];
    PublisherAndCo.backgroundColor = DeafaultColor;
    UILabel *Company  = [[UILabel alloc]init];
    self.Publisher = Company ;
 
    Company.textColor = [UIColor whiteColor];
    Company.text = self.FangData[@"name"];  //@"丰登地产";
    UIFont *Deafult = [UIFont systemFontOfSize:17];
    CGSize MaxLeftSzie = CGSizeMake(LeftViewWidth-Padding,ToolHeight-Padding);
    CGSize companyLabelSize = [self sizeWithString:Company.text font:Deafult maxSize:MaxLeftSzie];
    UILabel *ContactName  = [[UILabel alloc]init];
    self.Name = ContactName;
    ContactName.textColor = [UIColor whiteColor];
    ContactName.text = self.FangData[@"publisher"];
    
    CGSize NameLabelSize = [self sizeWithString:ContactName.text font:Deafult maxSize:MaxLeftSzie];
    [Company setFrame:CGRectMake((LeftViewWidth -companyLabelSize.width)/2 , (ToolHeight - (companyLabelSize.height + NameLabelSize.height))/2, companyLabelSize.width, companyLabelSize.height)];
    [ContactName setFrame:CGRectMake((LeftViewWidth -NameLabelSize.width)/2, (Company.frame.origin.y +Company.frame.size.height +2), NameLabelSize.width, NameLabelSize.height)];
    [PublisherAndCo addSubview:Company];
    [PublisherAndCo addSubview:ContactName];
    [footer addSubview:PublisherAndCo];
/*
 
 UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:selfaction:@selector(Actiondo:)];
 
 [uiview addGestureRecognizer:tapGesture];
 */
    PublisherAndCo.userInteractionEnabled = YES;

    
    
    [footer addSubview:PublisherAndCo];
    
    //中部
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
    [teleLabel setFrame:CGRectMake(TeleIcon.frame.origin.x + Padding - 5 + 30, (ToolHeight - TeleLabelSize.height)/2, TeleLabelSize.width, TeleLabelSize.height)];
        [TeleView addSubview:TeleIcon];
    [TeleView addSubview:teleLabel];
    TeleView.backgroundColor = DeafaultColor2;
    [footer addSubview:TeleView];
    [TeleView addGestureRecognizer:TeleTap];

    //右部

    
    UIView *MsgView =[[UIImageView alloc]initWithFrame:CGRectMake((3*ScreenWidth/4)+2, 0, ScreenWidth/4, ToolHeight)];
    MsgView.backgroundColor = DeafaultColor;
    UIImageView *MsgIcon =[[UIImageView alloc]init];
    MsgIcon.image  = [UIImage imageNamed:@"mail"];
    [MsgIcon setFrame:CGRectMake((LeftViewWidth - 40)/2, (ToolHeight-20)/2, 40, 20)];
    [MsgView addSubview:MsgIcon];
   [footer addSubview:MsgView];
    
    
    
    footer.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:footer];
}

-(void)TeleTap:(id)sender {
    NSString *tele =self.FangData[@"tel"];//;
    UIAlertView *AW = [[UIAlertView alloc]initWithTitle:nil
                                                message:tele
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"呼叫", nil];
    
    [AW show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *tele =[NSString stringWithFormat:@"tel://%@", self.FangData[@"tel"]];//;
    if(buttonIndex == 1 ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tele]];
    } else {
        return ;
    }



}


-(void)initHeadScorlImage {
    
    UIView *HeaderContent = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight/3 + 20)];
    self.HeaderContent = HeaderContent;
    self.scrollView3  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight/3 +20)];
    [HeaderContent addSubview:self.scrollView3];
    self.scrollView3.pagingEnabled = YES ;
    self.scrollView3.delegate = self ;
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
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    NSString  *nowSelected =[NSString stringWithFormat:@"%d/%d",pageIndex + 1,self.ImgTotal];
    [self.CountLabel setTitle:nowSelected forState:UIControlStateNormal];
    self.CountLabel.titleLabel.text = nowSelected ;
    NSMutableAttributedString *HeavyNo = [[NSMutableAttributedString alloc]initWithString:nowSelected];
    NSRange rangeHeavyPart =  NSMakeRange(0, 2);
    [HeavyNo addAttribute:NSFontAttributeName value:HeavyFont range:rangeHeavyPart];
    [self.CountLabel.titleLabel setAttributedText:HeavyNo];
    
}


#pragma mark - Utils
- (void)setupScrollViewImages
{
    [self.imagesData enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView3.frame) * idx, 0, CGRectGetWidth(self.scrollView3.frame), CGRectGetHeight(self.scrollView3.frame))];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:self.imagesData[idx] placeholderImage:nil];
        [self.scrollView3 addSubview:imageView];
    }];
    
    
}

#pragma mark -表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

#pragma mark -表中单元格设置
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
#pragma mark -住宅类
    if ([self.FenLei isEqualToString:@"0"]) {  // start_住宅类
        FlatLocationCell  *LocationCell  = [FlatLocationCell new];
        FlatDetailCell   *DetailCell = [FlatDetailCell new];
        DescribeCell  *DescribieCell = [DescribeCell freeCellWithTitle:@"描述" andContext:self.FangData[@"fangyuanmiaoshu"]];
        FreeCell  *testCell = [FreeCell freeCellWithTitle:@"地址" andContext:self.FangData[@"dizhi"]];
        
        DescribieCell.iSSeparetorLine = NO ;
        self.FreeCellHeight  = testCell.CellHight;
        self.DescribeCellHeight = DescribieCell.CellHight;
        // testCell.backgroundColor = [UIColor blueColor];
        
        LocationCell  =  [[[NSBundle mainBundle]loadNibNamed:@"FlatLocationCell" owner:nil options:nil] firstObject];
        DetailCell = [[[NSBundle mainBundle]loadNibNamed:@"FlatDetailCell" owner:nil options:nil] firstObject];
        
        if (indexPath.row ==0) {
            LocationCell.Title.text = self.FangData[@"biaoti"];
            LocationCell.PostTime.text = self.FangData[@"weituodate"];
            LocationCell.Region.text = self.FangData[@"qu"];
            LocationCell.LouPanName.text = self.FangData[@"mingcheng"];
            LocationCell.Price.text = [NSString stringWithFormat:@"%@",self.FangData[@"shoujia"]];//;
            return LocationCell;
        }else if (indexPath.row ==1) {
            return testCell;
        }else if (indexPath.row ==2){
            DetailCell.FlatType.text = [NSString stringWithFormat:@"%@房%@厅",self.FangData[@"fangshu"],self.FangData[@"tingshu"]];
            DetailCell.Decrorelation.text = self.FangData[@"zhuangxiu"];
            DetailCell.FloatNo.text =  [NSString stringWithFormat:@"%@/%@层 ",self.FangData[@"louceng"],self.FangData[@"zonglouceng"]];
            DetailCell.LookTime.text = self.FangData[@"kanfangtime"];
            //带有HTML，考虑加载HTML啊
            DetailCell.WithFacility.text = @"哈哈哈";
            DetailCell.ExtryTime.text =[NSString stringWithFormat:@"%@个月",self.FangData[@"youxiaoqi"]];
            DetailCell.Direction.text = self.FangData[@"chaoxiang"];
            DetailCell.Area.text = [NSString stringWithFormat:@"%@",self.FangData[@"mianji"]];
            DetailCell.Type.text = self.FangData[@"leixing"];
            return DetailCell;
        }
        else {
            return DescribieCell;
        }
    } //end_住宅类
#pragma mark -商铺类
     else if([self.FenLei isEqualToString:@"1"]) {  //商铺类
        FactoryLoactionCell *cell = [[FactoryLoactionCell alloc]init];
        cell.textLabel.text = @"fuck";
        return cell;
    }
     else if ([self.FenLei isEqualToString:@"2"]) {  //写字楼
         
     }
     else {
         //工厂
     }
   
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
         return self.DescribeCellHeight + 10 ;
  }
}
}


#pragma mark -计数器的初始化
-(void)initCountLabel {
    UIButton *CurrentCountLable  = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-50, ScreenHeight/3-25, 40, 40)];
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


#pragma mark -更新底部工具栏
-(void)updateToolBar {
    self.Tele.text  = self.FangData[@"tel"];
    self.Name.text  = self.FangData[@"name"];
    

     NSString *Publisher =self.FangData[@"publisher"];
     if ([Publisher isKindOfClass:[NSNull class]]) {
     self.Publisher.text = @"佚名";
     }else{
     self.Publisher.text =self.FangData[@"publisher"];
     }
    

}
@end
