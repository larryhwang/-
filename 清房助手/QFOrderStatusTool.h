//
//  QFOrderStatusTool.h
//  清房助手
//
//  Created by Larry on 12/25/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFOrderStatusTool : NSObject


/**
 *
 *
 *  @param paystatus 支付方式
 *  @param osstatus  另一个状态
 *
 *  @return 返回订单状态
 */
+(NSString *)checkTypeWithpaystatus:(NSNumber *)paystatus andosstatus:(NSNumber *)osstatus ;

@end
