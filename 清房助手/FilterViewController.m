//
//  FilterViewController.m
//  清房助手
//
//  Created by Larry on 12/10/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "FilterViewController.h"
#import "QFTableView_Sco.h"
#import "EditCell.h"
#import "AppDelegate.h"
#import "SelectRegionVC.h"
#include "PopViewController/PopSelectViewController.h"

#define ModalViewTag   99



#define CustomPriceTag 20
#define RoomStyleTag   30
#define AcreageTag     40

@interface FilterViewController ()<SelectRegionDelegate>{
    NSString *_RegionName;
    NSString *_lastRegionName;
}

@property(nonatomic,weak) QFTableView_Sco *main;
@property(nonatomic,weak) EditCell *RegionTF;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pramaInit];
    EditCell    *RegionOption  = [[EditCell alloc]init];
    _RegionTF = RegionOption;
    RegionOption.title = @"区域:";
    RegionOption.isOptionalCell = YES;
    RegionOption.placeHoderString = @"请选择";
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
    HouseType.placeHoderString = @"请选择:";
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
            if ([passString isEqualToString:@"住宅"]) {
                EditCell    *RoomStyle = [[EditCell alloc]init];
                RoomStyle.tag = RoomStyleTag;
                RoomStyle.title = @"户型:";
                
                UITextField  *RoomTextfield = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, 40, 50)];
                
                [RoomStyle addSubview:RoomTextfield];
                
                UILabel *RoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(RoomTextfield.frame)+5, 0, 20, 50)];
                
                [RoomLabel setTextColor:[UIColor lightGrayColor]];
                RoomLabel.text = @"室";
                [RoomStyle addSubview:RoomLabel];
                
                UITextField *TingTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(RoomLabel.frame)-5, 0, 35, 50)];
                
                [RoomStyle addSubview:TingTextfield];
                
                UILabel *TingLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TingTextfield.frame), 0, 20, 50)];
                TingLabel.text = @"厅";
                [TingLabel setTextColor:[UIColor lightGrayColor]];
                [RoomStyle addSubview:TingLabel];
                
                UITextField *WeiTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(TingLabel.frame), 0, 30, 50)];
                
                [RoomStyle addSubview:WeiTextfield];
                UILabel *WeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(WeiTextfield.frame), 0, 20, 50)];
                WeiLabel.text = @"卫";
                [WeiLabel setTextColor:[UIColor lightGrayColor]];
                [RoomStyle addSubview:WeiLabel];
                
                UITextField *YangTaiTextfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(WeiLabel.frame), 0, 30, 50)];
                [RoomStyle addSubview:YangTaiTextfield];
                UILabel *YangTaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(YangTaiTextfield.frame), 0, 40, 50)];
                YangTaiLabel.text = @"阳台";
                [YangTaiLabel setTextColor:[UIColor lightGrayColor]];
                [RoomStyle addSubview:YangTaiLabel];
                [self.main.Cell_NSArr insertObject:RoomStyle atIndex:2];
                [self.main layoutSubviews];
            } else {
                //若不是住宅，则删除之前添加的
                [self removeCellWithTag:RoomStyleTag];
                
            }
        HouseType.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil];
    };
    [self.main.Cell_NSArr addObject:HouseType];
    
    EditCell *PriceRange = [[EditCell alloc]init];
    PriceRange.isOptionalCell = YES ;
    PriceRange.title = @"价格:";
    PriceRange.placeHoderString = @"请选择:";
    PriceRange.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"20-30W",@"30-50W",@"50-80W",@"自定义",nil];
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
            CustomsPriceRange.tag = CustomPriceTag;
            if([passString isEqualToString:@"自定义"]) {
                
                CustomsPriceRange.title = @"自定范围:";
                UITextField *blockTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, 60, 50)];
                blockTF.textAlignment = NSTextAlignmentCenter;
                blockTF.delegate = self;

                [CustomsPriceRange addSubview:blockTF];
                blockTF.keyboardType = UIKeyboardTypeNumberPad;
                UILabel *blockLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockTF.frame)+2,0, 30, 50)];
                
                blockLable.text = @"－";
                [blockLable setTextColor:[UIColor lightGrayColor]];
                [CustomsPriceRange addSubview:blockLable];
                
                UITextField *UnitTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockLable.frame)+2, 0, 60, 50)];
                UnitTF.textAlignment = NSTextAlignmentCenter;
                UnitTF.delegate = self;
                UnitTF.keyboardType = UIKeyboardTypeNumberPad;
                [CustomsPriceRange addSubview:UnitTF];
                
                UILabel *UnintLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UnitTF.frame)+2, 0, 60, 50)];
                [UnintLable setTextColor:[UIColor lightGrayColor]];
                UnintLable.text = @"万元";
                [CustomsPriceRange addSubview:UnintLable];
                [self.main.Cell_NSArr insertObject:CustomsPriceRange atIndex:3];
                [self.main layoutSubviews];
            } else {
                [self removeCellWithTag:CustomPriceTag];
                }
            
            PriceRange.contentString = passString;
        };
    [self presentViewController:select animated:YES completion:nil]; };
    [self.main.Cell_NSArr addObject:PriceRange];
    
    
    EditCell *AcreageCell = [[EditCell alloc]init];
    AcreageCell.isOptionalCell = YES ;
    AcreageCell.title = @"面积:";
    AcreageCell.placeHoderString = @"请选择:";
    AcreageCell.otherAction =^{
        PopSelectViewController *select = [[PopSelectViewController alloc]init];
        NSArray *Optdata  = [NSArray arrayWithObjects:@"20-30",@"30-50",@"50+",@"不限",@"自定义",nil];
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
            CustomsAcreageRange.tag = AcreageTag;
            if([passString isEqualToString:@"自定义"]) {
                CustomsAcreageRange.title = @"自定范围:";
                UITextField *blockTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, 60, 50)];
                blockTF.textAlignment = NSTextAlignmentCenter;
                blockTF.delegate = self;
                [CustomsAcreageRange addSubview:blockTF];
                blockTF.keyboardType = UIKeyboardTypeNumberPad;
                UILabel *blockLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockTF.frame)+2,0, 30, 50)];
                
                blockLable.text = @"－";
                [blockLable setTextColor:[UIColor lightGrayColor]];
                [CustomsAcreageRange addSubview:blockLable];
                
                UITextField *UnitTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockLable.frame)+2, 0, 60, 50)];
                UnitTF.textAlignment = NSTextAlignmentCenter;
                UnitTF.delegate = self;
                UnitTF.keyboardType = UIKeyboardTypeNumberPad;
                [CustomsAcreageRange addSubview:UnitTF];
                
                UILabel *UnintLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UnitTF.frame)+2, 0, 60, 50)];
                [UnintLable setTextColor:[UIColor lightGrayColor]];
                UnintLable.text = @"平方米";
                [CustomsAcreageRange addSubview:UnintLable];
                [self.main.Cell_NSArr insertObject:CustomsAcreageRange atIndex:4];
                [self.main layoutSubviews];
            } else {
                [self removeCellWithTag:AcreageTag];
            }
            
            AcreageCell.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil]; };
    [self.main.Cell_NSArr addObject:AcreageCell];
    
    
    EditCell *LiftCell = [[EditCell alloc]init];
    LiftCell.isOptionalCell = YES ;
    LiftCell.title = @"电梯:";
    LiftCell.placeHoderString = @"请选择:";
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
            LiftCell.contentString = passString;
        };
        [self presentViewController:select animated:YES completion:nil]; };
    [self.main.Cell_NSArr addObject:LiftCell];
    
    
    
    
    [self.main layoutSubviews];
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


-(void)appendName:(NSString *)locationName {
//    NSRange isHave = [locationName rangeOfString:_lastRegionName];
//    if (isHave.length) {
        _RegionName  = [_RegionName stringByAppendingString:[NSString stringWithFormat:@"%@ ",locationName]];
        _RegionTF.contentString = _RegionName ;
    //}

}


-(void)pramaInit {
    //data
    _RegionName = @"";
    QFTableView_Sco *mainContent   = [[QFTableView_Sco alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
//    mainContent.backgroundColor = [UIColor lightGrayColor];
    self.main = mainContent ;
    [self.view addSubview:mainContent];
    
    //UI
    UIButton *RightBarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 27)];
    [RightBarBtn setTitle:@"确定" forState:UIControlStateNormal];
    [RightBarBtn addTarget:self action:@selector(FilterSureClick) forControlEvents:UIControlEventTouchUpInside];
    [RightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RightBarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
    UIBarButtonItem *gripeBarBtn = [[UIBarButtonItem alloc]initWithCustomView:RightBarBtn];
    self.navigationItem.rightBarButtonItem =gripeBarBtn;
    
}

-(void)updateTableData {
    
}

-(void)FilterSureClick {
  // 跳转到上一个页面，并更新数据
    [self.navigationController popViewControllerAnimated:YES];
}
@end
