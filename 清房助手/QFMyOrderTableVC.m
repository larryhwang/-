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

#import "MJRefresh.h"

#import "AppDelegate.h"

@interface QFMyOrderTableVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *QFMyOrderTable;
@property(nonatomic,strong)  NSArray  *QFSingleCellData_Arr;

@property(nonatomic,strong)  NSMutableDictionary  *PramaDic;

@property(nonatomic,assign) int nowPageIndex;

@property(nonatomic,strong)  AFHTTPRequestOperationManager  *shareMgr;

@property(nonatomic,copy) NSString *CurrentRuest;

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
    self.nowPageIndex = 1;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @" ";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self getTableDataFromNet];
    
    self.QFMyOrderTable.separatorStyle = UITableViewCellSeparatorStyleNone; //

    [self.QFMyOrderTable addFooterWithTarget:self action:@selector(loadMoreData)];
    
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
        NSLog(@"%@",dic);
        self.QFSingleCellData_Arr = dic[@"data"];
        [self.QFMyOrderTable reloadData];
    };
    filter.title  = @"筛选";
    [self.navigationController pushViewController:filter animated:YES];
}

-(void)getTableDataFromNet {
    [MBProgressHUD showMessage:@"正在加载"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSString *userName = delegate.usrInfoDic[@"username"];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[NSString stringWithFormat:@"%d",self.nowPageIndex] forKey:@"page"];  //@{@"page":@"1"};
     self.PramaDic = dict;
    NSString *url;
    NSLog(@"权限列表:%@",delegate.QFUserPermissionDic_NSMArr);
    // "订单跟踪(负责人)"
    url = @"http://www.123qf.cn/app/integrateFindByUser.api";  //中介公司账号用

    for (NSString *PerMisionName in delegate.QFUserPermissionDic_NSMArr) {
        if ([PerMisionName rangeOfString:@"订单跟踪"].length) {
            url = @"http://www.123qf.cn/app/integrateFind.api";  //四方
           [self.PramaDic setObject:userName forKey:@"pname"];
        }
            self.CurrentRuest = url;
    }
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    self.shareMgr = mgr ;
   [self.shareMgr POST:url parameters:self.PramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToString: @"00202"]) {
            self.QFSingleCellData_Arr = @[];
            UIAlertView *aleat=[[UIAlertView alloc] initWithTitle:@"提醒" message:@"暂无相关信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aleat show];
        } else{
            self.QFSingleCellData_Arr = responseObject[@"data"];
        }
       
       [MBProgressHUD hideHUD];
        NSLog(@"%@",responseObject[@"data"]);
        [self.QFMyOrderTable reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
         NSLog(@"%@",error);
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.QFSingleCellData_Arr) {
        NSLog(@"%@",self.QFSingleCellData_Arr);
        return [self.QFSingleCellData_Arr count];
    } else {
        return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.QFSingleCellData_Arr[indexPath.row];
    NSLog(@"%@",dic);
    
    MyOrderCell    *Cell = [[MyOrderCell alloc]init];
    Cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderCell" owner:nil options:nil] firstObject];
    Cell.QFCellDataDic = dic;
    return Cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //integratePicFind.api  ordernum
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //  NSString *url= @"http://www.123qf.cn:81/testApp/integratePicFind.api";
      NSString *url= @"http://www.123qf.cn/app/integratePicFind.api";
    
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


-(void)loadMoreData {
    self.nowPageIndex ++;
    [self.PramaDic setObject:[NSString stringWithFormat:@"%d",self.nowPageIndex] forKey:@"currentpage"];
    [self.shareMgr POST:self.CurrentRuest parameters:self.PramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"追加:%@",responseObject);
        [self.QFMyOrderTable footerEndRefreshing];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSArray *appendArr = responseObject[@"data"];
            self.QFSingleCellData_Arr = [self.QFSingleCellData_Arr arrayByAddingObjectsFromArray:appendArr];
            [self.QFMyOrderTable reloadData];
        } else {
            [MBProgressHUD showError:@"无更多数据了哟"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.QFMyOrderTable headerEndRefreshing];
        [MBProgressHUD showError:@"网络超时，稍后尝试"];
        NSLog(@"%@",error);
        NSLog(@"网络超时");
    }];
    NSLog(@"上拉");
}

@end
