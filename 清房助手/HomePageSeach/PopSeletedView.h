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



/**
 *  通知首页更改信息
 *
 *  @param name 地名
 *  @param code 下次的请求码
 *  @param type 区分是第一级小按钮 和 第二级小按钮 ，0 是一级  1 是二级
 */
-(void)popViewSectionOneBtnclickWithName:(NSString *)name requesNo:(NSString *)code andType:(NSInteger ) type;


@end

@interface PopSeletedView : UIScrollView

@property(nonatomic,strong)  UIView  *FirstSecton;
@property(nonatomic,assign)  int     FirstSectionCount;
@property(nonatomic,strong)  UIView  *SecondSecton;
@property(nonatomic,assign)  int     SecondSectionCount;
@property(nonatomic,assign)  id<PopSelectViewDelegate> PopViewdelegate;
@property(nonatomic,copy)    NSString *nowCityName;

/**
 *  第一级地名数组
 */
@property(nonatomic,strong)  NSMutableArray  *LocationNameDicPartOne_NSarr;


/**
 *  第二级地名数组
 */
@property(nonatomic,strong)  NSMutableArray  *LocationNameDicPartTwo_NSarr;



@property(nonatomic,assign)  CGRect popViewOriginRect;   //未弹的初始位置
@property(nonatomic,assign)  CGRect popViewDispRect;     //弹出后的位置



-(void)setCityBtn;
-(void)layoutSectionA;
@end
