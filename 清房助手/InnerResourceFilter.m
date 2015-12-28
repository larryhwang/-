//
//  InnerResourceFilter.m
//  清房助手
//
//  Created by Larry on 12/28/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

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

@interface InnerResourceFilter() <UITextFieldDelegate>

@property(nonatomic,strong)  NSDictionary  *QFNewDic;
@property(nonatomic,strong)  NSMutableDictionary  *QFPostDic;
@property(nonatomic,weak)    EditCell *RegionTF;
@property(nonatomic,weak)   QFTableView_Sco *main;

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
    QFTableView_Sco *mainContent   = [[QFTableView_Sco alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
    self.main = mainContent ;
    [self.view addSubview:mainContent];
    
    
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
    EditCell *Zougou = [[EditCell alloc]init];
    Zougou.isOptionalCell = YES ;
    Zougou.title = @"电梯:";
    Zougou.placeHoderString = @"不限";
    Zougou.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"求租",@"求售",@"不限",nil];
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
            
            if ([passString isEqualToString:@"求租"]) {
                a = 1;
                [self.PostDictionary setObject:[NSNumber numberWithInt:1] forKey:@"dianti"];
            } else if([passString isEqualToString:@"求购"]){
                [self.PostDictionary setObject:[NSNumber numberWithInt:0] forKey:@"dianti"];
            } else {
                //  [self.PostDictionary setObject:@"" forKey:@"dianti"]; //不限
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
                RoomTextfield.tag = fangshuTag;
                [RoomStyle addSubview:RoomTextfield];
                UILabel *RoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(RoomTextfield.frame)+5, 0, 20, 50)];
                [RoomLabel setTextColor:[UIColor lightGrayColor]];
                RoomLabel.text = @"室";
                [RoomStyle addSubview:RoomLabel];
                
                UITextField *TingTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(RoomLabel.frame)-5, 0, 35, 50)];
                [RoomStyle addSubview:TingTextfield];
                TingTextfield.tag = tingshuTag;
                UILabel *TingLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TingTextfield.frame), 0, 20, 50)];
                TingLabel.text = @"厅";
                [TingLabel setTextColor:[UIColor lightGrayColor]];
                [RoomStyle addSubview:TingLabel];
                
                UITextField *WeiTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TingLabel.frame), 0, 30, 50)];
                [RoomStyle addSubview:WeiTextfield];
                WeiTextfield.tag = toiletsTag;
                UILabel *WeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(WeiTextfield.frame), 0, 20, 50)];
                WeiLabel.text = @"卫";
                [WeiLabel setTextColor:[UIColor lightGrayColor]];
                [RoomStyle addSubview:WeiLabel];
                
                UITextField *YangTaiTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(WeiLabel.frame), 0, 30, 50)];
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
    
    
    
    
    //价格
    EditCell *PriceRange = [[EditCell alloc]init];
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
                    [self.PostDictionary setObject:passString forKey:@"price"];
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
    NSLog(@"哈哈");
    NSString *url = @"";
 //   从网上获得数据
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        [mgr POST:url parameters:_QFPostDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            self.QFNewDic = responseObject[@"data"];
            //重载上一个页面的表内容
            self.uptableData(_QFNewDic);
            //返回上一个界面
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}
@end
