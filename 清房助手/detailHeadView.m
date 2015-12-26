//
//  detailHeadView.m
//  清房助手
//
//  Created by Larry on 12/25/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "detailHeadView.h"
#import "QFOrderStatusTool.h"

@implementation detailHeadView



-(void)setQFheadViewDic:(NSDictionary *)QFheadViewDic {
    NSNumber *serviceTypeNo = QFheadViewDic[@"servicetype"];
    
    NSNumber *serviceType_a = QFheadViewDic[@"servicetype"];
    NSNumber *serviceType_b = QFheadViewDic[@"ostatus"];
    
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
    
    _QFProcessStatus.text = statusStr;
    _QFOrderNO.text       = QFheadViewDic[@"ordernum"];
    _QFServiceType.text   = serviceStr;
    _QFCreateTime.text    = QFheadViewDic[@"createtime"];
    _QFIntermeName.text   = QFheadViewDic[@"username"];
    [_QFIntermTeleNO setTitle:QFheadViewDic[@"tel"] forState:UIControlStateNormal];
    _QFIntermeAdress.text = QFheadViewDic[@"addr"];
    _QFBuyerName.text     = QFheadViewDic[@"buyername"];
    [_QFBuyerTeleNO setTitle:QFheadViewDic[@"buyertel"] forState:UIControlStateNormal];
    _QFSalerName.text     = QFheadViewDic[@"sellername"];
    [_QFSalerBtn setTitle:QFheadViewDic[@"sellertel"] forState:UIControlStateNormal];
}



@end
