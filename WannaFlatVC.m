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

@interface WannaFlatVC (){
    NSString *_RegionName;
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

@end

@implementation WannaFlatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)CellSetting {
    EditCell    *RegionOption  = [[EditCell alloc]init];
    self.RegionTF = RegionOption;
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
                RoomTextfield.tag = fangshuTag;
                RoomTextfield.delegate = self;
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
                YangTaiTextfield.delegate = self ;
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
            [self.PostDictionary setObject:[NSNumber numberWithInt:typeInt] forKey:@"yongtu"];
            HouseType.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [self.main.Cell_NSArr addObject:HouseType];
    
    
    
    EditCell *PriceRange = [[EditCell alloc]init];
    //    __weak __typeof(FlatAttachMent)weakFlatAttachMent = FlatAttachMent;
    __weak __typeof(PriceRange)weakPriceRange = PriceRange;
    PriceRange.isOptionalCell = YES ;
    PriceRange.title = @"价格:";
    PriceRange.placeHoderString = @"不限";
    PriceRange.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"20-30",@"30-50",@"50-80",@"自定义",@"不限",nil];
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
            EditCell *CustomsPriceRange = [[EditCell alloc]init];
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
                [self addCell:CustomsPriceRange After:weakPriceRange];
                [self.main layoutSubviews];
            } else {
                if ([passString isEqualToString:@"不限"]) {
                    //   [self.PostDictionary setObject:@"" forKey:@"price"];
                }else {
                    [self.PostDictionary setObject:passString forKey:@"price"];
                    [self removeCellWithTag:CustomPriceCellTag];
                }
            }
            
            weakPriceRange.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil]; };
    [self.main.Cell_NSArr addObject:PriceRange];
    
    
    EditCell *AcreageCell = [[EditCell alloc]init];
    AcreageCell.isOptionalCell = YES ;
    AcreageCell.title = @"面积:";
    AcreageCell.placeHoderString = @"不限";
    AcreageCell.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"20-30",@"30-50",@"50-100",@"不限",@"自定义",nil];
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
                    [self.PostDictionary setObject:passString forKey:@"mianji"];
                    [self removeCellWithTag:AcreageCellTag];
                }
                
            }
            AcreageCell.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil]; };
    [self.main.Cell_NSArr addObject:AcreageCell];
    
    
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
    [self.main layoutSubviews];
    
    
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
    [self.PostDictionary setObject:@"1"    forKey:@"currentpage"];
    [self.PostDictionary setObject:@"万元"  forKey:@"unit"];
    [self.PostDictionary setObject:@"20"   forKey:@"sum"];
    [self.PostDictionary setObject:@"0"    forKey:@"zhuangtai"];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    //由tag值确定内容,并保存好参数
    //  float flag = textField.tag ;
    NSString *TFcontentStr = textField.text;
    NSLog(@"输入的内容%@",TFcontentStr);
    //如果没填，就确认为N
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
