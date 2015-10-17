//
//  FreeCell.h
//  清房助手
//
//  Created by Larry on 15/10/16.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>


#define Pading 12
@interface FreeCell : UITableViewCell
{
   CGSize _ContextSize;
}


@property(nonatomic,strong)  UILabel  *Title;
@property(nonatomic,copy) NSString *HeaderPart;
@property(nonatomic,strong)  UILabel  *DynamicText;
@property(nonatomic) CGFloat CellHight;
@property(nonatomic) BOOL iSSeparetorLine;

-(instancetype)initWithTitle:(NSString *)title andContext:(NSString *)text ;
+(instancetype)freeCellWithTitle:(NSString *)title andContext:(NSString *)text;

@end
