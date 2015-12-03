//
//  MUtiSelectViewController.h
//  用scollview做表格
//
//  Created by Larry on 15/11/21.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUtiSelectViewController : UIViewController

@property(nonatomic,weak) NSMutableDictionary *HandleDic;
@property(nonatomic,weak) UITextField *HandleTextField;
@property(nonatomic,weak) NSMutableSet *hasSelectedArrar;

@end
