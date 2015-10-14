//
//  DetailViewController.m
//  清房助手
//
//  Created by Larry on 15/10/12.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "FactorydescribeCell.h"
#import "FactoryDetailCell.h"
#import "FactoryLoactionCell.h"


#define  HeavyFont     [UIFont fontWithName:@"Helvetica-Bold" size:25]
#define  ToolHeight  60


@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *detailInfoTable;
@property (strong, nonatomic) NSArray *imagesData;
@property(nonatomic,weak)  UIButton *CountLabel;
@property (strong, nonatomic)  UIScrollView *scrollView3;



@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //底部加载
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-ToolHeight, ScreenWidth, ToolHeight)];
    
    footer.backgroundColor = [UIColor redColor];
    
    
    self.detailInfoTable.allowsSelection = NO ;
    
    [self.view addSubview:footer];
    
    
    
    
    
    self.scrollView3  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight/4)];
    self.scrollView3.pagingEnabled = YES ;
    self.scrollView3.delegate = self ;
    self.scrollView3.showsHorizontalScrollIndicator  =  NO ;
    self.imagesData = @[@"image1.jpg", @"image2.jpg", @"image3.jpg", @"image4.jpg", @"image5.jpg", @"image6.jpg"];
    [self setupScrollViewImages];
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    NSString *url3 = @"http://192.168.1.38:8080/qfzsapi/fangyuan/detailsHouse.api?fenLei=0&fangyuan_id=140";
    
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
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",error);
   }];

    self.detailInfoTable.tableHeaderView = self.scrollView3;
  
    self.detailInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    
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
   // NSLog(@"%@",scrollView);
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
    FactorydescribeCell  *DescribieCell = [FactorydescribeCell new];
    FactoryDetailCell    *DetailCell = [FactoryDetailCell new];
    
    LocationCell  =  [[[NSBundle mainBundle]loadNibNamed:@"FactoryLoactionCell" owner:nil options:nil] firstObject];
    DescribieCell = [[[NSBundle mainBundle]loadNibNamed:@"FactorydescribeCell" owner:nil options:nil] firstObject];
    DetailCell = [[[NSBundle mainBundle]loadNibNamed:@"FactoryDetailCell" owner:nil options:nil] firstObject];
    
    
    if (indexPath.row ==0) {
        return LocationCell;
    }else if (indexPath.row ==1) {
        return DetailCell;
    }else {
        return DescribieCell;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"-----");
    if (indexPath.row==0) {
        return 150.0;
    }
   else if (indexPath.row ==1) {
        return 100;
    }
  else {
        return 100;
    }
}



@end
