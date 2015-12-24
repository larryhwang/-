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
#define LogRect(_varGRect,_flagStr) ({ NSString *flag =@#_flagStr;  CGRect name = _varGRect; NSLog(@" %@ CGRect: %f,%f,%f,%f", flag,name.origin.x,name.origin.y , name.size.width, name.size.height); })

#define ModalViewTag   99

#define PopViewHeight  160



@interface CommitOrderVC ()<typeSelectdelegate,UITextFieldDelegate>{
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



@end

@implementation CommitOrderVC



-(NSMutableArray *)tfArrs {
    if (_tfArrs ==nil) {
        _tfArrs = [NSMutableArray new];
    }
    return _tfArrs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.trikBoard setHidden:YES];
    [self setCell];
    [self settupServiceType];
    
    CGRect jj = self.QFScoView.frame;
    


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
    
    
    UIView *tmp  = [[editingField superview] superview];
    
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
    NSLog(@"选择按钮");
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

@end
