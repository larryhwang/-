//
//  FreeCell.m
//  清房助手
//
//  Created by Larry on 15/10/16.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "FreeCell.h"

@implementation FreeCell


-(instancetype)initWithTitle:(NSString *)title andContext:(NSString *)text
{
    self = [super init];
    if (self) {
        CGSize MaxSize = CGSizeMake(ScreenWidth - 12, 30);
        self.Title.text = title;
        UIFont *DeafualtFont = [UIFont systemFontOfSize:17];
        self.DynamicText.text = text ;
        _ContextSize = [self sizeWithString:self.DynamicText.text font:DeafualtFont maxSize:MaxSize];

        [self.contentView addSubview:self.Title];
        [self.contentView addSubview:self.DynamicText];
        
    }
    return  self;
}

+(instancetype)freeCellWithTitle:(NSString *)title andContext:(NSString *)text {
    return [[self alloc]initWithTitle:title andContext:text];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [self.Title setFrame:CGRectMake(0, 0, 10, 20)];
    [self.DynamicText setFrame:CGRectMake(10, 0, _ContextSize.width, _ContextSize.height)];
    
}


- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}



@end
