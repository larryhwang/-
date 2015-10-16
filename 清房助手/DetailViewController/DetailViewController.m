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


#define  HeavyFont     [UIFont fontWithName:@"Helvetica-Bold" size:25]
#define  ToolHeight  60


@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic)  UITableView *detailInfoTable;
@property (strong, nonatomic) NSArray *imagesData;
@property(nonatomic,weak)  UIButton *CountLabel;
@property (strong, nonatomic)  UIScrollView *scrollView3;
@property(nonatomic,strong)  NSDictionary  *FangData;



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
    //底部加载
   // UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, self.detailInfoTable.height , ScreenWidth, ToolHeight)];
    
   
    self.detailInfoTable = [[UITableView alloc]init];
    self.detailInfoTable.delegate = self ;
    self.detailInfoTable.dataSource = self;
    self.detailInfoTable.allowsSelection = NO ;
    [self.detailInfoTable setFrame:CGRectMake(0, 0, ScreenWidth, 607)];
    
     UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0,self.detailInfoTable.height, ScreenWidth, ToolHeight)];
     footer.backgroundColor = [UIColor redColor];
 
    [self.view addSubview:self.detailInfoTable];
       [self.view addSubview:footer];
    //self.detailInfoTable.tableFooterView  = footer ;
    
    
    
    
    self.scrollView3  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight/4)];
    self.scrollView3.pagingEnabled = YES ;
    self.scrollView3.delegate = self ;
    self.scrollView3.showsHorizontalScrollIndicator  =  NO ;
    self.imagesData = @[@"image1.jpg", @"image2.jpg", @"image3.jpg", @"image4.jpg", @"image5.jpg", @"image6.jpg"];
    [self setupScrollViewImages];
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    
    NSString *url3 = [NSString stringWithFormat:@"http://192.168.1.38:8080/qfzsapi/fangyuan/detailsHouse.api?fenLei=0&fangyuan_id=%@",self.DisplayId];
    //self
    UIButton *CurrentCountLable  = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-50, ScreenHeight/4-50, 40, 40)];
    self.CountLabel = CurrentCountLable ;
    self.CountLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    [CurrentCountLable setTitle:@"1/6" forState:UIControlStateNormal];
    
      //加粗选中数字
    NSMutableAttributedString *HeavyNo = [[NSMutableAttributedString alloc]initWithString:CurrentCountLable.titleLabel.text];
    NSRange rangeHeavyPart =  NSMakeRange(0, 2);
    [HeavyNo addAttribute:NSFontAttributeName value:HeavyFont range:rangeHeavyPart];
    [CurrentCountLable.titleLabel setAttributedText:HeavyNo];
    
    [CurrentCountLable.titleLabel setTextColor:[UIColor whiteColor]];
    CurrentCountLable.titleLabel.textAlignment =  NSTextAlignmentCenter ;
    CurrentCountLable.layer.cornerRadius  = 20;
    CurrentCountLable.layer.masksToBounds = YES ;
    [self.view addSubview:CurrentCountLable];
    [self setupScrollViewImages];
    self.scrollView3.delegate = self;

    
    [mgr POST:url3
   parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       self.FangData = responseObject[@"data"];
       
       NSLog(@"单房源信息%@",responseObject);
       [self.detailInfoTable reloadData];
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",error);
   }];

    self.detailInfoTable.tableHeaderView = self.scrollView3;
  
    self.detailInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    
    //尺寸
    NSLog(@"高度%f",self.detailInfoTable.height);
    ;
    
}


//设置scoview的大小
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView3.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView3.frame) * self.imagesData.count, CGRectGetHeight(self.scrollView3.frame));
}


#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    NSString  *nowSelected =[NSString stringWithFormat:@"%d/6",pageIndex + 1];
    [self.CountLabel setTitle:nowSelected forState:UIControlStateNormal];
    NSMutableAttributedString *HeavyNo = [[NSMutableAttributedString alloc]initWithString:self.CountLabel.titleLabel.text];
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
        imageView.image = [UIImage imageNamed:imageName];
        NSLog(@"一次");
        [self.scrollView3 addSubview:imageView];
    }];
    
    
}

#pragma mark -表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    FactoryLoactionCell  *LocationCell  = [FactoryLoactionCell new];
    NSLog(@"真正%@",self.FangData);

    
    

    
    
    
    FlatDetailCell   *DetailCell = [FlatDetailCell new];
    
    
    
    
    
    
    
    DescribeCell  *DescribieCell = [DescribeCell new];
    
    
    
    

    
   // UILabel
    
    LocationCell  =  [[[NSBundle mainBundle]loadNibNamed:@"FactoryLoactionCell" owner:nil options:nil] firstObject];
    DescribieCell = [[[NSBundle mainBundle]loadNibNamed:@"DescribeCell" owner:nil options:nil] firstObject];
    DetailCell = [[[NSBundle mainBundle]loadNibNamed:@"FlatDetailCell" owner:nil options:nil] firstObject];
    
    
    if (indexPath.row ==0) {
        LocationCell.Tittle.text = self.FangData[@"biaoti"];
        LocationCell.Time.text = self.FangData[@"weituodate"];
        LocationCell.Positon.text = self.FangData[@"region"];
        LocationCell.Adress.text = self.FangData[@"dizhi"];
        LocationCell.Price.text = [NSString stringWithFormat:@"%@",self.FangData[@"shoujia"]];//;
        return LocationCell;
    }else if (indexPath.row ==1) {
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
    }else {
        DescribieCell.Describe.numberOfLines = 0;
        DescribieCell.Describe.backgroundColor = [UIColor blueColor];
     // DescribieCell.Describe.text = @"李琦参加好声音前就有过不少表演经历";
       [DescribieCell setDescribeText:self.FangData[@"fangyuanmiaoshu"]];
         NSLog(@"高度%f",self.detailInfoTable.height);
        return DescribieCell;
    }
   
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index:%d",indexPath.row);
    
    if (indexPath.row==0) {
        return 150.0;
    }
   else if (indexPath.row ==1) {
        return 200;
    }
  else {
      DescribeCell *cell = [self.detailInfoTable cellForRowAtIndexPath:indexPath];
      NSLog(@"%f",cell.height);
//       return cell.frame.size.height;
     return 200;
    }
}



@end
