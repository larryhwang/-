//
//  SelectQu.h
//  上传模块测试
//
//  Created by Larry on 15/11/5.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectRegionVC.h"
@interface SelectQu : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *Qutables;
@property(nonatomic,strong)  NSArray  *QuArr;
@property(nonatomic,assign)  id<SelectRegionDelegate> delegate;;

@end
