//
//  PermissionTool.m
//  清房助手
//
//  Created by Larry on 2/2/16.
//  Copyright © 2016 ; S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "PermissionTool.h"
#import "AppDelegate.h"

@implementation PermissionTool



/**
 *  判断是否拥有该权限
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)isHavePermisson:(NSString *)name{
   __block    BOOL flag = NO;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [(NSArray *)delegate.QFUserPermissionDic_NSMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(NSString *)obj isEqualToString:name]) {
            NSLog(@"一个:%@",name);
            flag  = YES;
            *stop = YES;
        };
        
    }];
   
    return flag;
}
@end
