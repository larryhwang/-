//
//  FreeCell.h
//  清房助手
//
//  Created by Larry on 15/10/16.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeCell : UITableViewCell
{
   CGSize _ContextSize;
}


@property(nonatomic,strong)  UILabel  *Title;
@property(nonatomic,strong)  UILabel  *DynamicText;
@property(nonatomic) CGFloat CellHight;

-(instancetype)initWithTitle:(NSString *)title andContext:(NSString *)text ;
+(instancetype)freeCellWithTitle:(NSString *)title andContext:(NSString *)text;

@end
