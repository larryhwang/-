//
//  LesveMsgVC.m
//  清房助手
//
//  Created by Larry on 12/21/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "LesveMsgVC.h"
#import "LeavMsgHeadView.h"
#import "LeavMsgCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD+CZ.h"



#define   ViewCellPaddingToX     20
#define   ViewCellWidth          (ScreenWidth-2*ViewCellPaddingToX)


@interface LesveMsgVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate> {
    NSString    *_checkReson;
}

@property (strong, nonatomic)  UITableView *tableView;
@property(nonatomic,strong)  NSArray  *tableDataArr;
@property(nonatomic,weak) LeavMsgHeadView *headView;

@end //237 236 242

@implementation LesveMsgVC

-(NSArray*)tableDataArr {
    if (_tableDataArr ==nil) {
        _tableDataArr = [NSArray new];
    }
    return _tableDataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTable];
     UIButton *SureBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [SureBtn addTarget:self action:@selector(SureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [SureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [SureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *RightNavBar = [[UIBarButtonItem alloc]initWithCustomView:SureBtn];
    self.navigationItem.rightBarButtonItem = RightNavBar;
    
    [self.view addSubview:self.tableView];
    

    
}

-(void)SureBtnClick {
    [self.view endEditing:YES];
    NSDictionary *usrInfoDic = self.QFownerInfoDic[@"OwnerInfo"];
    NSString *checkReson = self.headView.checkRessonTextView.text;
    NSLog(@"理由哦 %@",checkReson);
    if (_checkReson.length >0) {
        //提交信息并返回上一个菜单
        NSString *postUrl = @"http://www.123qf.cn:81/testApp/fkyuan/insertSelectOwnerInfoReason.api";
        NSMutableDictionary *pram= [NSMutableDictionary new];
        pram[@"kid"] = usrInfoDic[@"id"];
        pram[@"content"] = _checkReson;
        [MBProgressHUD showMessage:@"提交中"];
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        [mgr POST:postUrl parameters:pram success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSNumber *bb = responseObject[@"code"];
            NSNumber *cc =  [NSNumber numberWithInt:1];
            if ([bb isEqualToNumber:cc]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:@"未知错误，请稍候重试"];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        

        
    }
    else {
        UIAlertView *AW = [[UIAlertView alloc]initWithTitle:nil
                                                    message:@"请输入查看原因"
                                                   delegate:self
                                          cancelButtonTitle:@"好的"
                                          otherButtonTitles:nil, nil];
        
        [AW show];
    }
}


-(void)initTable {
    self.tableDataArr = self.QFownerInfoDic[@"seeOwnerList"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.tableView.delegate =  self;
    self.tableView.dataSource =self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TableBackColor ;
    NSArray *nibsS = [[NSBundle mainBundle]loadNibNamed:@"QFLeavMsgHeadView" owner:self options:nil];
    LeavMsgHeadView *headView = [nibsS lastObject];
    headView.checkRessonTextView.delegate = self;
    NSDictionary *usrInfoDic = self.QFownerInfoDic[@"OwnerInfo"];
    headView.userNameLabel.text   = usrInfoDic[@"ownername"];
    headView.userTeleNoLabel.text = usrInfoDic[@"ownertel"];
    self.tableView.tableHeaderView = headView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.tableDataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSDictionary *sinlgeCellDic = self.tableDataArr[indexPath.row];
        LeavMsgCell  *Cell =[[LeavMsgCell alloc]init];
        Cell  =  [[[NSBundle mainBundle]loadNibNamed:@"LeavMsgCell" owner:nil options:nil] firstObject];
        Cell.QFSingleCellDataDic = sinlgeCellDic;
        return Cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if((indexPath.row%2)==0){
//        return 10;
//    }else {
//        return 100;
//    }
    return 120;

}



- (void)textViewDidChange:(UITextView *)textView;
{
    NSLog(@"textfield text %@",textView.text);
    _checkReson = textView.text;
}

@end
