//
//  InnerResourceFilter.h
//  清房助手
//
//  Created by Larry on 12/28/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InnerResourceFilter : UIViewController


@property(nonatomic,copy) void (^uptableData)( NSDictionary *newDic);

@end
