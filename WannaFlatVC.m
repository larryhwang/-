//
//  WannaFlatVC.m
//  清房助手
//
//  Created by Larry on 1/13/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "WannaFlatVC.h"
#import  "QFTableView_Sco.h"
#import  "EditCell.h"
#import  "AppDelegate.h"
#import  "SelectRegionVC.h"
#import  "PopSelectViewController.h"
#import  "AFNetworking/AFHTTPRequestOperationManager.h"
#import  "MBProgressHUD+CZ.h"
#import "commonFile.h"
#import "FlatDescirbeVcontroller.h"

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

@interface WannaFlatVC (){
    
    
    
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

    
    
    
    
    
    NSString *_lastRegionName;
    
    
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
@property(nonatomic,strong)  NSArray  *AdressKeyArr;
@property(nonatomic,strong)    QFTableView_Sco *main;
@property(nonatomic,weak) UIButton *SaveBtn;
@property(nonatomic,weak) UIButton *PostBtn;

@property(nonatomic,copy) void (^updateBtnsFrame) (void);
@end

@implementation WannaFlatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
    
    
    
    //户型
    EditCell    *RoomStyle = [[EditCell alloc]init];
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
    
    [main.Cell_NSArr addObject:RoomStyle];

    
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
    
    

    
    
    
    
    //装修情况(需移动)
    EditCell *Decoration = [[EditCell alloc]init];
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
    
    [main.Cell_NSArr addObject:Decoration];
    
    

    
    
    
    //房屋配套
    EditCell *FlatAttachMent = [[EditCell alloc]init];
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
    [main.Cell_NSArr addObject:FlatAttachMent];
    
    
    
    //房价！！！自定义
    EditCell *AcreageCell = [[EditCell alloc]init];
    AcreageCell.isOptionalCell = YES ;
    
    if (_iSQiuzu) {
      AcreageCell.title = @"租金:";
    } else {
     AcreageCell.title = @"售价:";
    }
    AcreageCell.placeHoderString = @"不限";
    AcreageCell.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"60-90",@"90-120",@"120以上",@"不限",@"自定义",nil];
        if (_iSQiuzu) {
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
                self.main.GroupFlagNoArr = @[@1,@5,@2,@1,@1,@2];
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
    
    
    
    main.GroupFlagNoArr = @[@1,@5,@1,@1,@1,@2];  //12
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
        [_SaveBtn setFrame:CGRectMake(FootButtonPadding, CGRectGetMaxY(ContactNo.frame)+20, FootButtonWidth, FootButtonHeight)];
        [_PostBtn setFrame:CGRectMake(CGRectGetMaxX(SaveBtn.frame)+CellWidth-2*(FootButtonWidth+FootButtonPadding), CGRectGetMaxY(ContactNo.frame)+20, FootButtonWidth, FootButtonHeight)];
    };

}

-(void)pramaInit {
    _RegionName = @"";
    //装载Cell的容器
    QFTableView_Sco *mainContent   = [[QFTableView_Sco alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
    self.main = mainContent ;
    [self.view addSubview:mainContent];
    
    
    
    //房数、厅数的默认值,即当房数没填时，默认为N
    _fangshuStr = @"N";
    _tingshuStr = @"N";
    _toiletsStr = @"N";
    _balconysStr= @"N";
    
    //    //设置地址的KeyArr
    self.AdressKeyArr =  @[@"shengfen",@"shi",@"qu",@"region"];
    
    //其他属性
    [self.PostDataDic setObject:@"1"    forKey:@"currentpage"];
    [self.PostDataDic setObject:@"万元"  forKey:@"unit"];
    [self.PostDataDic setObject:@"20"   forKey:@"sum"];
    [self.PostDataDic setObject:@"0"    forKey:@"zhuangtai"];
    
}





-(void)addCell:(EditCell *)headcell After:(EditCell *)cell {
    int index =0;
    for (EditCell *Singlecell in self.main.Cell_NSArr) {
        NSLog(@"insertCell:%@",cell);
        ++index ;
        if ([Singlecell isEqual:cell]) {
            NSLog(@"hunted");
            break;
        }
    }
    [self.main.Cell_NSArr insertObject:headcell atIndex:index];
}



-(void)removeCellWithTag:(NSInteger)tag {
    for (EditCell *cell in self.main.Cell_NSArr) {
        NSLog(@"%@,%@",cell,cell.title);
        if (cell.tag == tag) {
            [self.main.Cell_NSArr removeObject:cell];
            [cell removeFromSuperview];
            NSLog(@"%@",self.main.Cell_NSArr);
            [self.main layoutSubviews];
            break;
        }
    }
}


-(void)getMaxAndMinArea:(NSString *) str {
    //    "60-90",@"90-120",@"120以上"
    /**
     *      NSString *_MinAcreageStr;
     NSString *_MaxAcreageStr;
     */
    
    if ([str isEqualToString:@"60-90"]) {
        _MinAcreageStr = @"60";
        _MaxAcreageStr = @"90";
    } else if ([str isEqualToString:@"90-120"]) {
        _MinAcreageStr = @"90";
        _MaxAcreageStr = @"120";
    }else {
        _MinAcreageStr = @"120";
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    NSLog(@"弹窗序号:%d",buttonIndex);
    if(alertView.tag == SuccessAlertTag) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if(alertView.tag == saveAlertTag) {
        if(buttonIndex == 0) {
            
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.typeStr];
            NSLog(@"取消");
            
            
            
            [self.navigationController popViewControllerAnimated:YES];
        } else if(buttonIndex ==1) {
            // 留在此页
            NSLog(@"保留到此页");
        } else {
            //保存并退出
            NSLog(@"保存并退出");
            
            //参数拼接，这里不用做保存
            //       [self loadLastParamDic];   //加载上一次保存的数据，这里有逻辑错误,如果上次的某个键值为空的话，再次即便更改这个键值也会，也会变得空
            [self FormatRegionParam];
            
            NSDictionary *oldSavedDic = [[NSUserDefaults standardUserDefaults] objectForKey:self.typeStr];
            NSLog(@"数量:%d", [[self.PostDataDic allKeys] count]);
            if([[self.PostDataDic allKeys] count] > 0) {
                NSLog(@"保存:%@",self.PostDataDic);
                [[NSUserDefaults standardUserDefaults]setObject:self.PostDataDic forKey:self.typeStr];  //11是状态码，代表 是出售 住宅
            } else {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.typeStr];
            }
            
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }
    
    //是否继续
    if(alertView.tag == checkLastTag) {
        if(buttonIndex==0){
            //继续填写
            _isLoadLastPara = YES;
            [self loadLastParamDic];
        } else {
            //重写填写
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.typeStr];
            NSLog(@"BB");
        }
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

#pragma mark UITextfiledDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text) _isLoadLastPara = YES;
    NSInteger EditedTextFieldTag = textField.tag ;
    switch (EditedTextFieldTag) {
        case biaotiTag:
            NSLog(@"标题是:%@",textField.text);
            NSLog(@"%@",self);
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
            
#define userNameTag     14                  //参数文档中未见
#define usertelTag      15
#define OwnerTag        16
#define OwnerName       17
            
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
@end
