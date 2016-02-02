//
//  MsgViewController.h
//  清房助手
//
//  Created by Larry on 2/2/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *MsgTable;


@property(nonatomic,strong)  NSArray  *MsgArr;
@end
