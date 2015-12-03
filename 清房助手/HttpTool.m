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

@end
