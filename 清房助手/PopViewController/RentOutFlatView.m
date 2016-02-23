//
//  RentOutFlatView.m
//  清房助手
//
//  Created by Larry on 1/12/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "RentOutFlatView.h"
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



#define FootButtonWidth    (CellWidth-100)/2
#define FootButtonHeight   40
#define FootButtonPadding  10


#define unCompletedAlertTag 70
#define SuccessAlertTag     71
#define saveAlertTag       72
#define checkLastTag       73


@interface RentOutFlatView (){
    
    NSString *_RegionName;
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

@implementation RentOutFlatView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.PostDataDic setObject:@"true" forKey:@"zushou"];
}

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
    BuildingName.title = @"楼盘名称:";
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
    HouseType.title = @"房屋类型:";
    HouseType.placeHoderString = @"请选择:";
    [self.cellMARR addObject:HouseType];
    HouseType.updateAction = ^ {
        if (self.LatPostDataDic[@"leixing"]) {
            HouseType.contentString = self.LatPostDataDic[@"leixing"];
        }
    };
    
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
    
    
    EditCell *RentType = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(HouseType.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    RentType.isOptionalCell = YES ;
    RentType.title = @"租房类型:";
    RentType.placeHoderString = @"请选择:";
    [self.cellMARR addObject:HouseType];
    RentType.updateAction = ^ {
        if (self.LatPostDataDic[@"leixing"]) {
            RentType.contentString = self.LatPostDataDic[@"leixing"];
        }
    };
    
    RentType.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"整租",@"合租",nil];
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
            RentType.contentString = passString;
            [self.PostDataDic setObject:passString forKey:@"leixing"];
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [main addSubview:RentType];
    
    
    
    
    EditCell *FlatLocation = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(RentType.frame)-CellClipPadding, Screen_width - CellPaddingToVertical, CellHeight)];
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
    
    
    [self.cellMARR addObject:FlatLocation];
    FlatLocation.updateAction = ^ {
        
        if (self.LatPostDataDic[@"dong"]) {
            blockTF.text = self.LatPostDataDic[@"dong"];
        }
        
        if (self.LatPostDataDic[@"danyuan"]) {
            UnitTF.text  = self.LatPostDataDic[@"danyuan"];
        }
    };
    
    
    [main addSubview:FlatLocation];
    
    
    //FlatNo ,第  层  第  单元
    EditCell    *FlatNo = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(FlatLocation.frame) -CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    FlatNo.title = @"楼层:";
    
    
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(85,0, 30, 50)];
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
    
    UITextField *TF2= [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lable3.frame), 0, 50, 50)];
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
    
    
    [self.cellMARR addObject:FlatNo];
    FlatNo.updateAction = ^ {
        
        if (self.LatPostDataDic[@"louceng"]) {
            TF1.text = self.LatPostDataDic[@"louceng"];
        }
        
        if (self.LatPostDataDic[@"zonglouceng"]) {
            TF2.text  = self.LatPostDataDic[@"zonglouceng"];
        }
        
    };
    
    [main addSubview:FlatNo];
    
    
    //面积
    EditCell    *Area = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(FlatNo.frame) -CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    Area.title = @"面积:";
    UITextField  *TF_Area = [[UITextField alloc]initWithFrame:CGRectMake(100 +60, 0, 70, 50)];
    TF_Area.keyboardType  = UIKeyboardTypeNumberPad;
    [self dealTextfield:TF_Area isTextCenter:YES];
    [Area addSubview:TF_Area];
    
    UILabel *LABLE_Area = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TF_Area.frame)+30, 0, 50, 50)];
    [LABLE_Area setTextColor:[UIColor lightGrayColor]];
    LABLE_Area.text = @"平方";
    
    
    [self.cellMARR addObject:Area];
    Area.updateAction = ^ {
        if (self.LatPostDataDic[@"mianji"]) {
            TF_Area.text = self.LatPostDataDic[@"mianji"];
        }
        
    };
    
    [Area addSubview:LABLE_Area];
    [main addSubview:Area];
    
    
    //户型
    EditCell    *RoomStyle = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(Area.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    RoomStyle.title = @"户型:";
    
    UITextField  *RoomTextfield = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, 40, 50)];
    RoomTextfield.keyboardType  = UIKeyboardTypeNumberPad ;
    [self dealTextfield:RoomTextfield isTextCenter:YES];
    
    [RoomStyle addSubview:RoomTextfield];
    
    UILabel *RoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(RoomTextfield.frame), 0, 20, 50)];
    
    [RoomLabel setTextColor:[UIColor lightGrayColor]];
    RoomLabel.text = @"室";
    [RoomStyle addSubview:RoomLabel];
    
    UITextField *TingTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(RoomLabel.frame)-10, 0, 35, 50)];
    TingTextfield.keyboardType  = UIKeyboardTypeNumberPad ;
    [self dealTextfield:TingTextfield isTextCenter:YES];
    
    [RoomStyle addSubview:TingTextfield];
    
    UILabel *TingLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TingTextfield.frame), 0, 20, 50)];
    TingLabel.text = @"厅";
    [TingLabel setTextColor:[UIColor lightGrayColor]];
    [RoomStyle addSubview:TingLabel];
    
    UITextField *WeiTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TingLabel.frame), 0, 30, 50)];
    WeiTextfield.keyboardType  = UIKeyboardTypeNumberPad ;
    [self dealTextfield:WeiTextfield isTextCenter:YES];
    
    [RoomStyle addSubview:WeiTextfield];
    UILabel *WeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(WeiTextfield.frame), 0, 20, 50)];
    WeiLabel.text = @"卫";
    [WeiLabel setTextColor:[UIColor lightGrayColor]];
    [RoomStyle addSubview:WeiLabel];
    
    
    UITextField *YangTaiTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(WeiLabel.frame), 0, 30, 50)];
    YangTaiTextfield.keyboardType  = UIKeyboardTypeNumberPad;
    [self dealTextfield:YangTaiTextfield isTextCenter:YES];
    
    [RoomStyle addSubview:YangTaiTextfield];
    UILabel *YangTaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(YangTaiTextfield.frame), 0, 40, 50)];
    YangTaiLabel.text = @"阳台";
    [YangTaiLabel setTextColor:[UIColor lightGrayColor]];
    [RoomStyle addSubview:YangTaiLabel];
    
    
    
    [self.cellMARR addObject:RoomStyle];
    RoomStyle.updateAction = ^ {
        
        if(self.LatPostDataDic[@"fangshu"]) {
            NSLog(@"fangshu:%@",self.LatPostDataDic[@"fangshu"]);
            RoomTextfield.text = self.LatPostDataDic[@"fangshu"];  //  出现精装修
        }
        
        if (self.LatPostDataDic[@"tingshu"]) {
            TingTextfield.text = self.LatPostDataDic[@"tingshu"];
        }
        
        if (self.LatPostDataDic[@"toilets"]) {
            WeiTextfield.text  = self.LatPostDataDic[@"toilets"];
        }
        
        if (self.LatPostDataDic[@"balconys"]) {
            YangTaiTextfield.text = self.LatPostDataDic[@"balconys"];
        }
        
    };
    
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
    };
    
    [self.cellMARR addObject:Decoration];
    Decoration.updateAction = ^ {
        if (self.LatPostDataDic[@"zhuangxiu"]) {
            Decoration.contentString = self.LatPostDataDic[@"zhuangxiu"];
        }
    };
    
    [main addSubview:Decoration];
    
    
    
    //房龄
    EditCell    *HouseAge = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2,  CGRectGetMaxY(Decoration.frame) -CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
    HouseAge.title = @"房龄:";
    UITextField  *TF_HouseAge = [[UITextField alloc]initWithFrame:CGRectMake(100 +60, 0, 110, 50)];
    TF_HouseAge.keyboardType  = UIKeyboardTypeNumberPad ;
    [self dealTextfield:TF_HouseAge isTextCenter:YES];
    [HouseAge addSubview:TF_HouseAge];
    UILabel *LABLE_TF_HouseAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TF_HouseAge.frame)+20, 0, 50, 50)];
    [LABLE_TF_HouseAge setTextColor:[UIColor lightGrayColor]];
    LABLE_TF_HouseAge.text = @"年";
    [HouseAge addSubview:LABLE_TF_HouseAge];
    
    [self.cellMARR addObject:HouseAge];
    HouseAge.updateAction = ^ {
        if (self.LatPostDataDic[@"fangling"]) {
            TF_HouseAge.text = self.LatPostDataDic[@"fangling"];
        }
    };
    
    
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
    
    [self.cellMARR addObject:orientation];
    orientation.updateAction = ^ {
        if (self.LatPostDataDic[@"chaoxiang"]) {
            orientation.contentString = self.LatPostDataDic[@"chaoxiang"];
        }
    };
    
    [main addSubview:orientation];
    
    
    
    //房屋配套
    EditCell *FlatAttachMent = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(orientation.frame)-CellClipPadding,Screen_width - CellPaddingToVertical, CellHeight)];
    __weak __typeof(FlatAttachMent)weakFlatAttachMent = FlatAttachMent;
    //获取上次存取的配套设施
    NSMutableSet *lastSelectAttachMent = [NSMutableSet new];
    
    
    MUtiSelectViewController *select = [[MUtiSelectViewController alloc]init];
    select.OptBtnTitlesArra = [NSArray arrayWithObjects:@"天然气",@"宽带",@"电梯",@"停车场",@"电视",@"家电",@"电话",@"拎包入住", nil];
    select.OptBtnSqlTittles_NARR =[NSArray arrayWithObjects:@"meiqi",@"kuandai",@"dianti",@"tingchechang",@"dianshi",@"jiadian",@"dianhua",@"lingbaoruzhu", nil];
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
        select.HandleTextField = weakFlatAttachMent.contentFiled;   //输入框的地址传过去，同样在里面进行设置
        select.providesPresentationContextTransitionStyle = YES;
        select.definesPresentationContext = YES;
        select.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:select animated:YES completion:nil];
    };
    
    [self.cellMARR addObject:FlatAttachMent];
    
    
    
    FlatAttachMent.updateAction = ^ {
        //:@"天然气",@"宽带",@"电梯",@"停车场",@"电视",@"家电",@"电话",@"拎包入住", nil];
        if(self.LatPostDataDic[@"meiqi"])
        {
            [lastSelectAttachMent addObject:@"天然气"];
        }
        
        if (self.LatPostDataDic[@"kuandai"]) {
            [lastSelectAttachMent addObject:@"宽带"];
        }
        
        if (self.LatPostDataDic[@"dianti"]) {
            [lastSelectAttachMent addObject:@"电梯"];
        }
        
        if (self.LatPostDataDic[@"tingchechang"]) {
            [lastSelectAttachMent addObject:@"停车场"];
        }
        
        if (self.LatPostDataDic[@"dianshi"]) {
            [lastSelectAttachMent addObject:@"电视"];
        }
        
        if (self.LatPostDataDic[@"jiadian"]) {
            [lastSelectAttachMent addObject:@"家电"];
        }
        
        if (self.LatPostDataDic[@"dianhua"]) {
            [lastSelectAttachMent addObject:@"电话"];
        }
        
        if (self.LatPostDataDic[@"lingbaoruzhu"]) {
            [lastSelectAttachMent addObject:@"拎包入住"];
        }
        
        if([lastSelectAttachMent count]>0) {
            NSLog(@"原来的配套措施:%@",lastSelectAttachMent);
            
            select.hasSelectedSets = lastSelectAttachMent;  //将上一次选设施载入进去，再一次弹窗时，已选的就会变成高亮
            
            NSString *str = @"";
            
            for (NSString *indexStr in lastSelectAttachMent) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ ",indexStr]];
            }
            
            weakFlatAttachMent.contentString = str;
            
            
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
    Price.title = @"租金:";
    UITextField  *TF_HousePrice = [[UITextField alloc]initWithFrame:CGRectMake(100 +60, 0, 130, 50)];
    //TF_HousePrice.backgroundColor = [UIColor orangeColor];
    TF_HousePrice.keyboardType  = UIKeyboardTypeNumberPad ;
    [self dealTextfield:TF_HousePrice isTextCenter:YES];
    [Price addSubview:TF_HousePrice];
    UILabel *LABLE_TF_HousePrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TF_HousePrice.frame), 0, 50, 50)];
    [LABLE_TF_HousePrice setTextColor:[UIColor lightGrayColor]];
    LABLE_TF_HousePrice.text = @"元/月";
    [Price addSubview:LABLE_TF_HousePrice];
    
    [self.cellMARR addObject:Price];
    Price.updateAction = ^ {
        if (self.LatPostDataDic[@"shoujia"]) {
            TF_HousePrice.text = self.LatPostDataDic[@"shoujia"];
        }
    };
    [main addSubview:Price];
    
    

    
    
    EditCell *ExpiryTime = [[EditCell alloc]initWithFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(Price.frame)-CellClipPadding , Screen_width - CellPaddingToVertical, CellHeight)];
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
            [self.PostDataDic setObject:passString forKey:@"youxiaoqi"];
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    
    [self.cellMARR addObject:ExpiryTime];
    ExpiryTime.updateAction = ^ {
        if (self.LatPostDataDic[@"youxiaoqi"]) {
            if([self.LatPostDataDic[@"youxiaoqi"] isEqualToString:@"1"])
            {       ExpiryTime.contentString = @"一个月"; }
            if([self.LatPostDataDic[@"youxiaoqi"] isEqualToString:@"3"])
            {       ExpiryTime.contentString = @"三个月"; }
            if([self.LatPostDataDic[@"youxiaoqi"] isEqualToString:@"6"])
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
    [main addSubview:footerView];
    
    // Tittle
    EditCell *ContactName  = [[EditCell alloc]initWithFrame:CGRectMake(0, 0, CellWidth, CellHeight)];
    ContactName.title  = @"联系人:";
    ContactName.placeHoderString = @" ";
    
    ContactName.contentString = self.username;      //此处固定，并不可以更改
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


-(void)appendName:(NSString *)locationName {
    //长区域拼接
    NSRange isHave = [_RegionName rangeOfString:locationName];
    if (!(isHave.length)) {
        _RegionName  = [_RegionName stringByAppendingString:[NSString stringWithFormat:@"%@ ",locationName]];
        self.RegionTF.contentString = _RegionName;
        self.lastRegionName = _RegionName;
    }
}


-(BOOL)controllerWillPopHandler {
    NSLog(@"%d",[[self.PostDataDic allKeys] count]);
    
    if ([[self.PostDataDic allKeys] count] ==0 ) {  //如果加载了上次数据或者 已经被编辑了
        if(_isLoadLastPara ==YES) {
            NSLog(@"TopVC in nav :%@",self.navigationController.topViewController);
            
            UIAlertView *AW = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"资料尚未保存"
                                                       delegate:self
                                              cancelButtonTitle:@"放弃编辑"
                                              otherButtonTitles:@"留在此页", @"保存并退出",nil];
            AW.tag = saveAlertTag;
            [AW show];
            return NO;
        }
        _isLoadLastPara = NO;    //复位
        return YES;
    }
    
    NSLog(@"TopVC in nav :%@",self.navigationController.topViewController);
    
    
    if (_isFromSelectDescribePage) {
        _isFromSelectDescribePage = NO;
        return NO;
    }
    
    UIAlertView *AW = [[UIAlertView alloc]initWithTitle:nil
                                                message:@"资料尚未保存"
                                               delegate:self
                                      cancelButtonTitle:@"放弃编辑"
                                      otherButtonTitles:@"留在此页", @"保存并退出",nil];
    AW.tag = saveAlertTag;
    [AW show];
    return NO;
    
}



@end
