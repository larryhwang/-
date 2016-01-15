//
//  WannaChang.m
//  清房助手
//
//  Created by Larry on 1/15/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "WannaChang.h"

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



#define ModalViewTag   99



#define CustomPriceCellTag 20
#define RoomStyleCellTag   30
#define AcreageCellTag     40

#define RegionTFTag             50
#define HouseTFTypeTag          60
#define PriceRangeTFTag         70
#define AcreageCellTFTag        80
#define LiftCellTFTag           90

#define MinPriceTFTag         100
#define MaxPriceTFTag         110

#define MinAcreageTFTag       120
#define MaxAcreageTFTag       130

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

@interface WannaChang (){
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
    
    
    
    NSString *_MinPriceStr;
    NSString *_MaxPriceStr;
    
    NSString *_MinAcreageStr;
    NSString *_MaxAcreageStr;
    
    NSString *_fangshuStr;
    NSString *_tingshuStr;
    NSString *_toiletsStr;
    NSString *_balconysStr;
    
    NSString *_shengfen;
    NSString *_shi;
    NSString *_qu;
    NSString *_region;
    
    NSString *_completeHuXing;  //已完成的户型拼接
    

}

@end

@implementation WannaChang

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)cellSetting {
    self.ScoSwitch = NO;
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHide) name:UIKeyboardWillHideNotification object:nil];
    
    _RegionName=@"";
    
    QFTableView_Sco *main = [[QFTableView_Sco alloc]initWithFrame:CGRectMake(0, 0,Screen_width , Screen_height + 100)];
    self.main = main;
    if (isI5) {
        [main setFrame:CGRectMake(0, -54,Screen_width , Screen_height + 100 + 94)];
    }
    
    main.delegate = self;
    main.indicatorStyle = UIScrollViewIndicatorStyleWhite ;
    
    [main setContentSize:CGSizeMake(Screen_width, Screen_height + 227)];
    
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
    
    
    
    EditCell *Title  = [[EditCell alloc]init];
    
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
    
    [main.Cell_NSArr addObject:Title];
    
    
    
    
    //RegionOption
    EditCell    *RegionOption  = [[EditCell alloc]init];
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
    [main.Cell_NSArr addObject: RegionOption];
    
    
    //HouseType
    EditCell *HouseType = [[EditCell alloc]init];
    HouseType.isOptionalCell = YES ;
    HouseType.title = @"工厂类型:";
    HouseType.placeHoderString = @"请选择:";
    [self.cellMARR addObject:HouseType];
    HouseType.updateAction = ^ {
        if (self.LatPostDataDic[@"leixing"]) {
            HouseType.contentString = self.LatPostDataDic[@"leixing"];
        }
    };
    
    HouseType.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"标准楼房",@"铁皮房",@"钢结构",@"仓库",@"工业园",nil];
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
    [self.main.Cell_NSArr addObject:HouseType];
    
    
    //面积
    EditCell    *Area = [[EditCell alloc]init];
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
    [main.Cell_NSArr addObject:Area];
    
    
    
    
    
    
    
   
    
    
    
    
    
    
    
    
    
    //房价！！！自定义
    EditCell *AcreageCell = [[EditCell alloc]init];
    AcreageCell.isOptionalCell = YES ;
    
    if (self.iSQiuzu) {
        AcreageCell.title = @"价格范围:";
    } else {
        AcreageCell.title = @"售价:";
    }
    AcreageCell.placeHoderString = @"不限";
    AcreageCell.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"60-90",@"90-120",@"120以上",@"不限",@"自定义",nil];
        if (self.iSQiuzu) {
            Optdata  = [NSArray arrayWithObjects:@"300-600",@"600-800",@"800-1200",@"1200-1600",@"不限",@"自定义",nil];
        }
        select.pikerDataArr = Optdata;
        select.providesPresentationContextTransitionStyle = YES;
        select.definesPresentationContext = YES;
        select.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.preferredContentSize = CGSizeMake(ScreenWidth/2, 50);
        UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        modalView.tag = ModalViewTag;
        modalView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
        [self.view addSubview:modalView];
        select.DismissView = ^(){
            [modalView removeFromSuperview];
        };  //取消
        select.SureBtnAciton    =^(NSString *passString) {
            //如果是自定义则添加新的Cell
            EditCell *CustomsAcreageRange = [[EditCell alloc]init];
            CustomsAcreageRange.tag = AcreageCellTag;
            if([passString isEqualToString: @"自定义"]) {
                CustomsAcreageRange.title = @"自定范围:";
                UITextField *blockTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, 60, 50)];
                blockTF.textAlignment = NSTextAlignmentCenter;
                blockTF.tag = MinAcreageTFTag;
                blockTF.delegate = self;
                [CustomsAcreageRange addSubview:blockTF];
                blockTF.keyboardType = UIKeyboardTypeNumberPad;
                UILabel *blockLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockTF.frame)+2,0, 30, 50)];
                
                blockLable.text = @"－";
                [blockLable setTextColor:[UIColor lightGrayColor]];
                [CustomsAcreageRange addSubview:blockLable];
                
                UITextField *UnitTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockLable.frame)+2, 0, 60, 50)];
                UnitTF.textAlignment = NSTextAlignmentCenter;
                UnitTF.tag = MaxAcreageTFTag;
                UnitTF.delegate = self;
                UnitTF.keyboardType = UIKeyboardTypeNumberPad;
                [CustomsAcreageRange addSubview:UnitTF];
                
                UILabel *UnintLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UnitTF.frame)+2, 0, 60, 50)];
                [UnintLable setTextColor:[UIColor lightGrayColor]];
                UnintLable.text = @"万元";
                if (self.iSQiuzu) {
                    UnintLable.text = @"元";
                }
                
                [CustomsAcreageRange addSubview:UnintLable];
                // [self.main.Cell_NSArr insertObject:CustomsAcreageRange atIndex:4];
                [self addCell:CustomsAcreageRange After:AcreageCell];
                self.main.GroupFlagNoArr = @[@1,@3,@3,@1,@2];
                [main layoutSubviews];
                self.updateBtnsFrame();
            } else {
                //如果不是自定义 ，先保存数据
                if([passString isEqualToString:@"不限"]) {
                    // [self.PostDictionary setObject:@"" forKey:@"mianji"];
                } else {
                    //自己截取最大值和最小值
                    [self getMaxAndMinArea:passString];
                    
                    
                    [self.PostDataDic setObject:_MinAcreageStr forKey:@"fmianji"];
                    [self.PostDataDic setObject:_MaxAcreageStr forKey:@"lmianji"];
                    [self removeCellWithTag:AcreageCellTag];
                }
            }
            AcreageCell.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil]; };
    [main.Cell_NSArr addObject:AcreageCell];
    
    
    EditCell *ExpiryTime = [[EditCell alloc]init];
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
    [main.Cell_NSArr addObject:ExpiryTime];
    
    
    
    EditCell *TextDescibe = [[EditCell alloc]init];
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
    
    [main.Cell_NSArr addObject:TextDescibe];
    
    
    
    
    
    
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
    [main.Cell_NSArr addObject:ContactName];
    
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
    [main.Cell_NSArr addObject:ContactNo];
    //
    
    
    
    main.GroupFlagNoArr = @[@1,@3,@2,@1,@2];  //12
    [self.view addSubview:main];
    
    [self.main layoutSubviews];
    
    // layout后ContactNo才有frame
    UIButton *SaveBtn =[[UIButton alloc]initWithFrame:CGRectMake(FootButtonPadding, CGRectGetMaxY(ContactNo.frame)+20, FootButtonWidth, FootButtonHeight)];
    self.SaveBtn = SaveBtn;
    [SaveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [SaveBtn addTarget:self action:@selector(DataSave) forControlEvents:UIControlEventTouchUpInside];
    [SaveBtn setBackgroundColor:[UIColor whiteColor]];
    [SaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.main addSubview:SaveBtn];
    
    NSLog(@"Buton:Y%f",SaveBtn.bounds.origin.y);
    UIButton *PostBtn =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(SaveBtn.frame)+CellWidth-2*(FootButtonWidth+FootButtonPadding), CGRectGetMaxY(ContactNo.frame)+20, FootButtonWidth, FootButtonHeight)];
    self.PostBtn = PostBtn;
    [PostBtn setTitle:@"发布" forState:UIControlStateNormal];
    [PostBtn setBackgroundColor:DeafaultColor2];
    [PostBtn addTarget:self action:@selector(LogPostDic) forControlEvents:UIControlEventTouchUpInside];
    [self.main addSubview:PostBtn];
    
    self.updateBtnsFrame = ^{
        [self.SaveBtn setFrame:CGRectMake(FootButtonPadding, CGRectGetMaxY(ContactNo.frame)+20, FootButtonWidth, FootButtonHeight)];
        [self.PostBtn setFrame:CGRectMake(CGRectGetMaxX(SaveBtn.frame)+CellWidth-2*(FootButtonWidth+FootButtonPadding), CGRectGetMaxY(ContactNo.frame)+20, FootButtonWidth, FootButtonHeight)];
    };
    
}
@end
