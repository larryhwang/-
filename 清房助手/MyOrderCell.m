//
//  MyOrderCell.m
//  清房助手
//
//  Created by Larry on 12/24/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "MyOrderCell.h"
#import "QFOrderStatusTool.h"

@implementation MyOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setQFCellDataDic:(NSDictionary *)QFCellDataDic {
    _QFCellDataDic = QFCellDataDic;
    NSLog(@"%@",QFCellDataDic);
    NSNumber *serviceTypeNo = _QFCellDataDic[@"servicetype"];
    
    NSNumber *serviceType_a = _QFCellDataDic[@"servicetype"];
    NSNumber *serviceType_b = _QFCellDataDic[@"ostatus"];
    
    //获取订单状态
    NSString *statusStr = [QFOrderStatusTool checkTypeWithpaystatus:serviceType_a andosstatus:serviceType_b];
    
    NSString *serviceStr = NULL;
    
    switch (serviceTypeNo.intValue) {
        case 0:
            serviceStr = @"房产证在手－按揭付款";
            break;
        case 1:
            serviceStr = @"房产证在手－一次性付款";
            break;
        case 2:
            serviceStr = @"房产证不在手－按揭付款";
            break;
        case 3:
            serviceStr = @"房产证不在手－一次性付款";
            break;
        default:
            break;
    }
    
    
    
    
    NSNumber *StatusNo = _QFCellDataDic[@"servicetype"];
    NSString *StatusNoStr = NULL;
    
    switch (StatusNo.intValue) {
        case 0:
            StatusNoStr = @"房产证在手－按揭付款";
            break;
        case 1:
            StatusNoStr = @"房产证在手－一次性付款";
            break;
        case 2:
            StatusNoStr = @"房产证不在手－按揭付款";
            break;
        case 3:
            StatusNoStr = @"房产证不在手－一次性付款";
            break;
        default:
            break;
    }
    
    
    self.QFOrderNo.text      = _QFCellDataDic[@"ordernum"];
    self.QFOrderStatus.text  = statusStr;
    self.QFServiceType.text  = serviceStr;
    self.QFOrderCrtTime.text = _QFCellDataDic[@"createtime"];
    self.QFChargePerson.text = _QFCellDataDic[@"picname"];
    self.QFChargeTeleNo.text = _QFCellDataDic[@"pictel"];
 }




@end
