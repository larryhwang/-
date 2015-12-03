//
//  SelectCityVC.h
//  上传模块测试
//
//  Created by Larry on 15/11/5.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectRegionVC.h"


@interface SelectCityVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *CitiesTable;
@property(nonatomic,strong)  NSArray  *CitiesArr;
@property(nonatomic,assign)  id<SelectRegionDelegate> delegate;;
@end
