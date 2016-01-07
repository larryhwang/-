//
//  KeyuanCell.m
//  清房助手
//
//  Created by Larry on 12/20/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "KeyuanCell.h"

@implementation KeyuanCell

- (void)awakeFromNib {
    self.QFZhuangTai.layer.borderWidth  = .5;
    self.QFZhuangTai.layer.cornerRadius = 8.0;
    self.QFZhuangTai.layer.borderColor = [DeafaultColor2 CGColor];
    self.QFZhuangTai.textAlignment = NSTextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
