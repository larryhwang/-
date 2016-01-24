//
//  TypesSelect.h
//  清房助手
//
//  Created by Larry on 12/22/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol typeSelectdelegate <NSObject>

-(void)transArrowImg;
-(void )setServiceTypeDicWith:(NSString *)str;

@end


/**
 *  用于在选中之后更新UI
 */
typedef void (^ChangeServiceLabelVarBlock) (NSString *str);
typedef void (^ChangeServiceDicSetBlock)   (NSString *str);
typedef void (^UpdateFatherVCTrikBoard)    (void);
typedef void (^ShowFatherVCTrikBoard)      (void);
typedef void (^HideFatherVCTrikBoard)      (void);
@interface   TypesSelect : UIView


@property(nonatomic,copy) ChangeServiceLabelVarBlock  changeServiceType;

/**
 *  更新档板是否隐藏
 */

@property(nonatomic,copy) UpdateFatherVCTrikBoard    updateTrickBoard;


@property(nonatomic,copy) ChangeServiceDicSetBlock    btnSetDicBlock;

@property(nonatomic,copy)   ShowFatherVCTrikBoard      ShowTrickBoard;
@property(nonatomic,copy)   HideFatherVCTrikBoard      HideTrickBoard;
@property(nonatomic,assign)     BOOL      isPop;
@property(nonatomic,assign) id<typeSelectdelegate> delegate;
+(instancetype)typeselectViewWithFrame:(CGRect)frame;


/**
 *  蹦出弹窗
 */
-(void)pop;


/**
 *  隐藏弹窗
 */
-(void)hide;

@end
