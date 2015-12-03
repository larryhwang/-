//
//  HttpTool.h
//  上传模块测试
//
//  Created by Larry on 15/10/30.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface HttpTool : NSObject

+ (void)QFGet: (NSString *)urlString
                        parameters:(id)parameters
                           success:(void (^) (id responseObject))success
                           failure:(void (^)(NSError *error))failure;


@end
