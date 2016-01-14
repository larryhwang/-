//
//  InnerResourceFilter.m
//  清房助手
//
//  Created by Larry on 12/28/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//


/**
 
 1-u  0个人房源出售 1个人房源出租     state ＝ 0 为售  ／1为租
 1-c  0公司房源出售  1公司房源出租
 
 *  接口说明
 *    1.租售   isfangyuan =1-c  &state=0  //表示公司房源出售
 *            isfangyuan =1-c  &state=1       //表示公司房源出租  以此类推全部筛选状态
 */

#import "InnerResourceFilter.h"
#import "EditCell.h"
#import "FormCellInMutiTast.h"
#import "PopSelectViewController.h"
#import "commonFile.h"
#import "QFDateSelectStartToEnd.h"
#import "MBProgressHUD+CZ.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import  "SelectRegionVC.h"
#import "QFTableView_Sco.h"

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



#define fangshuTag      150
#define tingshuTag      160
#define toiletsTag      170
#define balconysTag     180

@interface InnerResourceFilter() <UITextFieldDelegate,SelectRegionDelegate> {
    NSString   *_RegionName;
    NSString   *_lastRegionName;
    
    NSString   *_completeHuXing;
    
    
    NSString *_fangshuStr;
    NSString *_tingshuStr;
    NSString *_toiletsStr;
    NSString *_balconysStr;
    
    
    

    
    
    NSString *_MinPriceStr;
    NSString *_MaxPriceStr;
    
    NSString *_MinAcreageStr;
    NSString *_MaxAcreageStr;
    

    NSString *_shengfen;
    NSString *_shi;
    NSString *_qu;
    NSString *_region;
    

}

@property(nonatomic,strong)  NSDictionary  *QFNewDic;
@property(nonatomic,weak)    EditCell *RegionTF;
@property(nonatomic,weak)    QFTableView_Sco *main;
@property(nonatomic,strong)  NSMutableDictionary  *PostDictionary;
@property(nonatomic,strong)  NSArray  *AdressKeyArr;


@end



@implementation InnerResourceFilter

-(NSMutableDictionary*)PostDictionary {
    if (_PostDictionary==nil) {
        _PostDictionary = [NSMutableDictionary new];
    }
    return _PostDictionary;
}

-(NSArray*)AdressKeyArr {
    if (_AdressKeyArr ==nil) {
        _AdressKeyArr = [NSArray new];
        _AdressKeyArr =  @[@"shengfen",@"shi",@"qu",@"region"];
    }
    return _AdressKeyArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self pramaInit];
    self.view.backgroundColor = [UIColor whiteColor];
    [self cellSetting];
    [self.main layoutSubviews];
 
}


-(void)pramaInit {
    
    
    _RegionName = @"";
    _lastRegionName = @"";
    
    
    
    //房数、厅数的默认值,即当房数没填时，默认为N
    _fangshuStr = @"N";
    _tingshuStr = @"N";
    _toiletsStr = @"N";
    _balconysStr= @"N";
    
    
    
    //先确定一个参数，从哪里搜索
   [self.PostDictionary setObject:_QFPramaIsFangyuan forKey:@"isfangyuan"];
    
    QFTableView_Sco *mainContent   = [[QFTableView_Sco alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
    mainContent.GroupFlagNoArr = @[@6];
    self.main = mainContent ;
    [self.view addSubview:mainContent];
    
    
    
    [self.PostDictionary setObject:@"1"    forKey:@"currentpage"];
    [self.PostDictionary setObject:@"万元"  forKey:@"unit"];
    [self.PostDictionary setObject:@"20"   forKey:@"pagecount"];
    [self.PostDictionary setObject:@"0"    forKey:@"zhuangtai"];
    
    
    UIButton *RightBarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 27)];
    [RightBarBtn setTitle:@"确定" forState:UIControlStateNormal];
    [RightBarBtn addTarget:self action:@selector(filterClick) forControlEvents:UIControlEventTouchUpInside];
    [RightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RightBarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
    UIBarButtonItem *gripeBarBtn = [[UIBarButtonItem alloc]initWithCustomView:RightBarBtn];
    self.navigationItem.rightBarButtonItem =gripeBarBtn;
}


-(void)cellSetting {
    //租购
#warning 未处理上传字段  isFangyuan
    EditCell *Zougou = [[EditCell alloc]init];
    Zougou.isOptionalCell = YES ;
    Zougou.title = @"租售:";
    Zougou.placeHoderString = @"不限";
    Zougou.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata = NULL;
        NSRange range = [_QFPramaIsFangyuan rangeOfString:@"0"];
        if(range.length){
          Optdata  = [NSArray arrayWithObjects:@"求租",@"求售",@"不限",nil];
        }else {
          Optdata  = [NSArray arrayWithObjects:@"出租",@"出售",@"不限",nil];
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
            int a;
            NSRange shou = [passString rangeOfString:@"售"];
            NSRange zu   = [passString rangeOfString:@"租"];
            if (shou.length) {
                a = 0;
                [self.PostDictionary setObject:@"0" forKey:@"state"];
            } else if(zu.length) {
                [self.PostDictionary setObject:@"1" forKey:@"state"];
            }
            
            Zougou.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil]; };
    [self.main.Cell_NSArr addObject:Zougou];
    
    
    //区域
    EditCell    *RegionOption  = [[EditCell alloc]init];
    _RegionTF = RegionOption;
    RegionOption.title = @"区域:";
    RegionOption.isOptionalCell = YES;
    RegionOption.placeHoderString = @"不限";
    //区域选择可以不限
    RegionOption.otherAction = ^(){
        NSLog(@"区域选项!");
        
        SelectRegionVC *selectRegion = [SelectRegionVC new];
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        selectRegion.indexData = app.provnceIndexDic;
        selectRegion.delegate = self ;
        [self.navigationController pushViewController:selectRegion animated:YES];
        NSLog(@"跳转已经执行完");
    };
    [self.main.Cell_NSArr addObject:RegionOption];
    
    
    //用途
    EditCell *HouseType = [[EditCell alloc]init];
    HouseType.isOptionalCell = YES ;
    HouseType.title = @"用途:";
    HouseType.placeHoderString = @"不限";
    HouseType.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"住宅",@"商铺",@"厂房",@"写字楼",nil];
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
            //如果是住宅,增加厅数Cell
            int typeInt;//@"住宅",@"商铺",@"厂房",@"写字楼  0住宅，1商铺，2写字楼，3厂房
            if ([passString isEqualToString:@"住宅"]) {
                typeInt = 0;
                EditCell    *RoomStyle = [[EditCell alloc]init];
                RoomStyle.tag = RoomStyleCellTag;
                RoomStyle.title = @"户型:";
                
                UITextField  *RoomTextfield = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, 40, 50)];
                RoomTextfield.delegate = self;
                RoomTextfield.tag = fangshuTag;
                [RoomStyle addSubview:RoomTextfield];
                UILabel *RoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(RoomTextfield.frame)+5, 0, 20, 50)];
                [RoomLabel setTextColor:[UIColor lightGrayColor]];
                RoomLabel.text = @"室";
                [RoomStyle addSubview:RoomLabel];
                
                UITextField *TingTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(RoomLabel.frame)-5, 0, 35, 50)];
                TingTextfield.delegate = self;
                [RoomStyle addSubview:TingTextfield];
                TingTextfield.tag = tingshuTag;
                UILabel *TingLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TingTextfield.frame), 0, 20, 50)];
                TingLabel.text = @"厅";
                [TingLabel setTextColor:[UIColor lightGrayColor]];
                [RoomStyle addSubview:TingLabel];
                
                UITextField *WeiTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TingLabel.frame), 0, 30, 50)];
                WeiTextfield.delegate = self;
                [RoomStyle addSubview:WeiTextfield];
                WeiTextfield.tag = toiletsTag;
                UILabel *WeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(WeiTextfield.frame), 0, 20, 50)];
                WeiLabel.text = @"卫";
                [WeiLabel setTextColor:[UIColor lightGrayColor]];
                [RoomStyle addSubview:WeiLabel];
                
                UITextField *YangTaiTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(WeiLabel.frame), 0, 30, 50)];
                YangTaiTextfield.delegate = self;
                [RoomStyle addSubview:YangTaiTextfield];
                YangTaiTextfield.tag = balconysTag;
                UILabel *YangTaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(YangTaiTextfield.frame), 0, 40, 50)];
                YangTaiLabel.text = @"阳台";
                [YangTaiLabel setTextColor:[UIColor lightGrayColor]];
                [RoomStyle addSubview:YangTaiLabel];
                //   [self.main.Cell_NSArr insertObject:RoomStyle atIndex:2];
                [self addCell:RoomStyle After:HouseType];
                [self.main layoutSubviews];
            } else {
                //若不是住宅，1.删除之前添加的Cell  2.保存数据
#warning 住宅数据存取有误，需要再了解
                if ([passString isEqualToString:@"住宅"]) {
                    typeInt =0;
                } else if ([passString isEqualToString:@"商铺"]){
                    typeInt =1;
                }else if ([passString isEqualToString:@"写字楼"]){
                    typeInt =2;
                }else {
                    typeInt =3;   //厂房
                }
                //typeInt
                
                [self removeCellWithTag:RoomStyleCellTag];
                
            }
            [self.PostDictionary setObject:[NSNumber numberWithInt:typeInt] forKey:@"fenlei"];
            HouseType.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [self.main.Cell_NSArr addObject:HouseType];
    
    
    
    
    //价格
    EditCell *PriceRange = [[EditCell alloc]init];
    PriceRange.isOptionalCell = YES ;
    PriceRange.title = @"价格:";
    PriceRange.placeHoderString = @"不限";
    PriceRange.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"20-30",@"30-60",@"60-80",@"80以上",@"自定义",@"不限",nil];
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
        select.SureBtnAciton =^(NSString *passString) {
            //如果是自定义则添加新的Cell
            EditCell *CustomsPriceRange = [[EditCell alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(RegionOption.frame),  Screen_width, CellHeight)];
            CustomsPriceRange.tag = CustomPriceCellTag;
            if([passString isEqualToString:@"自定义"]) {
                
                CustomsPriceRange.title = @"自定范围:";
                UITextField *blockTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, 60, 50)];
                blockTF.textAlignment = NSTextAlignmentCenter;
                blockTF.delegate = self;
                blockTF.tag = MinPriceTFTag;
                [CustomsPriceRange addSubview:blockTF];
                blockTF.keyboardType = UIKeyboardTypeNumberPad;
                UILabel *blockLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockTF.frame)+2,0, 30, 50)];
                
                blockLable.text = @"－";
                [blockLable setTextColor:[UIColor lightGrayColor]];
                [CustomsPriceRange addSubview:blockLable];
                
                UITextField *UnitTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockLable.frame)+2, 0, 60, 50)];
                UnitTF.textAlignment = NSTextAlignmentCenter;
                UnitTF.tag = MaxPriceTFTag;
                UnitTF.delegate = self;
                UnitTF.keyboardType = UIKeyboardTypeNumberPad;
                [CustomsPriceRange addSubview:UnitTF];
                
                UILabel *UnintLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UnitTF.frame)+2, 0, 60, 50)];
                [UnintLable setTextColor:[UIColor lightGrayColor]];
                UnintLable.text = @"万元";
                [CustomsPriceRange addSubview:UnintLable];
                // [self.main.Cell_NSArr insertObject:CustomsPriceRange atIndex:3];
                [self addCell:CustomsPriceRange After:PriceRange];
               
                [self.main layoutSubviews];
            } else {
                if ([passString isEqualToString:@"不限"]) {
                    //   [self.PostDictionary setObject:@"" forKey:@"price"];
                }else {
                    //自己截取最大值和最低值
                    [self getMaxAndMinPrice:passString];
                    [self.PostDictionary setObject:_MinPriceStr forKey:@"fprice"];
                    [self.PostDictionary setObject:_MaxPriceStr forKey:@"lprice"];
                    [self removeCellWithTag:CustomPriceCellTag];
                }
            }
            PriceRange.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil]; };
    [self.main.Cell_NSArr addObject:PriceRange];
    
    
    
    //面积
    EditCell *AcreageCell = [[EditCell alloc]init];
    AcreageCell.isOptionalCell = YES ;
    AcreageCell.title = @"面积:";
    AcreageCell.placeHoderString = @"不限";
    AcreageCell.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"60-90",@"90-120",@"120以上",@"不限",@"自定义",nil];
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
                UnintLable.text = @"平方米";
                [CustomsAcreageRange addSubview:UnintLable];
                // [self.main.Cell_NSArr insertObject:CustomsAcreageRange atIndex:4];
                [self addCell:CustomsAcreageRange After:AcreageCell];
                [self.main layoutSubviews];
            } else {
                //如果不是自定义 ，先保存数据
                if([passString isEqualToString:@"不限"]) {
                    // [self.PostDictionary setObject:@"" forKey:@"mianji"];
                } else {
                    //自己截取最大值和最小值
                    [self getMaxAndMinArea:passString];
                    
                    
                    [self.PostDictionary setObject:_MinAcreageStr forKey:@"fmianji"];
                    [self.PostDictionary setObject:_MaxAcreageStr forKey:@"lmianji"];
                    [self removeCellWithTag:AcreageCellTag];
                }
            }
            AcreageCell.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil]; };
    [self.main.Cell_NSArr addObject:AcreageCell];

    
    //电梯
    EditCell *LiftCell = [[EditCell alloc]init];
    LiftCell.isOptionalCell = YES ;
    LiftCell.title = @"电梯:";
    LiftCell.placeHoderString = @"不限";
    LiftCell.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"有电梯",@"无电梯",@"不限",nil];
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
            int a;
            
            if ([passString isEqualToString:@"有电梯"]) {
                a = 1;
                [self.PostDictionary setObject:[NSNumber numberWithInt:1] forKey:@"dianti"];
            } else if([passString isEqualToString:@"无电梯"]){
                [self.PostDictionary setObject:[NSNumber numberWithInt:0] forKey:@"dianti"];
            } else {
                //  [self.PostDictionary setObject:@"" forKey:@"dianti"]; //不限
            }
            LiftCell.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil]; };
    [self.main.Cell_NSArr addObject:LiftCell];
    
    
}

//http://www.123qf.cn:81/testApp/fkyuan/companyFKyuan.api

-(void)getMaxAndMinPrice:(NSString *)str {
   // @"20-30",@"30-60",@"60-80",@"80以上
    
    if ([str isEqualToString:@"20-30"]) {
        _MinPriceStr = @"20";
        _MaxPriceStr = @"30";
    }else if ([str isEqualToString:@"30-60"]) {
        _MinPriceStr = @"30";
        _MaxPriceStr = @"60";
    }else if ([str isEqualToString:@"60-80"]) {
        _MinPriceStr = @"60";
        _MaxPriceStr = @"80";
    }else {
        _MinPriceStr = @"80";
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
    
    
#warning 面积无上限问题是一个隐藏BUG
}


/**
 *  在一个Cell之后，再添加一个Cell
 *
 *  @param headcell 前面的Cell
 *  @param cell     需要加入的Cell
 */
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


-(void)initNav {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}



-(void)filterClick {
    NSLog(@"筛选");
    NSString *url = @"http://www.123qf.cn:81/testApp/fkyuan/companyFKyuan.api";

    //拼接参数
    
    
    [self FormatHouseTypeData]; //户型参数拼接
    [self FormatAdressData];   //地址参数拼接
    NSLog(@"参数:%@",_PostDictionary);
    
 //   从网上获得数据
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        [mgr POST:url parameters:_PostDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"内部新 : %@",responseObject);
            self.QFNewDic = responseObject;
            //重载上一个页面的表内容
            self.uptableData(_QFNewDic);
            //返回上一个界面
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}



#pragma mark -参数拼接的方法

-(void)appendName:(NSString *)locationName {
    //避免重复
    NSRange isHave = [_lastRegionName rangeOfString:locationName];
    if (!(isHave.length)) {  //若当前区域不含选中区域的
        _RegionName  = [_RegionName stringByAppendingString:[NSString stringWithFormat:@"%@ ",locationName]];
        _RegionTF.contentString = _RegionName;
        _lastRegionName = _RegionName;
    }
}




-(void)FormatHouseTypeData {
    _completeHuXing = @"";
    _completeHuXing = [NSString stringWithFormat:@"%@-%@-%@-%@",_fangshuStr,_tingshuStr,_toiletsStr,_balconysStr];
    if ([_completeHuXing isEqualToString:@"N-N-N-N"]) {
        return;
    }
    [self.PostDictionary setObject:_completeHuXing forKey:@"hucate"];
}



-(void)FormatAdressData {
    NSMutableArray *Namespart  = (NSMutableArray *)[_RegionName componentsSeparatedByString:@" "];
    if (Namespart.count >1) {
        [Namespart removeObject:[Namespart lastObject]];
    }
    
    if ([Namespart count]>1) {
        int i = 0;
        for (NSString *str in Namespart) {
            [self.PostDictionary setObject:str forKey:self.AdressKeyArr[i++]];
        }
    }
}




-(void)textFieldDidEndEditing:(UITextField *)textField {
    //由tag值确定内容,并保存好参数
    //  float flag = textField.tag ;
    NSString *TFcontentStr = textField.text;
    NSLog(@"输入的内容%@",TFcontentStr);
    //如果没填，就确认为N
    
    
    
    //户型参数保留
    switch (textField.tag) {
        case fangshuTag:
            _fangshuStr  = TFcontentStr;
            break;
        case tingshuTag:
            _tingshuStr  = TFcontentStr;
            break;
        case toiletsTag:
            _toiletsStr  = TFcontentStr;
            break;
        case balconysTag:
            _balconysStr = TFcontentStr;
            break;
        case MinPriceTFTag:
            _MinPriceStr = TFcontentStr;
            break;
        case MaxPriceTFTag:
            _MaxPriceStr = TFcontentStr;
            break;
        case MinAcreageTFTag:
            _MinAcreageStr = TFcontentStr;
            break;
        case MaxAcreageTFTag:
            _MaxAcreageStr = TFcontentStr;
            break;
        default:
            break;
    }
}




@end
