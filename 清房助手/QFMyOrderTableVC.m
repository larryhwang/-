//
//  QFMyOrderTableVC.m
//  
//
//  Created by Larry on 12/25/15.
//  说明:本页面用来描述 我的订单 里面的列表内容
//

#import "QFMyOrderTableVC.h"
#import "MyOrderCell.h"
#import "AFNetworking.h"
#import "QFMyOrderTrackDetailVC.h"
#import "MBProgressHUD+CZ.h"
#import "QFOrderFilter.h"

@interface QFMyOrderTableVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *QFMyOrderTable;
@property(nonatomic,strong)  NSArray  *QFSingleCellData_Arr;

@end

@implementation QFMyOrderTableVC

-(NSArray*)QFSingleCellData_Arr {
    if (_QFSingleCellData_Arr ==nil) {
        _QFSingleCellData_Arr = [NSArray new];
    }
    return _QFSingleCellData_Arr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @" ";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self getTableDataFromNet];
    
    self.QFMyOrderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initNav];
}


-(void)initNav {
    UIButton *RightBarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 27)];
    NSLog(@"NavController:%@",self.navigationController);
    NSLog(@"QIAN ：rightBtn : %@", RightBarBtn);
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"筛选"]];
    [img setFrame:CGRectMake(0, 0, 27, 27)];
    [RightBarBtn addSubview:img];
    [RightBarBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [RightBarBtn addTarget:self action:@selector(RightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [RightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RightBarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
    UIBarButtonItem *gripeBarBtn = [[UIBarButtonItem alloc]initWithCustomView:RightBarBtn];
    self.navigationItem.rightBarButtonItem =gripeBarBtn;
}

/**
 *  订单筛选按钮点击
 */
-(void)RightBtnClick {
    QFOrderFilter *filter = [[QFOrderFilter alloc]init];
    filter.uptableData = ^(NSDictionary *dic) {
       //截取到新的数组
        
        [self.QFMyOrderTable reloadData];
    };
    filter.title  = @"筛选";
    [self.navigationController pushViewController:filter animated:YES];
}

-(void)getTableDataFromNet {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString *url = @"http://www.123qf.cn:81/testApp/integrateFindByUser.api?page=1";
    [mgr POST:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        self.QFSingleCellData_Arr = responseObject[@"data"];
        NSLog(@"%@",self.QFSingleCellData_Arr);
       [self.QFMyOrderTable reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.QFSingleCellData_Arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.QFSingleCellData_Arr[indexPath.row];
    NSLog(@"%@",dic);
    
    MyOrderCell    *Cell = [[MyOrderCell alloc]init];
    
    Cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderCell" owner:nil options:nil] firstObject];
    
    Cell.QFCellDataDic = dic;
    
    NSLog(@"fuzhi hou ： %@ ,%@ ,%@",    Cell.QFOrderNo.text,
          Cell.QFOrderStatus.text ,
          Cell.QFServiceType.text);
  
    return Cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //integratePicFind.api  ordernum
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *url= @"http://www.123qf.cn:81/testApp/integratePicFind.api";
    
    NSDictionary *CellDic = self.QFSingleCellData_Arr [indexPath.row];
    NSMutableDictionary *pramam_dic = [NSMutableDictionary new];
    pramam_dic[@"ordernum"] = CellDic[@"ordernum"];
    

    QFMyOrderTrackDetailVC *detailVC = [[QFMyOrderTrackDetailVC alloc]init];
    detailVC.title = @"订单详情";

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [MBProgressHUD showMessage:@"加载中"];
    
    [mgr POST:url parameters:pramam_dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    NSLog(@"%@",responseObject);
        
    [MBProgressHUD  hideHUD];
        
    NSDictionary *dict = responseObject[@"data"];
        
        NSLog(@"dict : %@",dict);
        
        detailVC.QFHeadViewDic = dict[@"user"];  //表头信息
        
        detailVC.QFTableArr    = dict[@"info"];  //追踪的数组信息
        
    [self.navigationController pushViewController:detailVC animated:YES];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    

    
}


@end
