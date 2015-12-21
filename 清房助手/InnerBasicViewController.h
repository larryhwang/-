//
//  InnerBasicViewController.h
//  清房助手
//
//  Created by Larry on 12/20/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#include "TableViewController.h"

@interface InnerBasicViewController : UIViewController
@property(nonatomic,strong)  UISearchController  *searchVC;
@property(nonatomic,weak)    TableViewController               *ResultTableView;
@property(nonatomic,assign) TabBarType type;


//将初始界面的URL请求传过去
-(id)initWithUrl:(NSString *)CurrentTableUrl;

@end
