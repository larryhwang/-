//
//  FilterViewController.h
//  清房助手
//
//  Created by Larry on 12/10/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeachRusultDisplayController.h"

@interface FilterViewController : UIViewController

@property(nonatomic,copy)   NSString *param;
@property(nonatomic,assign) CellStatus filterStatus;
@property(nonatomic,assign) id<SeachRusultDisplayVCdelegate> delegate;

@end
