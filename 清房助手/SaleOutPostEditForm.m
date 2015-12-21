//
//  ViewController.m
//  用scollview做表格
//
//  Created by Larry on 15/11/14.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "SaleOutPostEditForm.h"
#import "EditCell.h"
#import "SelectRegionVC.h"
#import "LoacationNameTool.h"
#import "LocateTool.h"
#import "PopSelectViewController.h"
#import "CZKeyboardToolbar.h"
#import "MUtiSelectViewController.h"
#import <JYBMultiImageSelector/JYBMultiImageSelector.h>
#import "QBImagePickerController.h"
#import <Photos/Photos.h>
#import "FlatDescirbeVcontroller.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "MBProgressHUD+CZ.h"
#import "commonFile.h"
#import "WMNavigationController.h"
#import "AppDelegate.h"

#define FootButtonWidth    (CellWidth-100)/2
#define FootButtonHeight   40
#define FootButtonPadding  10



#define ModalViewTag   99

#define biaotiTag       0
#define mingchengTag    1
#define dizhiTag        2
#define dongTag         3
#define danyuanTag      4
#define loucengTag      5
#define zongloucengTag  6
#define mianjiTag       7
#define fangshuTag      8
#define tingshuTag      9
#define toiletsTag      10
#define balconysTag     11
#define fanglingTag     12
#define shoujiaTag      13
#define userNameTag         14                  //参数文档中未见


#define usertelTag      15
#define OwnerTag        16
#define OwnerName       17               //参数文档中未见

#define leiXingTag      50   //类型
#define zhuangxiuTag    51   //装修情况
#define chaoxiangTag    52   //类型
#define kanfangtimeTag  53   //看房时间
#define anjieTag        54   //按揭



#define unCompletedAlertTag 70
#define SuccessAlertTag     71
#define saveAlertTag       72





@interface SaleOutPostEditForm ()<UITextFieldDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,SelectRegionDelegate,UIScrollViewDelegate,CZKeyboardToolbarDelegate ,UIActionSheetDelegate,QBImagePickerControllerDelegate,UIAlertViewDelegate,WMNavigationControllerDelegate>{
    NSArray *_cleanIndexCollect;
    NSString *_NowCity;
    NSString *_RegionDetailByAppend;
    NSString *_RegionName;
    NSString *_lastRegionName;
    NSString *_imgs;
    float _count;
    float _hasSlidePosition;
    
    int   _lineCount;
    int   _lastCount;
    BOOL  _saveAlertBoolFlag;
    
    BOOL  _isFromSelectPro;
}
 //UIScrollView
@property(nonatomic,strong)   EditCell  *pictureDisplay;
@property (nonatomic, strong) JYBMultiImageView *multiImageView;
@property (nonatomic, copy)   UIView *(^viewGetter)(NSString *imageName);
@property (nonatomic, copy)   void (^blockTest)(void);
@property (nonatomic,strong)  NSDictionary *indexData;
@property(nonatomic,strong)   NSMutableArray  *tfArrs;
@property(nonatomic,strong)   NSMutableArray  *footArrs;
@property(nonatomic,strong)   NSMutableDictionary  *PostDataDic;
@property(nonatomic,strong)   CZKeyboardToolbar  *keyBoardBar;
@property(nonatomic,strong)   UIScrollView  *mainScrollview;
@property(nonatomic,assign)   BOOL ScoSwitch;
@property(nonatomic,strong)   NSMutableSet  *hasSelectedAttachMent;
@property(nonatomic,strong)   UIView  *footerView;
@property(nonatomic,weak)     NSMutableArray *haSelectedImgs_MARR;
@property(nonatomic,strong)   NSMutableArray  *SelectedImgsData_MARR;



@property(nonatomic,strong)  EditCell  *RegionTF;
@end

@implementation SaleOutPostEditForm

-(NSMutableDictionary *)PostDataDic {
    if (_PostDataDic==nil) {
        _PostDataDic =[NSMutableDictionary new];
    }
    return _PostDataDic;
}


-(NSMutableArray *)footArrs {
    if (_footArrs ==nil) {
        _footArrs = [NSMutableArray new];
    }
    return _footArrs;
}


-(NSMutableSet *)hasSelectedAttachMent {
    if (_hasSelectedAttachMent == nil) {
        _hasSelectedAttachMent = [NSMutableSet new];
    }
    return _hasSelectedAttachMent;
}


-(NSMutableArray *)tfArrs {
    if (_tfArrs ==nil) {
        _tfArrs = [NSMutableArray new];
    }
    return _tfArrs;
}



-(NSMutableArray*)SelectedImgsData_MARR {
    if (_SelectedImgsData_MARR ==nil) {
        _SelectedImgsData_MARR = [NSMutableArray new];
    }
    return _SelectedImgsData_MARR;
}



-(CZKeyboardToolbar *)keyBoardBar {
    if (_keyBoardBar == nil) {
        _keyBoardBar = [CZKeyboardToolbar toolbar];
        _keyBoardBar.kbDelegate = self;
    }
    return _keyBoardBar;
}


#pragma mark 键盘以及表视图的滚动
-(void)keyboardToolbar:(CZKeyboardToolbar *)toolbar btndidSelected:(UIBarButtonItem *)item{
    switch (item.tag) {
        case 0://上一个
            [self previous];
            break;
        case 1://下一个
            [self next];
            //NSLog(@"%ld",)
            break;
        case 2://完成
            _ScoSwitch = YES;
            [self.view endEditing:YES];
            break;
            
        default:
            break;
    }
}

-(void)previous{
    //获取当前焦点
    NSInteger currentIndex = [self indexOfFirstResponder];
    NSLog(@"%ld",currentIndex);
    
    self.keyBoardBar.nextItem.enabled = YES;
    //获取上一个索引
    NSInteger previouesIndex = currentIndex - 1;
    
    //不当响应者
    [self.tfArrs[currentIndex] resignFirstResponder];
    
    //索引要大于等0
    if (previouesIndex >= 0) {
        [self.tfArrs[previouesIndex] becomeFirstResponder];
    }
    
    
    
    
}
-(void)next{
    //获取当前焦点
    NSInteger currentIndex = [self indexOfFirstResponder];
    self.keyBoardBar.previousItem.enabled = YES;
    
    //不当响应者
    [self.tfArrs[currentIndex] resignFirstResponder];
    
    //设置下一个焦点
    if (currentIndex != -1 && currentIndex != self.tfArrs.count -1) {
        NSInteger nextIndex = currentIndex + 1;
        [self.tfArrs[nextIndex] becomeFirstResponder];
    }
}



-(void)willHide {
    NSLog(@"willHide");
    
    
    if (_ScoSwitch) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
        _ScoSwitch = NO;
        return ;
    }
    
    UITextField *editingField   = [self getFirstResponderTextfield];
    NSInteger  lastEditedTag1   = [self indexOfFirstResponder] + 1;
    NSInteger  lastEditedTag2   = [self indexOfFirstResponder] - 1;
    
    NSLog(@"1:%d,2:%d",lastEditedTag1,lastEditedTag2);
    
    if (lastEditedTag1 <=[self.tfArrs count] && lastEditedTag2 >0) {
        if (lastEditedTag1 ==[self.tfArrs count]) {
            return ;
        }
        
        UITextField *lastTextFiled1 = [self.tfArrs objectAtIndex:lastEditedTag1];
        UITextField *lastTextFiled2 = [self.tfArrs objectAtIndex:lastEditedTag2];
        NSLog(@"t1:%d T2%d E:%d",lastTextFiled1.isFirstResponder,lastTextFiled2.isFirstResponder,editingField.isFirstResponder);
        if ([lastTextFiled1 superview]==[editingField superview] || [lastTextFiled2 superview]==[editingField superview]) {
            NSLog(@"DEBUG");
            return ;
        }
    }
    
    

    


//    [UIView animateWithDuration:0.25 animations:^{
//        self.view.transform = CGAffineTransformIdentity;
//    }];
}


-(void)willShow:(NSNotification *)notifi{
    UITextField *editingField = [self getFirstResponderTextfield];
    
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[editingField convertRect: editingField.bounds toView:window];
        NSLog(@"boudY:%f",rect.origin.y);
    
    
    UIView *tmp  = [[editingField superview] superview];

    if ([editingField isKindOfClass:[NSNull class]]) {
        return ;
    }
    UIView *currentCell;
    if (editingField.tag >13) {
        currentCell = [[editingField superview] superview];
    }else {
        currentCell = [editingField superview];
    }
    
    
    NSLog(@"%@",currentCell.subviews);
    //键盘一弹出，就判断上一个，下一个按钮可不可用
    NSLog(@"willsour:%d",editingField.tag);
    if(editingField.tag == 0){
        self.keyBoardBar.previousItem.enabled = NO;
    }
    
    
    if(editingField.tag == self.tfArrs.count ){
        self.keyBoardBar.nextItem.enabled = NO;
    }
    
  //  CGFloat maxY = CGRectGetMaxY(currentCell.frame) + self.mainScrollview.frame.origin.y + 40 ;
    CGFloat maxY = rect.origin.y; //相对屏幕位置
    NSLog(@"最大值的 view:%f,table:%f",CGRectGetMaxY(currentCell.frame),self.mainScrollview.frame.origin.y);
    
    //2.获取键盘的y值
    CGRect kbEndFrm = [notifi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbY = kbEndFrm.origin.y;
    
    //3.进行比较
    //计算距离
    NSLog(@"键盘位置:%f,最大位置进度:%f",kbY,maxY);
    CGFloat delta = kbY - maxY;   //键盘位置－最大位置
    delta = delta - 120;
    if(delta < 80){//需要往上移
        //添加个动画
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, delta);
        }];
    }
}

-(NSInteger ) indexOfFirstResponder {
    for (UITextField *tf in self.tfArrs) {
        if (tf.isFirstResponder) {
            NSLog(@"index有内鬼");
        }
    }
    
    
    for (UITextField *tf in self.tfArrs ) {
        if (tf.isFirstResponder) {
            return tf.tag;
        }
    }
    return -1;
}

-(void)addInputView {
    for (UITextField *tf in self.tfArrs ) {
        if (tf.inputAccessoryView ==nil) {
            tf.inputAccessoryView = self.keyBoardBar;
        }
    }
}

-(UITextField *) getFirstResponderTextfield {
    for (UITextField *tf in self.tfArrs ) {
        if (tf.inputAccessoryView ==nil) {
            tf.inputAccessoryView = self.keyBoardBar;
        }
        if (tf.isFirstResponder) {
            NSLog(@"获得的%d",tf.tag);
            return tf;
        }
    }
    return NULL;
}

-(void)dealTextfield :(UITextField *)textfied isTextCenter:(BOOL)isTextCenter{
    if (isTextCenter) {
        textfied.textAlignment = NSTextAlignmentCenter;
    }
    textfied.delegate = self;
    textfied.inputAccessoryView = self.keyBoardBar;
    textfied.tag = [self.tfArrs count];
    [self.tfArrs addObject:textfied];

}
-(void)saveDataAlert {
    NSLog(@"已拦截");
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
//    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
//    [btn1 setTitle:@"哇咔咔" forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
//    btn1.backgroundColor = [UIColor blueColor];
//    [btn1 addTarget:self action:@selector(saveDataAlert) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *customItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
//    self.navigationItem.leftBarButtonItem = customItem;
    
    
    
    
    
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self cellSetting];
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postBtn setFrame:CGRectMake(200, 1180, 40, 50)];

    
    
    
    
    
    
    
    
    
    
    
    
    [postBtn setTitle:@"上传" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(LogPostDic) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:postBtn];
    [self addInputView];
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    btn.backgroundColor = [UIColor redColor];
   [self.view addSubview:btn];
    NSLog(@"%@",self.navigationController);

}


#pragma mark -pop_delegate


/**
 *  在这里拦截，发布页面的返回，并触发弹窗，但在区域选择的界面中是 使用 popViewControllerAnimated 返回时
 也会触发弹窗，所以现在 在这里 做一个 _isFromSelectPro 设置一个标记
 *
 *  @param navigationBar <#navigationBar description#>
 *  @param item          <#item description#>
 *
 *  @return <#return value description#>
 */


-(BOOL)controllerWillPopHandler {
    
    if (_isFromSelectPro) {
        _isFromSelectPro  = NO;
        return NO;   //如果从定位界面跳转过来，就不弹窗
    } else {
        NSLog(@"TopVC in nav :%@",self.navigationController.topViewController);
        
        UIAlertView *AW = [[UIAlertView alloc]initWithTitle:@"提示"
                                                    message:@"资料未保存"
                                                   delegate:self
                                          cancelButtonTitle:@"放弃编辑"
                                          otherButtonTitles:@"留在此页", nil];
        AW.tag = saveAlertTag;
        [AW show];
        return NO;
    }
    

}


#pragma mark - BaseUISetting



-(void)cellSetting {
    _ScoSwitch = NO;
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHide) name:UIKeyboardWillHideNotification object:nil];
    
    
    _RegionName=@"";
    [self netInitialLog];
    
    UIScrollView *main = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -54,Screen_width , Screen_height + 100)];
    
    if (isI5) {
        [main setFrame:CGRectMake(0, -54,Screen_width , Screen_height + 100 + 64)];
    }
    
    main.delegate = self;
    main.indicatorStyle = UIScrollViewIndicatorStyleWhite ;
    
    [main setContentSize:CGSizeMake(Screen_width, Screen_height + 630)];
    
  //      [main setContentSize:CGSizeMake(Screen_width, Screen_height + 830)];
    if (isI5) {
        [main setContentSize:CGSizeMake(Screen_width, Screen_height + 730 + 64)];
    }
    
    main.backgroundColor = UIColorWithRGBA(233, 233, 233, 1);
    self.mainScrollview = main;
    
    //     UITextField
    
    // Tittle
    EditCell *Title  = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, 60, CellWidth, CellHeight)];
    Title.title  = @"发布标题:";
    Title.placeHoderString = @"请输入标题8字～12字";
    [self dealTextfield:Title.contentFiled isTextCenter:NO];
    [main addSubview:Title];
    
    
    //BuildingName
    EditCell    *BuildingName  = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(Title.frame)+ GroupPadding, Screen_width - CellPaddingToVertical, CellHeight)];
    BuildingName.title = @"楼盘名称:";
    BuildingName.placeHoderString = @"1～20字";
    [self dealTextfield:BuildingName.contentFiled isTextCenter:NO];
    [main addSubview:BuildingName];
    
    //RegionOption
    EditCell    *RegionOption  = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(BuildingName.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    _RegionTF = RegionOption;
    RegionOption.title = @"区域:";
    RegionOption.isOptionalCell = YES;
    RegionOption.placeHoderString = @"请选择";
    RegionOption.otherAction = ^(){
        NSLog(@"区域选项!");
        SelectRegionVC *selectRegion = [SelectRegionVC new];
        selectRegion.delegate = self ;
        selectRegion.indexData = _indexData ;
        _RegionTF.contentString = @"";
        _isFromSelectPro = YES;
        [self.navigationController pushViewController:selectRegion animated:YES];

        NSLog(@"跳转已经执行完");
        
    };
    [main addSubview:RegionOption];
    
    //DetailedAdress
    EditCell    *DetailedAdress = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(RegionOption.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    DetailedAdress.title = @"详细地址:";
    DetailedAdress.placeHoderString = @"请输入详细地址";
    [self dealTextfield:DetailedAdress.contentFiled isTextCenter:NO];
    [main addSubview:DetailedAdress];
    
    //HouseType
    EditCell *HouseType = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(DetailedAdress.frame)+ GroupPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    HouseType.isOptionalCell = YES ;
    HouseType.title = @"房屋类型:";
    HouseType.placeHoderString = @"请选择:";
    HouseType.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"平层",@"整栋",@"复式",@"公寓",@"别墅",nil];
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
            HouseType.contentString = passString;
            [self.PostDataDic setObject:passString forKey:@"leixing"];
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [main addSubview:HouseType];
    
    
    EditCell *FlatLocation = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(HouseType.frame)-CellClipPadding, Screen_width - CellPaddingToVertical, CellHeight)];
    FlatLocation.title = @"位置:";
    
    UITextField *blockTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, 60, 50)];
    blockTF.textAlignment = NSTextAlignmentCenter;
    blockTF.inputAccessoryView = self.keyBoardBar;
    blockTF.delegate = self;
    blockTF.tag = [self.tfArrs count];
    [self.tfArrs addObject:blockTF];
    NSLog(@"%d",blockTF.tag);
    [FlatLocation addSubview:blockTF];
    blockTF.keyboardType = UIKeyboardTypeNumberPad;
    UILabel *blockLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockTF.frame)+2,0, 30, 50)];
    
    blockLable.text = @"栋";
    [blockLable setTextColor:[UIColor lightGrayColor]];
    [FlatLocation addSubview:blockLable];
    
    UITextField *UnitTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockLable.frame)+2, 0, 60, 50)];
    UnitTF.textAlignment = NSTextAlignmentCenter;
    UnitTF.delegate = self;
    UnitTF.tag = [self.tfArrs count];
    [self.tfArrs addObject:UnitTF];
    UnitTF.keyboardType = UIKeyboardTypeNumberPad;
    [FlatLocation addSubview:UnitTF];
    
    UILabel *UnintLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UnitTF.frame)+2, 0, 60, 50)];
    [UnintLable setTextColor:[UIColor lightGrayColor]];
    UnintLable.text = @"单元";
    [FlatLocation addSubview:UnintLable];
    
    [main addSubview:FlatLocation];
    
    
    //FlatNo ,第  层  第  单元
    EditCell    *FlatNo = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(FlatLocation.frame) + GroupPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    FlatNo.title = @"楼层:";
    
    
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(100,0, 30, 50)];
    lable1.text = @"第";
    [lable1 setTextColor:[UIColor lightGrayColor]];
    [FlatNo addSubview:lable1];
    
    UITextField *TF1= [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lable1.frame), 0, 60, 50)];
    TF1.textAlignment = NSTextAlignmentCenter;
    TF1.delegate = self;
    TF1.tag = [self.tfArrs count];
    [self.tfArrs addObject:TF1];
    [FlatNo addSubview:TF1];
    TF1.keyboardType = UIKeyboardTypeNumberPad;
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TF1.frame),0, 30, 50)];
    lable2.text = @"层";
    [lable2 setTextColor:[UIColor lightGrayColor]];
    [FlatNo addSubview:lable2];
    
    UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lable2.frame),0, 30, 50)];
    lable3.text = @"共";
    [lable3 setTextColor:[UIColor lightGrayColor]];
    [FlatNo addSubview:lable3];
    
    UITextField *TF2= [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lable3.frame), 0, 60, 50)];
    TF2.textAlignment = NSTextAlignmentCenter;
    TF2.delegate = self ;
    TF2.tag = [self.tfArrs count];
    [self.tfArrs addObject:TF2];
    [FlatNo addSubview:TF2];
    TF2.keyboardType = UIKeyboardTypeNumberPad;
    
    UILabel *lable4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TF2.frame),0, 30, 50)];
    lable4.text = @"层";
    [lable4 setTextColor:[UIColor lightGrayColor]];
    [FlatNo addSubview:lable4];
    
    [main addSubview:FlatNo];
    
    //面积
    EditCell    *Area = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(FlatNo.frame) -CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    Area.title = @"面积:";
    UITextField  *TF_Area = [[UITextField alloc]initWithFrame:CGRectMake(100 +60, 0, 70, 50)];
    [self dealTextfield:TF_Area isTextCenter:YES];
    [Area addSubview:TF_Area];
    
    UILabel *LABLE_Area = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TF_Area.frame)+50, 0, 50, 50)];
    [LABLE_Area setTextColor:[UIColor lightGrayColor]];
    LABLE_Area.text = @"平方";
    
    [Area addSubview:LABLE_Area];
    [main addSubview:Area];
    
    
    //户型
    EditCell    *RoomStyle = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(Area.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    RoomStyle.title = @"户型:";
    
    UITextField  *RoomTextfield = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, 40, 50)];
    [self dealTextfield:RoomTextfield isTextCenter:YES];
    
    [RoomStyle addSubview:RoomTextfield];
    
    UILabel *RoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(RoomTextfield.frame)+5, 0, 20, 50)];
    
    [RoomLabel setTextColor:[UIColor lightGrayColor]];
    RoomLabel.text = @"室";
    [RoomStyle addSubview:RoomLabel];
    
    UITextField *TingTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(RoomLabel.frame)-5, 0, 35, 50)];
    [self dealTextfield:TingTextfield isTextCenter:YES];
    
    [RoomStyle addSubview:TingTextfield];
    
    UILabel *TingLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TingTextfield.frame), 0, 20, 50)];
    TingLabel.text = @"厅";
    [TingLabel setTextColor:[UIColor lightGrayColor]];
    [RoomStyle addSubview:TingLabel];
    
    UITextField *WeiTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TingLabel.frame), 0, 30, 50)];
    [self dealTextfield:WeiTextfield isTextCenter:YES];
    
    [RoomStyle addSubview:WeiTextfield];
    UILabel *WeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(WeiTextfield.frame), 0, 20, 50)];
    WeiLabel.text = @"卫";
    [WeiLabel setTextColor:[UIColor lightGrayColor]];
    [RoomStyle addSubview:WeiLabel];
    
    
    UITextField *YangTaiTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(WeiLabel.frame), 0, 30, 50)];
    [self dealTextfield:YangTaiTextfield isTextCenter:YES];
    
    [RoomStyle addSubview:YangTaiTextfield];
    UILabel *YangTaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(YangTaiTextfield.frame), 0, 40, 50)];
    YangTaiLabel.text = @"阳台";
    [YangTaiLabel setTextColor:[UIColor lightGrayColor]];
    [RoomStyle addSubview:YangTaiLabel];
    [main addSubview:RoomStyle];
    
    
    //装修情况(需移动)
    EditCell *Decoration = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(RoomStyle.frame)-CellClipPadding,Screen_width - CellPaddingToVertical, CellHeight)];
    Decoration.isOptionalCell = YES;
    Decoration.title = @"装修情况:";
    Decoration.placeHoderString = @"请选择";
    
    Decoration.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"毛坯房",@"简装修",@"精装修",@"中等装修",nil];
        select.pikerDataArr = Optdata;
        select.providesPresentationContextTransitionStyle = YES;
        select.definesPresentationContext = YES;
        select.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.preferredContentSize = CGSizeMake(Screen_width/2, 50);
        
        UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
        modalView.tag =ModalViewTag;
        modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
        [self.view addSubview:modalView];
        select.DismissView = ^(){
            [modalView removeFromSuperview];
        };  //取消
        
        select.SureBtnAciton =^(NSString *passString) {
            Decoration.contentString = passString;
            [self.PostDataDic setObject:passString forKey:@"zhuangxiu"];
        };
        [self presentViewController:select animated:YES completion:nil];
        NSLog(@"表格位置:%f",Decoration.frame.origin.y);
        //        NSLog(@":%f",select.frame.origin.y);
    };
    [main addSubview:Decoration];
    
    
    
    //房龄
    EditCell    *HouseAge = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(Decoration.frame) -CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    HouseAge.title = @"房龄:";
    UITextField  *TF_HouseAge = [[UITextField alloc]initWithFrame:CGRectMake(100 +60, 0, 110, 50)];
    TF_HouseAge.keyboardType  = UIKeyboardTypeNumberPad ;
    [self dealTextfield:TF_HouseAge isTextCenter:YES];
    [HouseAge addSubview:TF_HouseAge];
    UILabel *LABLE_TF_HouseAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TF_HouseAge.frame)+50, 0, 50, 50)];
    [LABLE_TF_HouseAge setTextColor:[UIColor lightGrayColor]];
    LABLE_TF_HouseAge.text = @"年";
    [HouseAge addSubview:LABLE_TF_HouseAge];
    [main addSubview:HouseAge];
    
    
    
    
    //朝向
    EditCell *orientation = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(HouseAge.frame)-CellClipPadding,Screen_width - CellPaddingToVertical, CellHeight)];
    orientation.isOptionalCell = YES;
    orientation.title = @"朝向:";
    orientation.placeHoderString = @"请选择";
    orientation.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"南北通透",@"东",@"南",@"西",@"北",@"东南",@"西南",@"西北",@"东北",nil];
        select.pikerDataArr = Optdata;
        select.providesPresentationContextTransitionStyle = YES;
        select.definesPresentationContext = YES;
        select.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.preferredContentSize = CGSizeMake(Screen_width/2, 50);
        
        UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
        modalView.tag =ModalViewTag;
        modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
        [self.view addSubview:modalView];
        select.DismissView = ^(){
            [modalView removeFromSuperview];
        };  //取消
        select.SureBtnAciton =^(NSString *passString) {
            orientation.contentString = passString;
            [self.PostDataDic setObject:passString forKey:@"chaoxiang"];
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [main addSubview:orientation];
    
    
    
    //房屋配套
    EditCell *FlatAttachMent = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(orientation.frame)-CellClipPadding,Screen_width - CellPaddingToVertical, CellHeight)];
    FlatAttachMent.isOptionalCell = YES;
    FlatAttachMent.title = @"房屋配套:";
    FlatAttachMent.placeHoderString = @"请选择";
    FlatAttachMent.contentFiled.adjustsFontSizeToFitWidth = YES ;
    FlatAttachMent.otherAction =^{
        MUtiSelectViewController *select = [[MUtiSelectViewController alloc]init];
        select.hasSelectedArrar =  self.hasSelectedAttachMent;
        select.HandleDic = self.PostDataDic;  //字典
        select.HandleTextField = FlatAttachMent.contentFiled;
        select.providesPresentationContextTransitionStyle = YES;
        select.definesPresentationContext = YES;
        select.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:select animated:YES completion:nil];
    };
    [main addSubview:FlatAttachMent];
    
    
    //看房时间
    EditCell *LookAroundTime = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(FlatAttachMent.frame)+ GroupPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    LookAroundTime.isOptionalCell = YES ;
    LookAroundTime.title = @"看房时间:";
    LookAroundTime.placeHoderString = @"请选择";
    LookAroundTime.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"随时看房",@"非工作时间",@"电话预约",nil];
        select.pikerDataArr = Optdata;
        select.providesPresentationContextTransitionStyle = YES;
        select.definesPresentationContext = YES;
        select.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.preferredContentSize = CGSizeMake(Screen_width/2, 50);
        
        UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
        modalView.tag =ModalViewTag;
        modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
        [self.view addSubview:modalView];
        select.DismissView = ^(){
            [modalView removeFromSuperview];
        };  //取消
        
        select.SureBtnAciton =^(NSString *passString) {
            LookAroundTime.contentString = passString;
            [self.PostDataDic setObject:passString forKey:@"kanfangtime"];
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [main addSubview:LookAroundTime];
    
    
    
    //房价
    EditCell    *Price= [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(LookAroundTime.frame) -CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    Price.title = @"售价:";
    UITextField  *TF_HousePrice = [[UITextField alloc]initWithFrame:CGRectMake(100 +60, 0, 130, 50)];
    //TF_HousePrice.backgroundColor = [UIColor orangeColor];
    TF_HousePrice.keyboardType  = UIKeyboardTypeNumberPad ;
    [self dealTextfield:TF_HousePrice isTextCenter:YES];
    [Price addSubview:TF_HousePrice];
    UILabel *LABLE_TF_HousePrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TF_HousePrice.frame)+50, 0, 50, 50)];
    [LABLE_TF_HousePrice setTextColor:[UIColor lightGrayColor]];
    LABLE_TF_HousePrice.text = @"万";
    [Price addSubview:LABLE_TF_HousePrice];
    [main addSubview:Price];
    
    
    EditCell *loan = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(Price.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    loan.isOptionalCell = YES ;
    loan.title = @"按揭:";
    loan.placeHoderString = @"请选择";
    loan.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"可按揭",@"不可按揭",nil];
        select.pikerDataArr = Optdata;
        select.providesPresentationContextTransitionStyle = YES;
        select.definesPresentationContext = YES;
        select.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.preferredContentSize = CGSizeMake(Screen_width/2, 50);
        UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
        modalView.tag =ModalViewTag;
        modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
        [self.view addSubview:modalView];
        select.DismissView = ^(){
            [modalView removeFromSuperview];
        };  //取消
        
        select.SureBtnAciton =^(NSString *passString) {
            loan.contentString = passString;
            if([passString isEqualToString:@"可按揭"]){
                passString =@"1";
            }else {
                passString =@"0";
            }
            [self.PostDataDic setObject:passString forKey:@"anjie"];
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [main addSubview:loan];
    
    
    
    
    EditCell *ExpiryTime = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(loan.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    ExpiryTime.isOptionalCell = YES ;
    ExpiryTime.title = @"有效期:";
    ExpiryTime.placeHoderString = @"请选择";
    ExpiryTime.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"一个月",@"三个月",@"半年",nil];
        select.pikerDataArr = Optdata;
        select.providesPresentationContextTransitionStyle = YES;
        select.definesPresentationContext = YES;
        select.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.preferredContentSize = CGSizeMake(Screen_width/2, 50);
        
        UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
        modalView.tag =ModalViewTag;
        modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
        [self.view addSubview:modalView];
        select.DismissView = ^(){
            [modalView removeFromSuperview];
        };  //取消
        
        select.SureBtnAciton =^(NSString *passString) {
            ExpiryTime.contentString = passString;
            if ([passString isEqualToString:@"一个月"]) {
                 passString = @"1";
            } else if ([passString isEqualToString:@"三个月"]) {
                 passString = @"3";
            } else {
                 passString = @"6";
            }
            [self.PostDataDic setObject:passString forKey:@"youxiaoq"];
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [main addSubview:ExpiryTime];
    
    
    
    EditCell *TextDescibe = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(loan.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    TextDescibe.isOptionalCell = YES ;
    TextDescibe.title = @"房屋描述:";
    TextDescibe.placeHoderString = @"至少10个字";
    TextDescibe.otherAction =^{
#warning 跳转到另一个界面进行填写
        FlatDescirbeVcontroller  *FlatDesVcontroller = [[FlatDescirbeVcontroller alloc]init];
        FlatDesVcontroller.HandleNSDic = self.PostDataDic ;
        FlatDesVcontroller.UIUpdate =^( NSString *str) {
            TextDescibe.contentFiled.text = str ;
            TextDescibe.contentFiled.adjustsFontSizeToFitWidth = YES ;
        };
        [self.navigationController pushViewController:FlatDesVcontroller animated:YES];
    };
    [main addSubview:TextDescibe];
    
    
    
    EditCell *picture  = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(TextDescibe.frame)+GroupPadding, CellWidth, CellHeight*.9 + 100 *1)];
    picture.title  = @"房屋预览图片:(最多12张)";
    _pictureDisplay = picture;
    self.multiImageView = [[JYBMultiImageView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-30, 100)];
    self.multiImageView.delegate = self;
  //  self.multiImageView.backgroundColor = [UIColor brownColor];
    [picture addSubview:self.multiImageView];
    [self.view addSubview:picture];
    
    
    

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(picture.frame)+GroupPadding, CellWidth, CellHeight*4 +FootButtonHeight +10 )];
      //  footerView.backgroundColor = [UIColor greenColor];
    [main addSubview:footerView];
    
    // Tittle
    EditCell *ContactName  = [[EditCell alloc]initWithFrame:CGRectMake(0, 0, CellWidth, CellHeight)];
    ContactName.title  = @"联系人:";
    ContactName.placeHoderString = @" ";
    [self dealTextfield:ContactName.contentFiled isTextCenter:NO];
    [self.footArrs addObject:ContactName];
    [footerView addSubview:ContactName];
    //
    EditCell *ContactNo  = [[EditCell alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ContactName.frame)-CellClipPadding, CellWidth, CellHeight)];
    ContactNo.title  = @"联系电话:";
    ContactNo.placeHoderString = @" ";
    [self dealTextfield:ContactNo.contentFiled isTextCenter:NO];
    [self.footArrs addObject:ContactNo];
    [footerView addSubview:ContactNo];
    //
    //
    EditCell *OnwnerName  = [[EditCell alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ContactNo.frame)-CellClipPadding, CellWidth, CellHeight)];
    OnwnerName.title  = @"业主姓名:";
    OnwnerName.placeHoderString = @" ";
    [self dealTextfield:OnwnerName.contentFiled isTextCenter:NO];
    [self.footArrs addObject:OnwnerName];
    [footerView addSubview:OnwnerName];
    //
    //
    EditCell *OwnerTele  = [[EditCell alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(OnwnerName.frame)-CellClipPadding, CellWidth, CellHeight)];
    OwnerTele.title  = @"业主电话:";
    OwnerTele.placeHoderString = @" ";
    [self dealTextfield:OwnerTele.contentFiled isTextCenter:NO];
    [self.footArrs addObject:OwnerTele];
    [footerView addSubview:OwnerTele];
    
    
    //UIView
    
    UIButton *SaveBtn =[[UIButton alloc]initWithFrame:CGRectMake(FootButtonPadding, CGRectGetMaxY(OwnerTele.frame)+20, FootButtonWidth, FootButtonHeight)];
    [SaveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [SaveBtn addTarget:self action:@selector(LogPostDic) forControlEvents:UIControlEventTouchUpInside];
    [SaveBtn setBackgroundColor:[UIColor brownColor]];
    [footerView addSubview:SaveBtn];
    
    NSLog(@"Buton:Y%f",SaveBtn.bounds.origin.y);
    UIButton *PostBtn =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(SaveBtn.frame)+CellWidth-2*(FootButtonWidth+FootButtonPadding), CGRectGetMaxY(OwnerTele.frame)+20, FootButtonWidth, FootButtonHeight)];
    [PostBtn setTitle:@"发布" forState:UIControlStateNormal];
    [PostBtn setBackgroundColor:[UIColor redColor]];
    [PostBtn addTarget:self action:@selector(LogPostDic) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:PostBtn];
    
    
    self.footerView = footerView;
    
    [main addSubview:picture];
    [self.view addSubview:main];
}

-(void)LogPostDic {
    [self.PostDataDic setObject:@"15018639039" forKey:@"userid"];
    [self.PostDataDic setObject:@"1" forKey:@"isfangyuan"];
    [self.PostDataDic setObject:@"true" forKey:@"zushou"];
    [self.PostDataDic setObject:@"0" forKey:@"fenlei"];
    if (![self checkPostData:self.PostDataDic]) {
        UIAlertView *AW = [[UIAlertView alloc]initWithTitle:@"所填资料不完整"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"朕知道了", nil];
        AW.tag = unCompletedAlertTag;
        [AW show];
        return;
    }
    [MBProgressHUD showMessage:@"正在发布"];
    NSLog(@"上传数据:%@",_PostDataDic);
    NSLog(@"已选状态%@",_hasSelectedAttachMent);

    
    //区域选择拼补
   NSMutableArray *Quarray =(NSMutableArray *) [_RegionTF.contentFiled.text componentsSeparatedByString:@" "];
    if ([Quarray count] > 2) {
        [Quarray removeObject:[Quarray lastObject]];
        NSArray *SqlTitleArr = [NSArray arrayWithObjects:@"shengfen",@"shi",@"qu",@"region",nil];
        [Quarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.PostDataDic setObject:obj forKey:SqlTitleArr[idx]];  //设置
        }];
    }
    
    //格式化图片
    for (UIImage *img in self.haSelectedImgs_MARR) {
        NSData *imageData =  UIImageJPEGRepresentation(img,.8);
       [self.SelectedImgsData_MARR addObject:imageData];
    }
    
    //先把图片上传过去
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url2 = @"http://www.123qf.cn:81/testApp/file/upload.front?userID=15018639039";
    [manager POST:url2 parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSData *imgData in self.SelectedImgsData_MARR) {
          [formData appendPartWithFileData:imgData name:@"1.jpg" fileName:@"1.jpg" mimeType:@"image/jpg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"第一次提交数据%@",responseObject);
        _imgs = responseObject[@"data"];
        [self.PostDataDic setObject:_imgs forKey:@"tupian"];
        [self PostAll]; //POST提交所有信息
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败%@",error);
    }];
    //获得图片名称，在把整个字典传过去
}


-(void)PostAll {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url4 = @"http://www.123qf.cn:81/testApp/user/releaseFKYuan.api";
    NSLog(@"最后参数:%@",self.PostDataDic);
    NSDictionary *parameters =@{
                                @"userid":@"15018639039",
                                @"isfangyuan":@"1",
                                @"zushou":@"true",
                                @"usertel":@"1398888",
                                @"fenlei" :@"0",
                                @"shengfen":@"广东省",
                                @"shi":@"惠州",
                                @"qu":@"惠城区",
                                @"region":@"河南岸",
                                @"dizhi":@"演达大道",
                                @"biaoti":@"哇咔咔业主急售",
                                @"mingcheng":@"名称",
                                @"leixing":@"类型",
                                @"mianji":@"100",
                                @"shoujia":@"80",
                                @"anjie":@"true",
                                @"kanfangtime":@"仅限周末",
                                @"fangyuanmiaoshu":@"地段好，升值空间大",
                                @"tupian":_imgs,
                                @"youxiaoq":@"1",
                                @"zhuangtai":@"0",
                                @"ownertel":@"业主电话",
                                @"dong":@"栋",
                                @"danyuan":@"单元",
                                @"louceng":@"3",
                                @"zonglouceng":@"30",
                                @"fangshu":@"4",
                                @"tingshu":@"1",
                                @"toilets":@"2",
                                @"balconys":@"2",
                                @"zhuangxiu":@"豪华",
                                @"fangling":@"10",
                                @"chaoxiang":@"朝向",
                                @"meiqi":@"true",
                                @"kuandai":@"true",
                                @"dianti":@"true",
                                @"tingchechang":@"true",
                                @"dianshi":@"true",
                                @"jiadian":@"true",
                                @"dianhua":@"true",
                                @"lingbaoruzhu":@"true"
                                };

    [self.PostDataDic setObject:@"15018639039" forKey:@"usertel"];
    [manager POST:url4 parameters:self.PostDataDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"第二次提交的返回数据%@",responseObject);
        NSString *sucessFlagStr = responseObject[@"code"];
        NSInteger sucessFlagInt = [sucessFlagStr intValue];
        if (sucessFlagInt == 1) {
         [MBProgressHUD hideHUD];
            //在这里弹窗,确定并返回
            UIAlertView *AW = [[UIAlertView alloc]initWithTitle:@"发布成功"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
            [AW setFrame:CGRectMake(20, 20, 150, 60)];
            [AW show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

//              @"zufangxingshi":@"押三付一"
-(BOOL)checkPostData :(NSMutableDictionary *) dicTionNary {
    __block  BOOL flag = YES;
    NSArray *ar = [dicTionNary allValues];
    NSLog(@"检查:%@",ar);   //被检查
    for (NSString *str in ar) {
        if ([str isEqualToString:@""] || str ==nil) {
            flag = NO;
            break;
        }
    }
    
    for (UITextField *tf in self.tfArrs) {
        NSString *str = tf.text;
        if ([str isEqualToString:@""] || str ==nil) {
            flag = NO;
            break;
        }
    }
    return flag;
}

#pragma mark -RegionOptDelegate
-(void)appendName:(NSString *)locationName {
    //长区域拼接
    NSRange isHave = [_lastRegionName rangeOfString:locationName];
    if (!(isHave.length)) {
        _RegionName  = [_RegionName stringByAppendingString:[NSString stringWithFormat:@"%@ ",locationName]];
        _RegionTF.contentString = _RegionName;
        _lastRegionName = _RegionName;
    }
}


-(void)netInitialLog {
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    NSString *completeUrl = @"http://www.123qf.cn:81/testApp/user/loginUser.front?userid=15018639039&psword=5798161";
    [mgr POST:completeUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"登录信息%@",responseObject);
        LocateTool *Locat = [LocateTool sharedLocateTool];
        Locat.update = ^(NSString *cityName){
            NSUserDefaults *DefaultHandle = [NSUserDefaults standardUserDefaults];
           [DefaultHandle setObject:cityName forKey:CurrentCityName];
        };
        [Locat StartGetCityName];
        NSLog(@"%@",[Locat GetCityName]);
        
        AppDelegate  *app = [UIApplication sharedApplication].delegate;
        
        
       // NSDictionary *test =[LoacationNameTool dictionaryWithUrl:@"http://www.123qf.cn:81/testApp/area/selectArea.api?parentid=0"];
        _indexData   = app.provnceIndexDic;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark DealingTextfield



#pragma mark RegionOptDelegate
-(void)updateTableData {
}


#pragma mark ScollviewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;  {
    _hasSlidePosition = scrollView.contentOffset.y;
    if ([self.tfArrs count]>10) {
        for (UITextField *tf in self.tfArrs) {
            if (tf.isFirstResponder) {
                _ScoSwitch = YES ;
                break ;
            }
        }
    }
    [self.view endEditing:YES];
}

#pragma mark UITextfiledDelegate



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger EditedTextFieldTag = textField.tag ;
    switch (EditedTextFieldTag) {
          case biaotiTag:
            NSLog(@"标题是:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"biaoti"];
            break;
          case mingchengTag:
              NSLog(@"名称是:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"mingcheng"];
             break;
          case dizhiTag:
               NSLog(@"地址:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"dizhi"];
             break;
          case dongTag:
               NSLog(@"栋数是:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"dong"];
            break;
          case danyuanTag:
               NSLog(@"单元:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"danyuan"];
             break;
          case loucengTag:
               NSLog(@"楼层:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"louceng"];
             break;
          case zongloucengTag:
               NSLog(@"总楼层:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"zonglouceng"];
            break;
        case mianjiTag:
            NSLog(@"面积:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"mianji"];
            break;
            
        case fangshuTag:
            NSLog(@"房数:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"fangshu"];
            break;
            
        case tingshuTag:
            NSLog(@"厅数:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"tingshu"];
            break;
            
        case toiletsTag:
            NSLog(@"卫生间:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"toilets"];
            break;
            
        case balconysTag:
            NSLog(@"阳台数:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"balconys"];
            break;
            
        case fanglingTag:
            NSLog(@"房龄:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"fangling"];
            break;
            
        case shoujiaTag:
            NSLog(@"售价:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"shoujia"];
            break;
            
#define userNameTag         14                  //参数文档中未见
            
            
#define usertelTag      15
#define OwnerTag        16
#define OwnerName       17
            
            //usertel
            
        case userNameTag:
            NSLog(@"联系人姓名:%@",textField.text);
#warning 这里只显示，不允许修改
            [self.PostDataDic setObject:textField.text forKey:@"ownername"];
            break;
            
        case usertelTag:
            NSLog(@"联系人电话:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"usertel"];
            break;
            
        case OwnerTag:
            NSLog(@"业主姓名:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"ownername"];
            break;
            
        case OwnerName:
            NSLog(@"业主电话:%@",textField.text);
            [self.PostDataDic setObject:textField.text forKey:@"ownertel"];
            break;
        
        default:
            break;
    }

}



//相册代理方法

#pragma mark -
#pragma mark - Control

/**
 *  拍照
 *  相册
 *  @param showCamare
 */
- (void)showImagePickerWithCamare:(BOOL)showCamare
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (showCamare) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        NSLog(@"不支持拍照");
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

/**
 *  调起可多选图片相册，选择图片
 */
- (void)multiSelectImagesFromPhotoLibrary
{
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 6;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - Delegate
- (void)addButtonDidTap
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"手机相册", nil];
    [sheet showInView:self.view];
}

#pragma mark -点击图片放大或者删除
- (void)multiImageBtn:(NSInteger)index withImage:(UIImage *)image
{
    // 图片放大显示，或删除等操作
    NSLog(@"index => %ld", (long)index);
    NSArray * arr = @[@"01.jpg",@"02.jpg",@"03.jpg",@"04.jpg",@"05.jpg"];
    
}


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self showImagePickerWithCamare:YES];
            break;
        case 1:
            [self multiSelectImagesFromPhotoLibrary];
            break;
    }
}


#pragma mark - ELCImagePickerController Delegate
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in info) {
            UIImage *image = dic[UIImagePickerControllerOriginalImage];
            [array addObject:image];
        }
        [self addMoreImages:array];
    }];
}


- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
    [self addMoreImages:@[info[UIImagePickerControllerOriginalImage]]];
    }];
}

#pragma mark QBImagePickerControllerDelegate  类库中的代理方法
//确定
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    for (PHAsset *asset in assets) {
        [self getImgData:asset];
        _count ++;
    }
    //重置frame
    NSLog(@"张数:%f",_count);
    _lineCount =  ceilf(_count /4);
    NSLog(@"前行数:%d",_lineCount);
    NSString *tt = [NSString stringWithFormat:@"%f",_count];
    NSInteger xx =[tt integerValue];
    if (xx % 4 ==0) {
        _lineCount =_lineCount +1;
    }
    if(_count ==12) _lineCount =3;
    NSLog(@"行数:%d",_lineCount);
    [_pictureDisplay setFrame:CGRectMake(CGRectGetMinX(_pictureDisplay.frame), CGRectGetMinY(_pictureDisplay.frame), CGRectGetWidth(_pictureDisplay.frame), CellHeight * .8 +(_lineCount) * 100)];
    [self UpdatepartsFrame];
    NSLog(@"NewHeight:%f",CGRectGetHeight(self.multiImageView.frame));
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//取消
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}




-(void)getImgData:(PHAsset *)asset {   //转成NSData再获取
    PHImageManager *imageMannager = [PHImageManager defaultManager];
    [imageMannager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image= [[UIImage alloc]initWithData:imageData];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:image];
        [self addMoreImages:array];
    }];
}




#pragma mark - Logic

/**
 *  添加新图片到显示区域
 *
 *  @param images 图片数组
 */
- (void)addMoreImages:(NSArray *)images
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.multiImageView.images_MARR];
   [arr addObjectsFromArray:images];
   [self.multiImageView.images_MARR removeAllObjects];
    self.multiImageView.images_MARR = arr;
    self.haSelectedImgs_MARR = self.multiImageView.images_MARR;
}

-(void)UpdatepartsFrame {
    //底部四个移动
    [_footerView setFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(_pictureDisplay.frame)+GroupPadding, CellWidth, CellHeight*4 + 50) ];
    NSLog(@"最后行数:%d",_lineCount);
    [self.mainScrollview setContentSize:CGSizeMake(Screen_width, Screen_height + 50 + 630 + 95 * (_lineCount - 1))];

}


#pragma mark －alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {

    NSLog(@"弹窗序号:%d",buttonIndex);
    if(alertView.tag == SuccessAlertTag) {
       [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
    if(alertView.tag == saveAlertTag) {
      if(buttonIndex == 0) {
            NSLog(@"放弃");
    [self.navigationController popViewControllerAnimated:YES];
          
        } else {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            NSLog(@"取消");
        }
    }
    //执行跳转
}

@end
