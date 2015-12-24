//
//  TypesSelect.m
//  清房助手
//
//  Created by Larry on 12/22/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//  说明: 本页面用来描述总和业务中的弹窗的视图
//

#import "TypesSelect.h"
#import "QFLocateButton.h"
#import "OrderTypeSelectBtn.h"
#import "CommitOrderVC.h"

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
#define BtnWidth    90
#define BtnHeigth   35   //选项高度

#define DeafaultColor    [UIColor colorWithRed:3/255.0 green:164/255.0 blue:255/255.0 alpha:1.0]
#define DeafaultColor2   [UIColor colorWithRed:0 green:122.0 / 255 blue:1.0 alpha:1.0]
#define PopViewBKGColor  [UIColor colorWithRed:38.0/255.0 green:141.0 / 255 blue:1.0 alpha:1.0]

#define CitySwichtBtnHeight 40

#define StatusAndNavHeight 64

#define BtnPaddingToVertical   30     //两按钮左右间隔高度
#define BtnPaddingToHorizon    10     //上下间隔高度

#define BtnType1Width  70
#define BtnType2Width  90


#define BtnsHorizontal  ScreenWidth - BtnType1Width - BtnType2Width -2 * BtnPaddingToVertical;  //两个按钮之间的宽度

@interface TypesSelect(){
    CGRect _Origin;
    CGRect _popOrigin;
    TypesSelect *_popView;

}

@end

@implementation TypesSelect

-(void)FirstlocationClick:(OrderTypeSelectBtn *)btn {
    for(OrderTypeSelectBtn *btn in self.subviews){
        NSLog(@"element:%@",btn);
        if ([btn isKindOfClass:[OrderTypeSelectBtn class]]) {
            if (btn.selected == YES ) {
              [btn becameUslected];
            }
        } else {
        }
    }
    
   [btn becameSelected];
    //传值，
    self.changeServiceType(btn.QFSelectedServiceType);
  //  然后退出
    [self hide];
    
    
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    _Origin = frame;
    _popOrigin = CGRectMake(frame.origin.x, frame.origin.y +frame.size.height , frame.size.width, frame.size.height);
     //name.origin.x,name.origin.y , name.size.width, name.size.height
    if (self) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(BtnPaddingToVertical/2, BtnPaddingToHorizon, 120, 20)];
        label.text = @"房产证在手";
        [self addSubview:label];
        
        //btn 在实例化是 也添加了事件,仅用于点击后更新自己UI
        CGFloat btnY = CGRectGetMaxY(label.frame) + BtnPaddingToHorizon;  //CGFloat *btnX =
        OrderTypeSelectBtn *btn = [[OrderTypeSelectBtn alloc]initWithFrame:CGRectMake(BtnPaddingToVertical, btnY, BtnType1Width, 30)];
        btn.QFSelectedServiceType = @"房产证在手－按揭付款";
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(FirstlocationClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"按揭付款" forState:UIControlStateNormal];
        [self addSubview:btn];
        
    
        CGFloat btn1x = CGRectGetMaxX(btn.frame) + BtnsHorizontal;
        OrderTypeSelectBtn *btn1 = [[OrderTypeSelectBtn alloc]initWithFrame:CGRectMake(btn1x, btnY, BtnType2Width, 30)];
        btn1.QFSelectedServiceType = @"房产证在手－一次性付款";
        [btn1 addTarget:self action:@selector(FirstlocationClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitle:@"一次付款" forState:UIControlStateNormal];
        [self addSubview:btn1];
        
        CGFloat label2Y = CGRectGetMaxY(btn1.frame) + BtnPaddingToHorizon ;
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(BtnPaddingToVertical/3, label2Y + 10 , 120, 20)];
        label2.text = @"房产证不在手";
        [self addSubview:label2];
        
        
        CGFloat btn2Y = CGRectGetMaxY(label2.frame) + BtnPaddingToHorizon;  //CGFloat *btnX =
        OrderTypeSelectBtn *btn2 = [[OrderTypeSelectBtn alloc]initWithFrame:CGRectMake(BtnPaddingToVertical, btn2Y, BtnType1Width, 30)];
        btn2.QFSelectedServiceType = @"房产证不在手－按揭付款";
        [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(FirstlocationClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setTitle:@"按揭付款" forState:UIControlStateNormal];
        [self addSubview:btn2];
        
        
        CGFloat btn3x = CGRectGetMaxX(btn2.frame) + BtnsHorizontal;
        OrderTypeSelectBtn *btn3 = [[OrderTypeSelectBtn alloc]initWithFrame:CGRectMake(btn3x, btn2Y, BtnType2Width, 30)];
        btn3.QFSelectedServiceType = @"房产证不在手－一次性付款";
        [btn3 addTarget:self action:@selector(FirstlocationClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 setTitle:@"一次付款" forState:UIControlStateNormal];
        [self addSubview:btn3];
    }
    return self;
}


+(instancetype)typeselectViewWithFrame:(CGRect)frame {
    TypesSelect *popView = [[TypesSelect alloc]initWithFrame:frame];
    return popView;
}


-(void)pop {
    _isPop = YES;
    [self setHidden:NO];
    self.updateTrickBoard();

    [UIView animateWithDuration:.5 animations:^{
        [self setFrame:_popOrigin];
        [self.delegate transArrowImg];
    } completion:^(BOOL finished) {
       self.HideTrickBoard();

    }];
}

-(void)hide {
    _isPop = NO;
     self.updateTrickBoard();
    self.ShowTrickBoard();  //先不隐藏挡板，避免让弹窗镂空穿过去
    [UIView animateWithDuration:.4 animations:^{
        [self setFrame:_Origin];
        [self.delegate transArrowImg];
      
    } completion:^(BOOL finished) {
        [self setHidden:YES];
       self.updateTrickBoard();
    }];
}

@end
