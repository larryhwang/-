//
//  SalesCell.m
//  清房助手
//
//  Created by Larry on 15/10/12.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "SalesCell.h"


@interface SalesCell()



@end

@implementation SalesCell

- (void)awakeFromNib {

    self.QFZhuangTai.layer.borderWidth  = .5;
    self.QFZhuangTai.layer.cornerRadius = 8.0;
    self.QFZhuangTai.layer.borderColor = [DeafaultColor2 CGColor];
    self.QFZhuangTai.textAlignment = NSTextAlignmentCenter;

    
}



@end
