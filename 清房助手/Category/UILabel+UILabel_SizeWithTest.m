//
//  UILabel+UILabel_SizeWithTest.m
//  清房助手
//
//  Created by Larry on 15/10/16.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "UILabel+UILabel_SizeWithTest.h"

@implementation UILabel (UILabel_SizeWithTest)

- (void)verticalUpAlignmentWithText:(NSString *)text maxHeight:(CGFloat)maxHeight
{
    CGRect frame = self.frame;
    CGSize size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(frame.size.width, maxHeight)];
    frame.size = CGSizeMake(frame.size.width, size.height);
    self.frame = frame;
    self.text = text;
}


@end
