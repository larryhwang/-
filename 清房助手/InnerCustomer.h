//
//  InnerCustomer.h
//  清房助手
//
//  Created by Larry on 12/19/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InnerBasicViewController.h"

@interface InnerCustomer : InnerBasicViewController

@property(nonatomic,assign)  CellStatus ResultListStatus;
@property(nonatomic,)  UISearchController  *searchVC;
@end
