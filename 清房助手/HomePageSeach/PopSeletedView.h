//
//  PopSeletedView.h
//  清房助手
//
//  Created by Larry on 12/15/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopSelectViewDelegate <NSObject>

-(void)popViewCitySwitchClick;
-(void)popViewSectionOneBtnclickWithName:(NSString *)name and:(NSString *)code;


@end

@interface PopSeletedView : UIScrollView

@property(nonatomic,strong)  UIView  *FirstSecton;
@property(nonatomic,assign)  int     FirstSectionCount;
@property(nonatomic,strong)  UIView  *SecondSecton;
@property(nonatomic,assign)  int     SecondSectionCount;
@property(nonatomic,assign)  id<PopSelectViewDelegate> PopViewdelegate;
@property(nonatomic,copy)    NSString *nowCityName;
@property(nonatomic,strong)  NSMutableArray  *LocationNameDicPartOne_NSarr;
@property(nonatomic,strong)  NSMutableArray  *LocationNameDicPartTwo_NSarr;



@property(nonatomic,assign)  CGRect popViewOriginRect;   //未弹的初始位置
@property(nonatomic,assign)  CGRect popViewDispRect;     //弹出后的位置



-(void)setCityBtn;
-(void)layoutSectionA;
@end
