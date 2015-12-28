//
//  QFDateSelectStartToEnd.h
//  清房助手
//
//  Created by Larry on 12/28/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFDateSelectStartToEnd : UIViewController

@property (nonatomic, copy) void (^DismissView)(void);
@property (nonatomic, copy) void (^SureBtnAciton)(NSString *passString);

@end
