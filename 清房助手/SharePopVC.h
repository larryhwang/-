//
//  SharePopVC.h
//  清房助手
//
//  Created by Larry on 1/28/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharePopdelegate <NSObject>


/**
 *  去掉底色模版
 */
-(void)removeDimBack;


/**
 *  点击分享按钮
 *
 *  @param index 区别分享类型
 */
-(void)QFsharedWith:(NSInteger) index;




@end

@interface SharePopVC : UIViewController


@property(nonatomic,assign) id <SharePopdelegate>  delegate;
@property (nonatomic, copy) void (^DismissView)(void);
@property(nonatomic,strong)  NSArray  *QFImgSAndTittleSDicArr;

@end
