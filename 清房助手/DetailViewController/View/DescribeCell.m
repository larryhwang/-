//
//  describeCell.m
//  清房助手
//
//  Created by Larry on 15/10/13.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "DescribeCell.h"

@implementation DescribeCell  





-(void)setDescribeText:(NSString *)context {
    
    self.Describe = [[UILabel alloc]init];
    self.Describe.numberOfLines = 0 ;
    [self.contentView addSubview:self.Describe];
    //self.backgroundColor = [UIColor greenColor];
    self.Describe.font = [UIFont systemFontOfSize:15];
    NSDictionary *attrs = @{NSFontAttributeName:self.Describe.font};
    CGRect frame = [self frame];
    CGSize size = CGSizeMake(ScreenWidth, 1000);
    self.Describe.text = context ;
    CGSize labelSize = [context boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    self.Describe.frame = CGRectMake(self.Describe.frame.origin.x, self.Describe.frame.origin.y, ScreenWidth, labelSize.height);
    frame.size.height = labelSize.height;
    self.frame = frame;
    

}



@end
