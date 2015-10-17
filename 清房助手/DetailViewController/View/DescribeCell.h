//
//  describeCell.h
//  清房助手
//
//  Created by Larry on 15/10/13.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreeCell.h"

@interface DescribeCell : FreeCell

@property (strong, nonatomic)  UILabel *Describe;


-(void)setDescribeText:(NSString *)context;

@end
