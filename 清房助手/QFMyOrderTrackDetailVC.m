//
//  MyOrderTrackDetailVC.m
//  清房助手
//
//  Created by Larry on 12/25/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//


#import "QFMyOrderTrackDetailVC.h"
#import "QFProcessCell.h"
#import "detailHeadView.h"
#import "MBProgressHUD+CZ.h"
#import "AFNetworking.h"

@interface QFMyOrderTrackDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)  UITableView *tableView;
@property(nonatomic,weak)  detailHeadView *headview;

@end

@implementation QFMyOrderTrackDetailVC








- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTable];

    
    [self.view addSubview:self.tableView];
    
    
    
}



-(void)initTable {
 //   self.tableDataArr = self.QFownerInfoDic[@"seeOwnerList"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.tableView.delegate   =  self;
    self.tableView.dataSource =self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TableBackColor ;
    NSArray *nibsS = [[NSBundle mainBundle]loadNibNamed:@"detailHeadView" owner:self options:nil];
    detailHeadView *headView = [nibsS lastObject];
    headView.QFheadViewDic = self.QFHeadViewDic;
    self.tableView.tableHeaderView = headView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   // return [self.tableDataArr count];
  //  return [self.tableDataArr count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sinlgeCellDic = self.QFTableArr[indexPath.row];
    
    NSLog(@"QFTable :%@  %@",sinlgeCellDic,self.QFTableArr);
    QFProcessCell  *Cell =[[QFProcessCell alloc]init];
    Cell  =  [[[NSBundle mainBundle]loadNibNamed:@"QFProcessCell" owner:nil options:nil] firstObject];
    Cell.QFDateLabel.text = sinlgeCellDic[@"createtime"];
    Cell.QFProcessLabel.text = sinlgeCellDic[@"msg"];
    
    Cell.QFProcessLabel.backgroundColor = DeafaultColor2;
    NSLog(@"%d",indexPath.row);
    if (indexPath.row ==0) {
        Cell.QF_isLastestCell = YES;
    }
    return Cell;
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if((indexPath.row%2)==0){
    //        return 10;
    //    }else {
    //        return 100;
    //    }
    return 100;
    
}



- (void)textViewDidChange:(UITextView *)textView;
{
    NSLog(@"textfield text %@",textView.text);
   // _checkReson = textView.text;
}

@end
