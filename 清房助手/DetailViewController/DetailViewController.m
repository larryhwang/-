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
#define  ToolHeight  60    //固定底部的大小


@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
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
    [self initCountLabel];
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    
    NSString *url3 = [NSString stringWithFormat:@"http://192.168.1.38:8080/qfzsapi/fangyuan/detailsHouse.api?fenLei=0&fangyuan_id=%@",self.DisplayId];
    


    
    [mgr POST:url3
   parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       self.FangData = responseObject[@"data"];
       NSLog(@"%@",self.FangData);
       NSString *collect = self.FangData[@"tupian"];
       NSArray *imgArray = [collect componentsSeparatedByString:@","];
       self.ImgTotal = [imgArray count];
       for (NSString *imgName in imgArray) {
           NSString *ImgfullUrl = [NSString stringWithFormat:@"http://112.74.64.145/hsf/img/%@",imgName];
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
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",error);
   }];


    self.detailInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone ;
    //尺寸
    NSLog(@"高度%f",self.detailInfoTable.height);
    ;
    
}



#pragma mark -初始化表
-(void)initTable {
    self.detailInfoTable = [[UITableView alloc]init];
    self.detailInfoTable.delegate = self ;
    self.detailInfoTable.dataSource = self;
    self.detailInfoTable.allowsSelection = NO ;
    [self.detailInfoTable setFrame:CGRectMake(0, 0, ScreenWidth, 607)];
}


-(void)initHeadScorlImage {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0,self.detailInfoTable.height, ScreenWidth, ToolHeight)];
    footer.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.detailInfoTable];
    [self.view addSubview:footer];
    
    UIView *HeaderContent = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight/4)];
    self.HeaderContent = HeaderContent;
    self.scrollView3  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight/4)];
    [HeaderContent addSubview:self.scrollView3];
    self.scrollView3.pagingEnabled = YES ;
    self.scrollView3.delegate = self ;
    self.scrollView3.showsHorizontalScrollIndicator  =  NO ;
    self.imagesData = [NSMutableArray array];
    self.detailInfoTable.tableHeaderView = HeaderContent;
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
    NSLog(@"%@",scrollView);
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    NSString  *nowSelected =[NSString stringWithFormat:@"%d/%d",pageIndex + 1,self.ImgTotal];
    NSLog(@"哈哈%@",nowSelected);
    [self.CountLabel setTitle:nowSelected forState:UIControlStateNormal];
    self.CountLabel.titleLabel.text = nowSelected ;
    NSLog(@"嘻嘻:%@",self.CountLabel.titleLabel.text);
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
      //  imageView.image = [UIImage imageNamed:imageName];
        NSLog(@"图片地址%@",self.imagesData[idx]);
        [imageView sd_setImageWithURL:self.imagesData[idx] placeholderImage:nil];
        [self.scrollView3 addSubview:imageView];
    }];
    
    
}

#pragma mark -表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    FlatLocationCell  *LocationCell  = [FlatLocationCell new];
    FlatDetailCell   *DetailCell = [FlatDetailCell new];
    DescribeCell  *DescribieCell = [DescribeCell freeCellWithTitle:@"房源描述" andContext:self.FangData[@"fangyuanmiaoshu"]];
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
        NSLog(@"test%f,%f",testCell.frame.size.width,testCell.frame.size.height);
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
   
}

#pragma mark -表高度返回设置
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"index:%d",indexPath.row);
    if (indexPath.row==0) {
        return 116.0;
    }
   else if (indexPath.row ==1) {
       NSLog(@"%f",self.FreeCellHeight);
       return  self.FreeCellHeight;
    }
   else if (indexPath.row ==2) {
           return 131;
   }
  else {
     return self.DescribeCellHeight + 5 ;
    }
}


#pragma mark -计数器的初始化
-(void)initCountLabel {
    UIButton *CurrentCountLable  = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-50, ScreenHeight/4-50, 40, 40)];
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

@end
