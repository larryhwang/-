//
//  CommitOrderVC.m
//  清房助手
//
//  Created by Larry on 12/22/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//





#import "CommitOrderVC.h"
#import "TypesSelect.h"
#import "EditCell.h"
#import "FormCellInMutiTast.h"
#import "commonFile.h"
#import "AFNetworking.h"
#import "PopSelectViewController.h"
#import "GBWXPayManager.h"
#import "MBProgressHUD+CZ.h"

#define LogRect(_varGRect,_flagStr) ({ NSString *flag =@#_flagStr;  CGRect name = _varGRect; NSLog(@" %@ CGRect: %f,%f,%f,%f", flag,name.origin.x,name.origin.y , name.size.width, name.size.height); })

#define ModalViewTag   99

#define PopViewHeight  160



@interface CommitOrderVC ()<typeSelectdelegate,UITextFieldDelegate,WXApiDelegate,UIAlertViewDelegate>{
    CGRect _Origin;
    CGRect _popOrigin;
    TypesSelect *_popView;
    BOOL _isPop;
    NSInteger TFCountTag;
}

@property (weak, nonatomic) IBOutlet UILabel *QFServiceTypeName;
@property (weak, nonatomic) TypesSelect *QFOptionsView;
@property(nonatomic,strong) UIView *lightModelView;
@property(nonatomic,strong)   NSMutableArray  *tfArrs;
@property (weak, nonatomic) IBOutlet UIButton *QFPostBtn;
@property(nonatomic,strong)  NSMutableDictionary  *QF_pramaNSM_Dic;



@end

@implementation CommitOrderVC



-(NSMutableArray *)tfArrs {
    if (_tfArrs ==nil) {
        _tfArrs = [NSMutableArray new];
    }
    return _tfArrs;
}

-(NSMutableDictionary*)QF_pramaNSM_Dic {
    if (_QF_pramaNSM_Dic ==nil) {
        _QF_pramaNSM_Dic = [NSMutableDictionary new];
    }
    return _QF_pramaNSM_Dic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealWXpayResult:) name:@"WXpayresult" object:nil];
    [self.trikBoard setHidden:YES];
    [self setCell];
    [self settupServiceType];
    
    self.QFPostBtn.backgroundColor = DeafaultColor;
    [self.QFPostBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHide) name:UIKeyboardWillHideNotification object:nil];
}


-(void)setCell {
    
    FormCellInMutiTast *SallerName  = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, 135, ScreenWidth, CellHeight)];
    SallerName.title  = @"卖家姓名:";
    SallerName.placeHoderString = @"";
    [self dealTextfield:SallerName.contentFiled isTextCenter:NO];
    
    [self.view addSubview:SallerName];
    
    
    FormCellInMutiTast *SallerTele  = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(SallerName.frame)-CellClipPadding , ScreenWidth, CellHeight)];
    SallerTele.title  = @"卖家电话:";
    SallerTele.placeHoderString = @"";
    [self dealTextfield:SallerTele.contentFiled isTextCenter:NO];
    [self.view addSubview:SallerTele];
    
    
    FormCellInMutiTast *PurcherName  = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(SallerTele.frame)+ GroupPadding , ScreenWidth, CellHeight)];
    PurcherName.title  = @"买家姓名:";
    PurcherName.placeHoderString = @"";
    [self dealTextfield:PurcherName.contentFiled isTextCenter:NO];
    [self.view addSubview:PurcherName];
    
    
    FormCellInMutiTast *PurcherTeleNo= [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(PurcherName.frame)-CellClipPadding , ScreenWidth, CellHeight)];
    PurcherTeleNo.title  = @"买家电话:";
    PurcherTeleNo.placeHoderString = @"";
    [self dealTextfield:PurcherTeleNo.contentFiled isTextCenter:NO];
    [self.view addSubview:PurcherTeleNo];
    
    
    FormCellInMutiTast *ExpiryTime = [[FormCellInMutiTast alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(PurcherTeleNo.frame)+GroupPadding , Screen_width, CellHeight)];
    ExpiryTime.isOptionalCell = YES ;
    ExpiryTime.title = @"支付方式:";
    ExpiryTime.placeHoderString = @"请选择";
    ExpiryTime.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"微信支付",@"现金刷卡",nil];
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
            ExpiryTime.contentString = passString;
            if ([passString isEqualToString:@"现金刷卡"]) {
                passString = @"0";
            } else {
                passString = @"1";
            }
            [self.QF_pramaNSM_Dic setObject:passString forKey:@"paytype"];
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [self.view addSubview:ExpiryTime];

    
    
    
    //w:120  h:45
    self.QFPostBtn.backgroundColor = DeafaultColor;
    [self.QFPostBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.QFPostBtn setFrame:CGRectMake((ScreenWidth - 120)/2,CGRectGetMaxY(PurcherTeleNo.frame) + GroupPadding + 20 , 120, 45)];

}


-(UITextField *) getFirstResponderTextfield {
    for (UITextField *tf in self.tfArrs ) {
        if (tf.isFirstResponder) {
            NSLog(@"获得的%d",tf.tag);
            return tf;
        }
    }
    return NULL;
}

-(void)willHide {
    NSLog(@"willHide");
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}


//最后一个 键盘位置 : 315  高度： 276 /39        倒数第二个  315   232  83
-(void)willShow:(NSNotification *)notifi{
    UITextField *editingField = [self getFirstResponderTextfield];
    
    
    UIView *cell = [editingField superview];
    NSLog(@"superCell:%@",cell);
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[editingField convertRect: editingField.bounds toView:window];
    NSLog(@"TF : %@,  boudY:%f",editingField ,rect.origin.y);
    
    if ([editingField isKindOfClass:[NSNull class]]) {
        return ;
    }

    CGFloat maxY = rect.origin.y; //cell 位置
    
    //2.获取键盘的y值
    CGRect kbEndFrm = [notifi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbY = kbEndFrm.origin.y;
    
    //3.进行比较
    //计算距离
    NSLog(@"键盘位置:%f,cell高度:%f",kbY,maxY);
    CGFloat delta = kbY - maxY;   //键盘位置－最大位置

    if(delta < 90){//需要往上移
        //添加个动画
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -delta);
        }];
    }
}


-(void)dealTextfield :(UITextField *)textfied isTextCenter:(BOOL)isTextCenter{
    textfied.font = [UIFont systemFontOfSize:15];
    textfied.tag = TFCountTag ++;
    [self.tfArrs addObject:textfied];
    if (isTextCenter) {
        textfied.textAlignment = NSTextAlignmentCenter;
    }
    textfied.delegate = self;
    
}


-(void)settupServiceType{
    // 70 为 CellOne 的y值  45 是高度值
    [self.trikBoard setHidden:YES];
    UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.lightModelView = modalView;
    modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
    [modalView setHidden:YES];
    [self.view addSubview:modalView];
    
    
    
    TypesSelect *popView = [TypesSelect typeselectViewWithFrame:CGRectMake(0, 70 + 45 - PopViewHeight, ScreenWidth, PopViewHeight)];
    popView.delegate = self;
    [popView setHidden:YES];
    self.QFOptionsView = popView;
    
    //更新UI的Block
    popView.changeServiceType = ^(NSString *TypNname){
        self.QFServiceTypeName.text = TypNname;
        //        _isPop =
    };
    
    popView.updateTrickBoard =^(){
        if (self.QFOptionsView.isPop) {
            [self.lightModelView setHidden:NO];
            [self.trikBoard setHidden:NO];
        }else {
            [self.lightModelView setHidden:YES];
            [self.trikBoard setHidden:YES];
        }
        
    };
    
    popView.ShowTrickBoard= ^{
        [self.trikBoard setHidden:NO];
    };
    popView.HideTrickBoard =^{
        [self.trikBoard setHidden:YES];
    };
    
    [self.view addSubview:popView];
    [self.view bringSubviewToFront:popView];
}

/**
 *  隐藏活者显示挡板
 */
-(void)hideOrAppearTrickBoard {
    if (self.QFOptionsView.isPop) {
        [self.trikBoard setHidden:NO];
    } else{
        [self.trikBoard setHidden:YES];
    }
}


- (IBAction)ChosenBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (self.QFOptionsView.isPop) {
        [self.trikBoard setHidden:NO];
        [self.QFOptionsView hide];
    }else {
        [self.QFOptionsView pop];
        
    }


}


-(void)transArrowImg {
    if (self.QFOptionsView.isPop) {
   _QFarrowImg.transform = CGAffineTransformMakeRotation( M_PI/2.0);
    }else {
   _QFarrowImg.transform = CGAffineTransformMakeRotation(0*M_PI/2);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //键盘退出
    [self.view endEditing:YES];
}


- (IBAction)Post:(id)sender {
    //提交数据
    //微信支付
    NSLog(@"POST_ Dic_Prama :%@",self.QF_pramaNSM_Dic);
    NSString *orderno   = [NSString stringWithFormat:@"%ld",time(0)];
    [GBWXPayManager wxpayWithOrderID:orderno orderTitle:@"测试" amount:@"0.01"];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger TF_tag = textField.tag;
    NSString *str = textField.text;
    switch (TF_tag) {
        case 0:
            NSLog(@"卖家姓text：%@",textField.text);
            [self.QF_pramaNSM_Dic setObject:str forKey:@"sellername"];
            break;
        case 1:
            [self.QF_pramaNSM_Dic setObject:str forKey:@"sellertel"];
            NSLog(@"卖家电话text：%@",textField.text);
        case 2:
            [self.QF_pramaNSM_Dic setObject:str forKey:@"buyername"];
            NSLog(@"买家姓名text：%@",textField.text);
        case 3:
            [self.QF_pramaNSM_Dic setObject:str forKey:@"buyertel"];
            NSLog(@"买家电话text：%@",textField.text);
        default:
            break;
    }

}


#pragma mark - 微信支付


- (void)weixinSendPay
{
    
    
    NSString *orderno   = [NSString stringWithFormat:@"%ld",time(0)];
    [GBWXPayManager wxpayWithOrderID:orderno orderTitle:@"测试" amount:@"0.01"];
    
    
    
}

-(void)dealWXpayResult:(NSNotification*)notification{
    NSString*result=notification.object;
    if([result isEqualToString:@"1"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功"
                                                        message:nil
                                                        delegate:self
                                                        cancelButtonTitle:@"好的"otherButtonTitles:nil, nil];
         alert.tag =1;
        [alert show];
        //在这里写支付成功之后的回调操作
        NSLog(@"微信支付成功");
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付失败"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"好的"otherButtonTitles:nil, nil];
       [alert show];
        //在这里写支付失败之后的回调操作
        NSLog(@"微信支付失败");
    }
}
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}




#pragma mark -AlertMethod
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag ==1) {
#warning 这里需要补充数据
        // 成功的弹窗。先上传保存数据，然后跳转返回
        [MBProgressHUD showMessage:@"正在提交"];
        NSString *url = @"";
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        [mgr POST:url parameters:self.QF_pramaNSM_Dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [MBProgressHUD hideHUD];
            if (true) {
                [MBProgressHUD showSuccess:@"上传成功"];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else {
        
    }
}

@end
