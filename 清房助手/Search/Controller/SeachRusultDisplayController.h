//
//  SeachRusultDisplayController.h
//  清房助手
//
//  Created by Larry on 12/8/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeachRusultDisplayController : UIViewController
/**
 *  图列表数据结果
 */
@property(nonatomic,weak)    NSArray    *resultDataArr;
@property(nonatomic,copy)    NSString   *searchParam;
@property(nonatomic,assign)  CellStatus ResultListStatus;
@property(nonatomic,strong)  NSArray    *dataFromNet;

@end
