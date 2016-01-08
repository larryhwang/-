//
//  SaleOutShangPu.m
//  清房助手
//
//  Created by Larry on 1/7/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
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



#import "SaleOutShangPu.h"





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
#define fangyuanMiaoshuTag 55



#define unCompletedAlertTag 70
#define SuccessAlertTag     71
#define saveAlertTag       72
#define checkLastTag       73



@interface SaleOutShangPu ()<UITextFieldDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,SelectRegionDelegate,UIScrollViewDelegate,CZKeyboardToolbarDelegate ,UIActionSheetDelegate,QBImagePickerControllerDelegate,UIAlertViewDelegate,WMNavigationControllerDelegate>
 {
    NSString *_RegionName;
    NSString *_lastRegionName;
    NSString *_imgs;
    
    NSString *_username;
    NSString *_userId;
    
    float _count;
    float _hasSlidePosition;
    
    int   _lineCount;
    int   _lastCount;
    BOOL  _saveAlertBoolFlag;
    
    BOOL  _isFromSelectDescribePage;
    BOOL  _isLoadLastPara;
}









@end





@implementation SaleOutShangPu

- (void)viewDidLoad {
    [super viewDidLoad];
    
}




#pragma mark - BaseUISetting
-(void)cellSetting {
    self.ScoSwitch = NO;
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHide) name:UIKeyboardWillHideNotification object:nil];
    
    _RegionName=@"";
    
    UIScrollView *main = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -54,Screen_width , Screen_height + 100)];
    
    if (isI5) {
        [main setFrame:CGRectMake(0, -54,Screen_width , Screen_height + 100 + 94)];
    }
    
    main.delegate = self;
    main.indicatorStyle = UIScrollViewIndicatorStyleWhite ;
    
    [main setContentSize:CGSizeMake(Screen_width, Screen_height + 657)];
    
    if (isI5) {
        [main setContentSize:CGSizeMake(Screen_width, Screen_height + 730 + 144)];
    }
    
    if (isI4) {
        [main setContentSize:CGSizeMake(Screen_width, Screen_height + 730 + 200)];
    }
    
    main.backgroundColor = UIColorWithRGBA(233, 233, 233, 1);
    self.mainScrollview = main;
    
    //     UITextField
    
    // Tittle
    EditCell *Title  = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, 60, CellWidth, CellHeight)];
    
    [self.cellMARR addObject:Title];
    
    Title.title  = @"发布标题:";
    Title.placeHoderString = @"请输入标题8字～12字";
    [self dealTextfield:Title.contentFiled isTextCenter:NO];
    
    
    [self.cellMARR addObject:Title];
    Title.updateAction = ^ {
        if (self.LatPostDataDic[@"biaoti"]) {
            Title.contentString = self.LatPostDataDic[@"biaoti"];
        }
    };
    
    [main addSubview:Title];
    
    
    //BuildingName
    EditCell    *BuildingName  = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(Title.frame)+ GroupPadding, Screen_width - CellPaddingToVertical, CellHeight)];
    BuildingName.title = @"商铺名称:";
    BuildingName.placeHoderString = @"1～20字";
    
    
    [self.cellMARR addObject:BuildingName];
    BuildingName.updateAction = ^ {
        if (self.LatPostDataDic[@"mingcheng"]) {
            BuildingName.contentString = self.LatPostDataDic[@"mingcheng"];
        }
        
    };
    
    
    [self dealTextfield:BuildingName.contentFiled isTextCenter:NO];
    [main addSubview:BuildingName];
    
    
    
    //RegionOption
    EditCell    *RegionOption  = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(BuildingName.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    self.RegionTF = RegionOption;
    RegionOption.title = @"区域:";
    RegionOption.isOptionalCell = YES;
    
    [self.cellMARR addObject:RegionOption];
    RegionOption.updateAction = ^ {
        
        NSLog(@"%@",self.LatPostDataDic[@"shengfen"]);
        _RegionName = @"";
        if ( self.LatPostDataDic[@"shengfen"]) {
            _RegionName = [_RegionName stringByAppendingString:[NSString stringWithFormat:@"%@ ",self.LatPostDataDic[@"shengfen"]]];
            NSLog(@"地名1啊:%@",_RegionName);
        }
        
        if ( self.LatPostDataDic[@"shi"]) {
            _RegionName = [_RegionName stringByAppendingString:[NSString stringWithFormat:@"%@ ",self.LatPostDataDic[@"shi"]]];
            NSLog(@"地名2啊:%@",_RegionName);
        }
        
        if ( self.LatPostDataDic[@"qu"]) {
            _RegionName = [_RegionName stringByAppendingString:[NSString stringWithFormat:@"%@ ",self.LatPostDataDic[@"qu"]]];
            NSLog(@"地名3啊:%@",_RegionName);
        }
        
        if ( self.LatPostDataDic[@"region"]) {
            _RegionName = [_RegionName stringByAppendingString:[NSString stringWithFormat:@"%@ ",self.LatPostDataDic[@"region"]]];
            NSLog(@"地名4啊:%@",_RegionName);
        }
        NSLog(@"地名啊:%@",_RegionName);
        RegionOption.contentString = _RegionName;
    };
    
    
    RegionOption.placeHoderString = @"请选择";
    RegionOption.otherAction = ^(){
        NSLog(@"区域选项!");
        RegionOption.contentFiled.text = @"";
        SelectRegionVC *selectRegion = [SelectRegionVC new];
        selectRegion.delegate = self ;
        selectRegion.indexData = self.indexData ;
        self.RegionTF.contentString = @"";
        
        [self.navigationController pushViewController:selectRegion animated:YES];
        NSLog(@"跳转已经执行完");
    };
    [main addSubview:RegionOption];
    
    
    
    
    //DetailedAdress
    EditCell    *DetailedAdress = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(RegionOption.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    DetailedAdress.title = @"详细地址:";
    
    [self.cellMARR addObject:DetailedAdress];
    DetailedAdress.updateAction = ^ {
        DetailedAdress.contentString = self.LatPostDataDic[@"dizhi"];
    };
    
    
    DetailedAdress.placeHoderString = @"请输入详细地址";
    [self dealTextfield:DetailedAdress.contentFiled isTextCenter:NO];
    [main addSubview:DetailedAdress];
    
    //HouseType
    EditCell *HouseType = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(DetailedAdress.frame)+ GroupPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    HouseType.isOptionalCell = YES ;
    HouseType.title = @"商铺类型:";
    HouseType.placeHoderString = @"请选择:";
    
    
    [self.cellMARR addObject:HouseType];
    HouseType.updateAction = ^ {
        if (self.LatPostDataDic[@"leixing"]) {
            HouseType.contentString = self.LatPostDataDic[@"leixing"];
        }
    };
    
    HouseType.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"住宅底商",@"写字楼配套底商",@"酒店底商",@"购物中心综合体",@"商业街商铺",@"卖场",@"沿街门面",nil];
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
    FlatLocation.title = @"楼层:";
    
    
    UITextField *blockTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, 60, 50)];
    blockTF.textAlignment = NSTextAlignmentCenter;
    blockTF.inputAccessoryView = self.keyBoardBar;
    blockTF.delegate = self;
    blockTF.tag = [self.tfArrs count];
    [self.tfArrs addObject:blockTF];
    NSLog(@"%d",blockTF.tag);
    [FlatLocation addSubview:blockTF];
    blockTF.keyboardType = UIKeyboardTypeNumberPad;
    
    UILabel *foorLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockTF.frame)+2,0, 30, 50)];
    
    foorLable.text = @"层";
   [foorLable setTextColor:[UIColor lightGrayColor]];
   [FlatLocation addSubview:foorLable];
    

    
    
    [self.cellMARR addObject:FlatLocation];
    FlatLocation.updateAction = ^ {
        
        if (self.LatPostDataDic[@"louceng"]) {
            blockTF.text = self.LatPostDataDic[@"louceng"];
        }
    };
    [main addSubview:FlatLocation];
    
    
    
    
    //面积
    EditCell    *Area = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(FlatLocation.frame) -CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    Area.title = @"面积:";
    UITextField  *TF_Area = [[UITextField alloc]initWithFrame:CGRectMake(100 +60, 0, 70, 50)];
    TF_Area.keyboardType  = UIKeyboardTypeNumberPad;
    [self dealTextfield:TF_Area isTextCenter:YES];
    [Area addSubview:TF_Area];
    
    UILabel *LABLE_Area = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TF_Area.frame)+30, 0, 50, 50)];
    [LABLE_Area setTextColor:[UIColor lightGrayColor]];
    LABLE_Area.text = @"平米";
    
    
    [self.cellMARR addObject:Area];
    Area.updateAction = ^ {
        if (self.LatPostDataDic[@"mianji"]) {
            TF_Area.text = self.LatPostDataDic[@"mianji"];
        }
        
    };
    
    [Area addSubview:LABLE_Area];
    [main addSubview:Area];
    
    
    EditCell    *GuanLiFei = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(Area.frame) -CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    GuanLiFei.title = @"管理费:";
    UITextField  *TF_GuanLiFei = [[UITextField alloc]initWithFrame:CGRectMake(100 +60, 0, 70, 50)];
    TF_Area.keyboardType  = UIKeyboardTypeNumberPad;
    [self dealTextfield:TF_Area isTextCenter:YES];
    [Area addSubview:TF_GuanLiFei];
    
    UILabel *LABLE_GuanLiFei = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TF_Area.frame)+30, 0, 70, 50)];
   [LABLE_GuanLiFei setTextColor:[UIColor lightGrayColor]];
    LABLE_GuanLiFei.text = @"元/平米";
    
    
    [self.cellMARR addObject:GuanLiFei];
    Area.updateAction = ^ {
        if (self.LatPostDataDic[@"guanlifei"]) {
            TF_Area.text = self.LatPostDataDic[@"guanlifei"];
        }
        
    };
    
    [GuanLiFei addSubview:LABLE_GuanLiFei];
    [main addSubview:GuanLiFei];
    
    
    
    //装修情况(需移动)
    EditCell *Decoration = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(GuanLiFei.frame)-CellClipPadding,Screen_width - CellPaddingToVertical, CellHeight)];
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
    };
    
    [self.cellMARR addObject:Decoration];
    Decoration.updateAction = ^ {
        if (self.LatPostDataDic[@"zhuangxiu"]) {
            Decoration.contentString = self.LatPostDataDic[@"zhuangxiu"];
        }
    };
    [main addSubview:Decoration];
    
    
    //房屋配套
    EditCell *FlatAttachMent = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(Decoration.frame)-CellClipPadding,Screen_width - CellPaddingToVertical, CellHeight)];
    
    //获取上次存取的配套设施
    NSMutableSet *lastSelectAttachMent = [NSMutableSet new];
    
    
    MUtiSelectViewController *select = [[MUtiSelectViewController alloc]init];
    
    FlatAttachMent.isOptionalCell = YES;
    FlatAttachMent.title = @"房屋配套:";
    FlatAttachMent.placeHoderString = @"请选择";
    UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    modalView.tag =ModalViewTag;
    modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
    select.dismissAction = ^{
        [modalView removeFromSuperview];
    };
    
    FlatAttachMent.contentFiled.adjustsFontSizeToFitWidth = YES ;
    FlatAttachMent.otherAction =^{
        
        [self.view addSubview:modalView];
        

        
        
        select.HandleDic = self.PostDataDic;  //字典地址传过去，在select对象里面进行 参数的设置
        
        
        select.HandleTextField = FlatAttachMent.contentFiled;   //输入框的地址传过去，同样在里面进行设置
        select.providesPresentationContextTransitionStyle = YES;
        select.definesPresentationContext = YES;
        select.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:select animated:YES completion:nil];
    };
    
    [self.cellMARR addObject:FlatAttachMent];
    
    
    
    FlatAttachMent.updateAction = ^ {
        if(self.LatPostDataDic[@"meiqi"])
        {
            [lastSelectAttachMent addObject:@"0"];
        }
        
        if (self.LatPostDataDic[@"kuandai"]) {
            [lastSelectAttachMent addObject:@"1"];
        }
        
        if (self.LatPostDataDic[@"dianti"]) {
            [lastSelectAttachMent addObject:@"2"];
        }
        
        if (self.LatPostDataDic[@"tingchechang"]) {
            [lastSelectAttachMent addObject:@"3"];
        }
        
        if (self.LatPostDataDic[@"dianshi"]) {
            [lastSelectAttachMent addObject:@"4"];
        }
        
        if (self.LatPostDataDic[@"jiadian"]) {
            [lastSelectAttachMent addObject:@"5"];
        }
        
        if (self.LatPostDataDic[@"dianhua"]) {
            [lastSelectAttachMent addObject:@"6"];
        }
        
        if (self.LatPostDataDic[@"lingbaoruzhu"]) {
            [lastSelectAttachMent addObject:@"7"];
        }
        
        if([lastSelectAttachMent count]>0) {
            NSLog(@"原来的配套措施:%@",lastSelectAttachMent);
            NSArray  *arr= [NSArray arrayWithObjects:@"天然气",@"宽带",@"电梯",@"停车场",@"电视",@"家电",@"电话",@"拎包入住", nil];
           // select.hasSelectedArrar = lastSelectAttachMent;  //将上一次选设施载入进去，再一次弹窗时，已选的就会变成高亮
            
            NSString *str = @"";
            
            for (NSString *indexStr in lastSelectAttachMent) {
                int index = [indexStr integerValue];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ ",arr[index]]];
            }
            
            FlatAttachMent.contentString = str;
            
            
        }
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
    
    
    [self.cellMARR addObject:LookAroundTime];
    LookAroundTime.updateAction = ^ {
        if (self.LatPostDataDic[@"kanfangtime"]) {
            LookAroundTime.contentString = self.LatPostDataDic[@"kanfangtime"];
        }
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
    UILabel *LABLE_TF_HousePrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TF_HousePrice.frame), 0, 50, 50)];
    [LABLE_TF_HousePrice setTextColor:[UIColor lightGrayColor]];
    LABLE_TF_HousePrice.text = @"万";
    [Price addSubview:LABLE_TF_HousePrice];
    
    [self.cellMARR addObject:Price];
    Price.updateAction = ^ {
        if (self.LatPostDataDic[@"shoujia"]) {
            TF_HousePrice.text = self.LatPostDataDic[@"shoujia"];
        }
    };
    
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
    
    [self.cellMARR addObject:loan];
    loan.updateAction = ^ {
        if (self.LatPostDataDic[@"anjie"]) {
            if([self.LatPostDataDic[@"anjie"] isEqualToString:@"0"] )
            {
                loan.contentString = @"可按揭";
            }else {
                loan.contentString = @"不可按揭";
            }
        }
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
    
    [self.cellMARR addObject:ExpiryTime];
    ExpiryTime.updateAction = ^ {
        if (self.LatPostDataDic[@"youxiaoq"]) {
            if([self.LatPostDataDic[@"youxiaoq"] isEqualToString:@"1"])
            {       ExpiryTime.contentString = @"一个月"; }
            if([self.LatPostDataDic[@"youxiaoq"] isEqualToString:@"3"])
            {       ExpiryTime.contentString = @"三个月"; }
            if([self.LatPostDataDic[@"youxiaoq"] isEqualToString:@"6"])
            {       ExpiryTime.contentString = @"六个月"; }
        }
    };
    [main addSubview:ExpiryTime];
    
    
    
    EditCell *TextDescibe = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(ExpiryTime.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
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
        _isFromSelectDescribePage = YES;
        [self.navigationController pushViewController:FlatDesVcontroller animated:YES];
    };
    
    [self.cellMARR addObject:TextDescibe];
    TextDescibe.updateAction = ^ {
        if (self.LatPostDataDic[@"fangyuanmiaoshu"]) {
            TextDescibe.contentString = self.LatPostDataDic[@"fangyuanmiaoshu"];
        }
    };
    
    [main addSubview:TextDescibe];
    
    
    
    EditCell *picture  = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(TextDescibe.frame)+GroupPadding, CellWidth, CellHeight*.9 + 100 *1)];
    picture.title  = @"房屋预览图片:(最多12张)";
    self.pictureDisplay = picture;
    self.multiImageView = [[JYBMultiImageView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-30, 100)];
    self.multiImageView.delegate = self;
    [picture addSubview:self.multiImageView];
    [self.view addSubview:picture];
    
    
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(picture.frame)+GroupPadding, CellWidth, CellHeight*4 +FootButtonHeight +10 )];
    //  footerView.backgroundColor = [UIColor greenColor];
    [main addSubview:footerView];
    
    // Tittle
    EditCell *ContactName  = [[EditCell alloc]initWithFrame:CGRectMake(0, 0, CellWidth, CellHeight)];
    ContactName.title  = @"联系人:";
    ContactName.placeHoderString = @" ";
    
    ContactName.contentString = _username;      //此处固定，并不可以更改
    ContactName.contentFiled.userInteractionEnabled = NO;
    
    [self dealTextfield:ContactName.contentFiled isTextCenter:NO];
    [self.footArrs addObject:ContactName];
    
    [self.cellMARR addObject:ContactName];
    ContactName.updateAction = ^ {
        
    };
    [footerView addSubview:ContactName];
    
    //
    EditCell *ContactNo  = [[EditCell alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ContactName.frame)-CellClipPadding, CellWidth, CellHeight)];
    ContactNo.title  = @"联系电话:";
    ContactNo.placeHoderString = @" ";
    [self dealTextfield:ContactNo.contentFiled isTextCenter:NO];
    ContactNo.contentFiled.keyboardType = UIKeyboardTypeNumberPad;
    [self.footArrs addObject:ContactNo];
    [self.cellMARR addObject:ContactNo];
    ContactNo.updateAction = ^ {
        if (self.LatPostDataDic[@"usertel"]) {
            ContactNo.contentString = self.LatPostDataDic[@"usertel"];
        }
    };
    [footerView addSubview:ContactNo];
    //
    
    UIButton *SaveBtn =[[UIButton alloc]initWithFrame:CGRectMake(FootButtonPadding, CGRectGetMaxY(ContactNo.frame)+20, FootButtonWidth, FootButtonHeight)];
    [SaveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [SaveBtn addTarget:self action:@selector(DataSave) forControlEvents:UIControlEventTouchUpInside];
    [SaveBtn setBackgroundColor:[UIColor whiteColor]];
    [SaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footerView addSubview:SaveBtn];
    
    NSLog(@"Buton:Y%f",SaveBtn.bounds.origin.y);
    UIButton *PostBtn =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(SaveBtn.frame)+CellWidth-2*(FootButtonWidth+FootButtonPadding), CGRectGetMaxY(ContactNo.frame)+20, FootButtonWidth, FootButtonHeight)];
    [PostBtn setTitle:@"发布" forState:UIControlStateNormal];
    [PostBtn setBackgroundColor:DeafaultColor2];
    [PostBtn addTarget:self action:@selector(LogPostDic) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:PostBtn];
    
    
    self.footerView = footerView;
    
    [main addSubview:picture];
    [self.view addSubview:main];
}


@end
