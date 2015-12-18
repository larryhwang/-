//
//  PopSeletedView.m
//  清房助手
//
//  Created by Larry on 12/15/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
#define BtnWidth    90
#define BtnHeigth   35

#define DeafaultColor [UIColor colorWithRed:3/255.0 green:164/255.0 blue:255/255.0 alpha:1.0]
#define DeafaultColor2 [UIColor colorWithRed:0 green:122.0 / 255 blue:1.0 alpha:1.0]
#define PopViewBKGColor  [UIColor colorWithRed:38.0/255.0 green:141.0 / 255 blue:1.0 alpha:1.0]

#define CitySwichtBtnHeight 40

#define StatusAndNavHeight 64

#define partPadding 5

#import "PopSeletedView.h"
#import "AFHTTPRequestOperationManager.h"
#import "QFCitySwitchCellBtn.h"
#import "QFLocateButton.h"

@interface PopSeletedView (){
    CGFloat _SectonOneHeight;       //第一部分高度
    CGFloat _SectonTwoHeight;       //第二部分高度
    UIView  *CitySwitchBtnContent;  //城市切换按钮的容器

}
@property(nonatomic,strong) QFCitySwitchCellBtn *btn;    //底部切换城市按钮
@property(nonatomic,strong) UIView   *bottomLine;
@property(nonatomic,strong) UIView   *headLine;
@property(nonatomic,strong) UIView   *seprateLine;
@property(nonatomic,assign) BOOL     isExsitSectionB;    //是否存在第二部分

@end




@implementation PopSeletedView

-(NSMutableArray*)LocationNameDic_NSArr {
    if (_LocationNameDicPartOne_NSarr ==nil) {
        _LocationNameDicPartOne_NSarr = [NSMutableArray new];
    }
    return _LocationNameDicPartOne_NSarr;
}

-(NSMutableArray*)LocationNameDicPartTwo_NSarr {
    if (_LocationNameDicPartTwo_NSarr ==nil) {
        _LocationNameDicPartTwo_NSarr = [NSMutableArray new];
    }
    return _LocationNameDicPartTwo_NSarr;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    //按钮容器
    UIView *btnContent = [[UIView alloc]init];
    [self addSubview:btnContent];
    _isExsitSectionB = NO;
    self.backgroundColor = PopViewBKGColor;

  //  btnContent.backgroundColor = [UIColor brownColor];
   [self addSubview:btnContent];
    CitySwitchBtnContent = btnContent;
    
    //城市切换按钮
    QFCitySwitchCellBtn *btn = [[QFCitySwitchCellBtn alloc]init];
    [btn addTarget:self action:@selector(citySwitchClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(8, 0 , ScreenWidth-16, 40)];
    self.btn = btn;
    
    //第一部分按钮容器
    self.FirstSecton =  [[UIView alloc]init];  //第一部分容器
  // self.FirstSecton.backgroundColor = [UIColor redColor];
    [self addSubview:self.FirstSecton];
    
 

    
    return self;
}


-(void)setNowCityName:(NSString *)nowCityName {
    self.btn.currentCityName = nowCityName ;
    NSLog(@"当前城市名:%@",self.btn.currentCityName);
}


-(void)layoutSectionA {
    _isExsitSectionB = YES;


    //摆放按钮
    self.nowCityName = @"惠州市";
    //清除之前的按钮
    for (QFLocateButton *btn in self.FirstSecton.subviews) {
        [btn removeFromSuperview];
    }
    self.FirstSectionCount =ceil((float)_LocationNameDicPartOne_NSarr.count/3);  //第一部部分多少行,这里已经设置好了第一部分的高度
    _SectonOneHeight = (BtnHeigth + 12) * (self.FirstSectionCount ) ;   //这里开始决定弹窗大小
    
    self.popViewOriginRect = CGRectMake(0, -(_SectonOneHeight), ScreenWidth, _SectonOneHeight  + CitySwichtBtnHeight +partPadding*3); //弹窗初始化位置与大小
    self.popViewDispRect   = CGRectMake(0, 64 , ScreenWidth, _SectonOneHeight + CitySwichtBtnHeight +partPadding * 3 );            //弹窗展示时的位置与大小
    
    
    [_FirstSecton setFrame:CGRectMake(0, partPadding, ScreenWidth, _SectonOneHeight)];
    [self setFrame:self.popViewOriginRect];
    
    
    //添加新的按钮
    CGFloat orginX = 10;  CGFloat originY = 0;  int index = 0;
    CGFloat paddingX = (ScreenWidth - 2*orginX - 3* BtnWidth)/2;
    CGFloat paddingY = 16;
    for (NSDictionary *dic in _LocationNameDicPartOne_NSarr) {
        int line  = index / 3;  // 行
        int row   = index % 3;  //列
        QFLocateButton *btn = [[QFLocateButton alloc]initWithFrame:CGRectMake(orginX + (BtnWidth + paddingX) * row,originY +(BtnHeigth + paddingY) *line, BtnWidth, BtnHeigth)];
        
        if (index ==0) {
            [btn becameSelected];
        }
        NSLog(@"城市名:%@",dic[@"name"]);
        [btn setTitle: dic[@"name"] forState:UIControlStateNormal];
        btn.nextRequsetCode = dic[@"code"];
        [btn addTarget:self action:@selector(FirstlocationNameClick:) forControlEvents:UIControlEventTouchUpInside];
        index ++;
        [self.FirstSecton addSubview:btn];  //市的区级部分
    }


    
    [self layoutCityBtn];
    

    
    
 
}



/**
 *  摆放切换按钮
 */
-(void)layoutCityBtn{
    //设置按钮容器位置
    NSLog(@"btnContentY：%f",_SectonOneHeight);

    CGFloat  contentBtnY = CGRectGetHeight(self.frame); //self.popViewDispRect
    NSLog(@"btnContentY：%f",contentBtnY);

    [CitySwitchBtnContent setFrame:CGRectMake(8, contentBtnY - CitySwichtBtnHeight -partPadding, ScreenWidth-16, CitySwichtBtnHeight)];

    
    //设置分割线
   
    
    
    //将线条添加进去
    if (self.headLine == nil) {   //避免重复划线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth-16, 1)];
        line.backgroundColor = [UIColor whiteColor];
        self.headLine = line;
    }
    [CitySwitchBtnContent addSubview: self.headLine];
    
    if (self.bottomLine ==nil) {
        UIView *Bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, 40-1 , ScreenWidth-16, 1)];
        Bottomline.backgroundColor = [UIColor whiteColor];
        self.bottomLine = Bottomline ;
    }
    [CitySwitchBtnContent addSubview:self.bottomLine];
    
    //将按钮添加进去
    [CitySwitchBtnContent addSubview:self.btn];
}





-(void)setSecondSectionCount:(int)SecondSectionCount{
    
    if (_SecondSecton !=nil ) {
        [_SecondSecton removeFromSuperview];
    }
    [self.seprateLine setHidden:NO]; //显示分割线
    _SecondSectionCount = SecondSectionCount ;
    _SectonTwoHeight = (BtnHeigth + 8) *( SecondSectionCount);
 
    //重置城市切换按钮的位置


    
    
    // 继承UIScoview之后，Y的原始坐标是从 向下偏移 64 计算的
    CGFloat sectionA_Y = CGRectGetMaxY(_FirstSecton.frame);
    _SecondSecton = [[UIView alloc]initWithFrame:CGRectMake(0, sectionA_Y , ScreenWidth, _SectonTwoHeight)];  //第一部分高度
    //_SecondSecton.backgroundColor = DeafaultColor;
    

    [self addSubview:_SecondSecton];
    
}

-(void)menumiss{
    NSLog(@"界面退出");
}


-(void)setCityBtn{
    if (_SecondSecton !=nil ) {
        [_SecondSecton removeFromSuperview];
    }
    [CitySwitchBtnContent setFrame:CGRectMake(8, -StatusAndNavHeight + _SectonOneHeight  , ScreenWidth-16, CitySwichtBtnHeight)];
    [self.seprateLine setHidden:YES];
    
}

-(void)citySwitchClick {
    [self.PopViewdelegate popViewCitySwitchClick];
}



-(void)FirstlocationNameClick:(QFLocateButton *)btn {
    NSString *name = btn.titleLabel.text;
    NSString *code = btn.nextRequsetCode;
    
    
    for(QFLocateButton *btn in self.FirstSecton.subviews){
        if (btn.selected == YES) {
            [btn becameUslected];
        }
    }
    
    [btn becameSelected];  //被选高亮
    [self.PopViewdelegate popViewSectionOneBtnclickWithName:name and:code];
}
@end
