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
    NSString *url = @"";
    [mgr POST:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        self.QFSingleCellData_Arr = responseObject[@""];
        [self.QFMyOrderTable reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString    *identifer = @"identifer";
    MyOrderCell    *Cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == Cell)
    {
      Cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderCell" owner:nil options:nil] firstObject];
    }
    

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
