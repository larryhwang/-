//
//  PopSelectViewController.h
//  用scollview做表格
//
//  Created by Larry on 15/11/16.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopSelectViewController : UIViewController
@property(nonatomic,strong)  NSArray  *pikerDataArr;
@property (nonatomic, copy) void (^DismissView)(void);
@property (nonatomic, copy) void (^SureBtnAciton)(NSString *passString);
@end
