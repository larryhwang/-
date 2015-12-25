//
//  QFProcessCell.m
//  清房助手
//
//  Created by Larry on 12/25/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "QFProcessCell.h"

@implementation QFProcessCell

- (void)awakeFromNib {
    self.QFProcessLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(void)setIsLastestCell:(BOOL)QF_isLastestCell {

}

-(void)setQF_isLastestCell:(BOOL)QF_isLastestCell {
    _QF_isLastestCell = QF_isLastestCell;
    if (_QF_isLastestCell) {
        //若是最新进展的Cell，则把颜色全部换掉
        
        CGRect newRect = CGRectMake(self.QF_VetiLine.frame.origin.x, self.QF_VetiLine.frame.origin.y + 100, self.QF_VetiLine.frame.size.width, self.QF_VetiLine.frame.size.height);
        [self.QFDateLabel setTextColor:[UIColor blueColor]];
        [self.QFimg setImage:[UIImage imageNamed:@"60x60-hui (2)"]];
        [self.QFProcessLabel setTextColor:[UIColor blueColor]];
        [self.QF_VetiLine setFrame:newRect];
    }
}


@end
