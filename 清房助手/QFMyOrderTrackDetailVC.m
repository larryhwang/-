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

@interface QFMyOrderTrackDetailVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *_QFCurrentTeleNo;
}
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
    self.tableView.dataSource =  self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TableBackColor ;
    NSArray *nibsS = [[NSBundle mainBundle]loadNibNamed:@"detailHeadView" owner:self options:nil];
    detailHeadView *headView = [nibsS lastObject];

    for (UIButton *btn in headView.QFteleBtns) {
        [btn addTarget:self action:@selector(TeleTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    headView.QFheadViewDic = self.QFHeadViewDic;
    self.tableView.tableHeaderView = headView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _QFTableArr.count;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sinlgeCellDic = self.QFTableArr[indexPath.row];
    NSLog(@"QFTable :%@  %@",sinlgeCellDic,self.QFTableArr);
    QFProcessCell  *Cell =[[QFProcessCell alloc]init];
    Cell  =  [[[NSBundle mainBundle]loadNibNamed:@"QFProcessCell" owner:nil options:nil] firstObject];
    Cell.QFDateLabel.text = sinlgeCellDic[@"createtime"];
    Cell.QFProcessLabel.text = sinlgeCellDic[@"msg"];
    NSLog(@"%d",indexPath.row);
    if (indexPath.row ==0) {
        Cell.QF_isLastestCell = YES;
    }
    return Cell;
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}



- (void)textViewDidChange:(UITextView *)textView;
{
    NSLog(@"textfield text %@",textView.text);
}



#pragma mark -拨打电话
-(void)TeleTap:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *tele = btn.titleLabel.text;
    _QFCurrentTeleNo = tele;
    UIAlertView *AW = [[UIAlertView alloc]initWithTitle:nil
                                                message:_QFCurrentTeleNo
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"呼叫", nil];
    AW.tag = 0;
   [AW show];
}


//打电话代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 
    NSString *tele =[NSString stringWithFormat:@"tel://%@", _QFCurrentTeleNo];//;
    if(buttonIndex == 1 && alertView.tag==0 ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tele]];
    } else {
        
        return ;
    }
}

@end
