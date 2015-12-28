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


#define StartBtnTag  10
#define EndBtnTag    20


#define OrderNoTag     30
#define AISeacherTag   40


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
    
    NSString *url = @"http://www.123qf.cn:81/testApp/integrateFindByUser.api?page=1";
    NSLog(@"before : postDic: %@",self.QFPostDic);
    
   // 从网上获得数据
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:_QFPostDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        self.QFNewDic = responseObject;
        //重载上一个页面的表内容
        self.uptableData(_QFNewDic);
        //返回上一个界面
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
     self.uptableData(_QFNewDic);
 [self.navigationController popViewControllerAnimated:YES];
}

-(void)CellSetting {
    FormCellInMutiTast *ExpiryTime = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, 64+GroupPadding , Screen_width, CellHeight)];
    ExpiryTime.isOptionalCell = YES ;
    ExpiryTime.title = @"订单状态:";
    ExpiryTime.placeHoderString = @"不限";
    ExpiryTime.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"全部",@"上门收件",@"银行解押",@"房产评估",@"银行签意向",@"税局交税",@"房产局交旧证",@"客户拿新证",@"抵押新证",@"完成",nil];
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
            //这里可以传中文
            [self.QFPostDic setObject:passString forKey:@"ostatus"];
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [self.view addSubview:ExpiryTime];
    
    
    
    
    FormCellInMutiTast *selectByDate = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ExpiryTime.frame)-CellClipPadding , Screen_width, CellHeight)];
    selectByDate.title = @"下单日期:";
    
    UIButton *startLabel = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 100, CellHeight)];
    
    startLabel.tag = StartBtnTag;
    [startLabel setTitle:@"起始时间" forState:UIControlStateNormal];
    [startLabel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [startLabel addTarget:self action:@selector(SelectDate:) forControlEvents:UIControlEventTouchUpInside];
    self.StartBtn = startLabel;
    [selectByDate addSubview:startLabel];
    
    
    UILabel *To = [[UILabel alloc]initWithFrame:CGRectMake(210, 0, 50, CellHeight)];
    To.text = @"至";
    [selectByDate addSubview:To];
    
    
    UIButton *endLabel = [[UIButton alloc]initWithFrame:CGRectMake(260, 0, 100, CellHeight)];
    [endLabel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    endLabel.tag = EndBtnTag;
    [endLabel addTarget:self action:@selector(SelectDate:) forControlEvents:UIControlEventTouchUpInside];
    [endLabel setTitle:@"结束时间" forState:UIControlStateNormal];
    [selectByDate addSubview:endLabel];
    [self.view addSubview:selectByDate];
    
    
    FormCellInMutiTast *OrderNo  = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(selectByDate.frame)- CellClipPadding, Screen_width, CellHeight)];
    OrderNo.title  = @"订单号:";
    OrderNo.placeHoderString = @"不限";
    OrderNo.contentFiled.tag = OrderNoTag;
    OrderNo.contentFiled.keyboardType = UIKeyboardTypeNumberPad; //TextIP1.keyboardType = UIKeyboardTypeNumberPad
    [self dealTextfield:OrderNo.contentFiled isTextCenter:YES];
    [self.view addSubview:OrderNo];
    

    FormCellInMutiTast *AISeacher  = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(OrderNo.frame) -CellClipPadding, Screen_width, CellHeight)];
    AISeacher.title  = @"智能搜索:";
    AISeacher.placeHoderString = @"不限";
    AISeacher.contentFiled.tag = AISeacherTag;
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
        if (btn.tag ==StartBtnTag) {
            [self.QFPostDic setObject:str forKey:@"ptime"];
        }else {
            [self.QFPostDic setObject:str forKey:@"ntime"];
        }
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


-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *TFcontentStr = textField.text;
    NSLog(@"输入的内容%@",TFcontentStr);
    
    switch (textField.tag) {
        case OrderNoTag:
            [self.QFPostDic setObject:TFcontentStr forKey:@"ordernum"];
            break;
        case AISeacherTag:
            [self.QFPostDic setObject:TFcontentStr forKey:@"blur"];
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"input:%@",text);
    
    switch (textField.tag) {
        case OrderNoTag:
            [self.QFPostDic setObject:text forKey:@"ordernum"];
            break;
        case AISeacherTag:
            [self.QFPostDic setObject:text forKey:@"blur"];
        default:
            break;
    }
    
    return YES;
    
}

@end
