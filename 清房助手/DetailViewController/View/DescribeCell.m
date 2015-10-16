//
//  describeCell.m
//  清房助手
//
//  Created by Larry on 15/10/13.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "DescribeCell.h"

@implementation DescribeCell  



- (void)awakeFromNib {
    
}

-(void)setDescribeText:(NSString *)context {
    /*
     CGRect frame = [self frame];
     //文本赋值
     self.introduction.text = text;
     //设置label的最大行数
     self.introduction.numberOfLines = 10;
     CGSize size = CGSizeMake(300, 1000);
     CGSize labelSize = [self.introduction.text sizeWithFont:self.introduction.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
     
     self.introduction.frame = CGRectMake(self.introduction.frame.origin.x, self.introduction.frame.origin.y, labelSize.width, labelSize.height);

     //计算出自适应的高度
     frame.size.height = labelSize.height+100;
     self.frame = frame;
     */
    CGRect frame = [self frame];
    CGSize size = CGSizeMake(ScreenWidth, 1000);
    self.Describe.text = context ;
    CGSize labelSize = [self.Describe.text sizeWithFont:self.Describe.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.Describe.frame = CGRectMake(self.Describe.frame.origin.x, self.Describe.frame.origin.y, labelSize.width, labelSize.height);
    frame.size.height = labelSize.height+100;
    self.frame = frame;
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
