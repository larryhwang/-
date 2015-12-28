//
//  QFOrderFilter.m
//  清房助手
//
//  Created by Larry on 12/26/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "QFOrderFilter.h"
#import "EditCell.h"
#import "FormCellInMutiTast.h"
#import "PopSelectViewController.h"
#import "commonFile.h"
#import "QFDateSelectStartToEnd.h"
#import "MBProgressHUD+CZ.h"
#import "AFNetworking.h"


#define ModalViewTag   99

@interface QFOrderFilter ()  <UITextFieldDelegate>
@property(nonatomic,weak)    UIButton *StartBtn;
@property(nonatomic,weak)    UIButton *EndBtn;
@property(nonatomic,strong)  NSDictionary  *QFNewDic;
@property(nonatomic,strong)  NSMutableDictionary  *QFPostDic;


@end

@implementation QFOrderFilter


-(NSMutableDictionary*) QFPostDic {
    if (_QFPostDic ==nil) {
        _QFPostDic = [NSMutableDictionary new];
    }
    return _QFPostDic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self CellSetting];
    [self initNav];
    
}


-(void)initNav {
    UIButton *SureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SureBtn.frame = CGRectMake(0, 0, 60, 33);
    [SureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [SureBtn addTarget:self action:@selector(filterClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:SureBtn];
}



-(void)filterClick {
    NSLog(@"哈哈");
    
    NSString *url = @"";
    
    
    //从网上获得数据
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    [mgr POST:url parameters:_QFPostDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        self.QFNewDic = responseObject[@"data"];
//        //重载上一个页面的表内容
//        self.uptableData(_QFNewDic);
//        //返回上一个界面
//        [self.navigationController popViewControllerAnimated:YES];
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
    
    
    
    
     self.uptableData(_QFNewDic);
 [self.navigationController popViewControllerAnimated:YES];
}

-(void)CellSetting {
    FormCellInMutiTast *ExpiryTime = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, 64+GroupPadding , Screen_width, CellHeight)];
    ExpiryTime.isOptionalCell = YES ;
    ExpiryTime.title = @"订单状态";
    ExpiryTime.placeHoderString = @"请选择";
    ExpiryTime.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"全部",@"上门取件",@"银行解押",nil];
        select.pikerDataArr = Optdata;
        select.providesPresentationContextTransitionStyle = YES;
        select.definesPresentationContext = YES;
        select.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.preferredContentSize = CGSizeMake(Screen_width/2, 50);
        
        UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
        modalView.tag = ModalViewTag;
        modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
        [self.view addSubview:modalView];
        select.DismissView = ^(){
            [modalView removeFromSuperview];
        };  //取消
        
        select.SureBtnAciton =^(NSString *passString) {
            //这里执行数据保存操作
            ExpiryTime.contentString = passString;
            //   [self.QF_pramaNSM_Dic setObject:passString forKey:@"paytype"];
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [self.view addSubview:ExpiryTime];
    
    
    
    
    FormCellInMutiTast *selectByDate = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ExpiryTime.frame)-CellClipPadding , Screen_width, CellHeight)];
    selectByDate.title = @"下单日期";
    
    UIButton *startLabel = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 100, CellHeight)];

    [startLabel setTitle:@"起始时间" forState:UIControlStateNormal];
    [startLabel addTarget:self action:@selector(SelectDate:) forControlEvents:UIControlEventTouchUpInside];
    startLabel.backgroundColor = [UIColor brownColor];
    self.StartBtn = startLabel;
    [selectByDate addSubview:startLabel];
    
    
    UILabel *To = [[UILabel alloc]initWithFrame:CGRectMake(210, 0, 50, CellHeight)];
    To.text = @"至";
    startLabel.backgroundColor = [UIColor grayColor];
    [selectByDate addSubview:To];
    
    
    UIButton *endLabel = [[UIButton alloc]initWithFrame:CGRectMake(260, 0, 100, CellHeight)];
    [endLabel addTarget:self action:@selector(SelectDate:) forControlEvents:UIControlEventTouchUpInside];
    [endLabel setTitle:@"结束时间" forState:UIControlStateNormal];
    endLabel.backgroundColor = [UIColor blueColor];
    [selectByDate addSubview:endLabel];
    [self.view addSubview:selectByDate];
    
    
    FormCellInMutiTast *OrderNo  = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(selectByDate.frame)- CellClipPadding, Screen_width, CellHeight)];
    OrderNo.title  = @"发布号:";
    OrderNo.placeHoderString = @"请输入";
    [self dealTextfield:OrderNo.contentFiled isTextCenter:YES];
    [self.view addSubview:OrderNo];
    

    FormCellInMutiTast *AISeacher  = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(OrderNo.frame) -CellClipPadding, Screen_width, CellHeight)];
    AISeacher.title  = @"智能搜索:";
    AISeacher.placeHoderString = @"请输入";
    [self dealTextfield:AISeacher.contentFiled isTextCenter:YES];
    [self.view addSubview:AISeacher];
    
}





-(void)SelectDate:(UIButton *)btn{
    NSLog(@"嘻嘻哈哈");
    QFDateSelectStartToEnd *DatePiker = [[QFDateSelectStartToEnd alloc]init];

    
    DatePiker.providesPresentationContextTransitionStyle = YES;
    DatePiker.definesPresentationContext = YES;
    DatePiker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.preferredContentSize = CGSizeMake(Screen_width/2, 50);
    UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    modalView.tag =ModalViewTag;
    modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
    DatePiker.DismissView = ^(){
        [modalView removeFromSuperview];
    };
    
    DatePiker.SureBtnAciton = ^(NSString *str) {
        [btn setTitle:str forState:UIControlStateNormal];
    };
    
    [self.view addSubview:modalView];
    
    [self presentViewController:DatePiker animated:YES completion:nil];

    
}


-(void)dealTextfield :(UITextField *)textfied isTextCenter:(BOOL)isTextCenter{
    if (isTextCenter) {
        textfied.textAlignment = NSTextAlignmentCenter;
    }
    textfied.delegate = self;


}

@end
