//
//  QFMyOrderTableVC.m
//  
//
//  Created by Larry on 12/25/15.
//
//

#import "QFMyOrderTableVC.h"
#import "MyOrderCell.h"
#import "AFNetworking.h"
#import "QFMyOrderTrackDetailVC.h"


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
    self.edgesForExtendedLayout = UIRectEdgeNone ;
   [self getTableDataFromNet];
    self.QFMyOrderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
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
//    NSString *url= @"";
//    NSDictionary *dic = self.QFSingleCellData_Arr [indexPath.row];
//    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     QFMyOrderTrackDetailVC *detailVC = [[QFMyOrderTrackDetailVC alloc]init];
    detailVC.title = @"订单详情";
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    [mgr POST:url parameters:m_dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        /**
//         *  眺望为hangh
//         */
//         NSLog(@"");
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
    
}


@end
