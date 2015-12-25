//
//  MyOrderCell.m
//  清房助手
//
//  Created by Larry on 12/24/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setCellDataDic:(NSDictionary *)CellDataDic {
    self.QFOrderNo.text      = CellDataDic[@""];
    self.QFOrderStatus.text  = CellDataDic[@""];
    self.QFServiceType.text  = CellDataDic[@""];
    self.QFChargePerson.text = CellDataDic[@""];
    self.QFChargeTeleNo.text = CellDataDic[@""];
    self.QFChargeTeleNo.text = CellDataDic[@""];
 }




@end
