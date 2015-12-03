//
//  SelectJie.h
//  上传模块测试
//
//  Created by Larry on 15/11/5.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectRegionVC.h"

@interface SelectJie : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *SteetTables;
@property(nonatomic,strong)  NSArray  *JieArr;
@property(nonatomic,assign)  id<SelectRegionDelegate> delegate;;

@end
