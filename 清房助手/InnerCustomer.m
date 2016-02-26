//
//  InnerCustomer.m
//  清房助手
//
//  Created by Larry on 12/19/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "InnerCustomer.h"
#import "MBProgressHUD+CZ.h"
#import "AFNetworking.h"
#import "PopSeletedView.h"
#import "TableViewController.h"
#import "HomeViewController.h"
#import "FilterViewController.h"
/**
 *  说明: 这个页面用来展示公司客源 ，
      ?  怎么确定是什么公司 ，列表中岂不是 有 求租、求购、两种状态 ？
 */

@interface InnerCustomer ()<UITableViewDataSource,UITableViewDelegate> {
    BOOL                _isSaleStatus;
    BOOL                _popStatus;   //区域选择是否
    NSMutableArray      *_TabBarBtns;
    NSMutableDictionary *_updateLocationParam;
    UIView              *_bottomLine;
    NSString            *_preName;
    PopSeletedView      *_popView;
}

@property(nonatomic,strong)  AFHTTPRequestOperationManager     *shareMgr;
@property(nonatomic,strong)  NSArray                           *DataArr;
@property(nonatomic,copy)    NSString                          *userID;
@property(nonatomic,assign)  CellStatus                        status;
@property(nonatomic,copy)    NSString                          *CurrentRuest;
@property(nonatomic,strong)  NSDictionary                      *pramaDic;
@property(nonatomic,strong)    TableViewController               *ResultTableView;
@property(nonatomic,strong)  NSMutableArray  *LocationNameDicPartOne_NSarr;
@property(nonatomic,strong)  NSMutableArray  *LocationNameDicPartTwo_NSarr;
@property (weak, nonatomic)  IBOutlet UITableView *tableView;


@end

@implementation InnerCustomer

-(NSDictionary*)pramaDic {
    if (_pramaDic ==nil) {
        _pramaDic = [NSDictionary new];
    }
    return _pramaDic;
}



- (void)viewDidLoad {
   [super viewDidLoad];
    self.tableView.height = 100;


}

-(void)pramaInit {
    self.CurrentRuest = @"";
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      return 15;
    //   return self.DataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString    *identifer = @"identifer";
    UITableViewCell    *Cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == Cell)
    {
        
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
    }
    Cell.textLabel.text = @"椰子汁";
    //单元格内容
    return Cell;
}

/**
 *  加载URL中的返回的数据
 */
- (void) LoadNetDataWithCurentURl{
    [MBProgressHUD showMessage:@"正在加载"];
    NSLog(@"即将上线:%@,  %@",_CurrentRuest,self.pramaDic);
    [self.shareMgr POST:self.CurrentRuest
             parameters: self.pramaDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [MBProgressHUD hideHUD];
                 NSLog(@"右选项卡%@",responseObject);
                 NSArray *DataArra = responseObject[@"data"];
                 if ([DataArra isKindOfClass:[NSArray class]]) {
                     self.userID  = responseObject[@""];
                     self.DataArr = DataArra;
                     [self.tableView reloadData];
                 }else {
                     self.DataArr = @[];
                     [self.tableView reloadData];
                     UIAlertView *aleat=[[UIAlertView alloc] initWithTitle:@"提醒" message:@"暂无相关信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [aleat show];
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
