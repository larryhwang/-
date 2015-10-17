//
//  FreeCell.m
//  清房助手
//
//  Created by Larry on 15/10/16.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "FreeCell.h"
#define ScreenWidth    [UIScreen mainScreen].bounds.size.width
@implementation FreeCell



-(UILabel *)Title {
    if (_Title == nil) {
        _Title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    }
    return _Title;
}

-(UILabel *)DynamicText {
    if (_DynamicText == nil) {
        _DynamicText =[[UILabel alloc]init];
        _DynamicText.numberOfLines = 0;
    }
    return _DynamicText;
}

-(instancetype)initWithTitle:(NSString *)title andContext:(NSString *)text
{
    self = [super init];
    if (self) {
        CGSize MaxSize = CGSizeMake(ScreenWidth - Pading, 200);
        _iSSeparetorLine = YES ;
        _HeaderPart = title;
        NSString *allContent = [NSString stringWithFormat:@"   %@:   %@",self.HeaderPart,text];
        UIFont *DeafualtFont = [UIFont systemFontOfSize:17];
        _ContextSize = [self sizeWithString:allContent font:DeafualtFont maxSize:MaxSize];
        NSLog(@"接受到的%f",_ContextSize.height);
        _CellHight = _ContextSize.height + 2;
        self.DynamicText.text = allContent;  //全部的内容设置
        NSLog(@"%f",_ContextSize.height);
        [self.DynamicText setFrame:CGRectMake(Pading/2, Pading/3, _ContextSize.width, _ContextSize.height)];
        self.Title.backgroundColor =  [UIColor redColor];
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
    
    if(_iSSeparetorLine) {
        UIView *separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, _ContextSize.height+5, ScreenWidth, 1)];
        separateLine.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:separateLine];   //增加分割线
    }
}

- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{

    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    NSLog(@"内部设置的尺寸变化%f",size.height);
    return size;
}



@end
