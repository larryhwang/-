//
//  QFOrderStatusTool.m
//  清房助手
//
//  Created by Larry on 12/25/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "QFOrderStatusTool.h"

@implementation QFOrderStatusTool

+(NSString *)checkTypeWithpaystatus:(NSNumber *)paystatus andosstatus:(NSNumber *)osstatus {
    NSString *returnStr = NULL;
    
    int a= paystatus.intValue;    int b = osstatus.intValue;
    
    char *status_type[5][17];
    status_type[0][0] = "等待收件";
    status_type[0][1] = "上门收件";
    status_type[0][2] = "等待评估";
    status_type[0][3] = "房产评估";
    status_type[0][4] = "等待签意向";
    status_type[0][5] = "银行签意向";
    status_type[0][6] = "等待交税";
    status_type[0][7] = "税局交税";
    status_type[0][8] = "等待交证";
    status_type[0][9] = "房管局交旧证";
    status_type[0][10] = "等待拿证";
    status_type[0][11] = "客户拿新证";
    status_type[0][12] = "等待抵押";
    status_type[0][13] = "抵押新证";
    status_type[0][14] = "完成";
    
    status_type[1][0] = "等待收件";
    status_type[1][1] = "上门收件";
    status_type[1][2] = "等待交税";
    status_type[1][3] = "税局交税";
    status_type[1][4] = "等待交证";
    status_type[1][5] = "房管局交旧证";
    status_type[1][6] = "等待拿证";
    status_type[1][7] = "客户拿新证";
    status_type[1][8] = "完成";
    
    status_type[2][0] = "等待收件";
    status_type[2][1] = "上门收件";
    status_type[2][2] = "等待解押";
    status_type[2][3] = "银行解押";
    status_type[2][4] = "等待评估";
    status_type[2][5] = "房产评估";
    status_type[2][6] = "等待签意向";
    status_type[2][7] = "银行签意向";
    status_type[2][8] = "等待交税";
    status_type[2][9] = "税局交税";
    status_type[2][10] = "等待交证";
    status_type[2][11] = "房管局交旧证";
    status_type[2][12] = "等待拿证";
    status_type[2][13] = "客户拿新证";
    status_type[2][14] = "等待抵押";
    status_type[2][15] = "抵押新证";
    status_type[2][16] = "完成";
    
    status_type[3][0] = "等待收件";
    status_type[3][1] = "上门收件";
    status_type[3][2] = "等待解押";
    status_type[3][3] = "银行解押";
    status_type[3][4] = "等待交税";
    status_type[3][5] = "税局交税";
    status_type[3][6] = "等待交证";
    status_type[3][7] = "房管局交旧证";
    status_type[3][8] = "等待拿证";
    status_type[3][9] = "客户拿新证";
    status_type[3][10] = "完成";
    
    
    returnStr = [NSString stringWithCString:status_type[a][b] encoding:NSUTF8StringEncoding];
    NSLog(@"状态返回:%@ %d,%d",returnStr,a,b);
    

    return returnStr;
}

@end
