//
//  HttpTool.m
//  上传模块测试
//
//  Created by Larry on 15/10/30.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "HttpTool.h"

@implementation HttpTool

+(void)QFGet:(NSString *)urlString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);  //作为参数传过去
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}



/**
 *  判断返回是否成功
 *
 *  @param Datarespon <#Datarespon description#>
 *
 *  @return <#return value description#>
 */

+(BOOL)isRequestSuccessWith:(NSDictionary *)Datarespon andKeyStr:(NSString *)str {
    NSNumber *no = [NSNumber numberWithInt:1];
    if([(NSNumber *)Datarespon[str] isEqualToNumber:no]) {
        return true;
    } else {
       return false;
    }
}






/**
 *  心跳请求,若成功则返回消息列表数组
 *
 *  @param success 执行片段  //NSString *urlString = @"http://www.123qf.cn/app/pant.api"
 */
+(void)keepDectectMessageWithSucess:(void(^)(NSArray *MsgArr)) success {
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = .5;
    NSString *urlString = @"http://www.123qf.cn/app/pant.api";//http://www.123qf.cn/app/user/getUserInfo.api";;//pant.api
    [mgr POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if([self isRequestSuccessWith:responseObject andKeyStr:@"c"]) {
            NSArray *arr = responseObject[@"d"];
            success(arr);
        } else {
            NSArray *arr =@[];
            success(arr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
       NSLog(@"heartBeatErr:%@",error);
    }];
 
}



@end
