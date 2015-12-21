//
//  LesveMsgVC.h
//  清房助手
//
//  Created by Larry on 12/21/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LesveMsgVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *ownerName;

@property (weak, nonatomic) IBOutlet UILabel *ownerTele;

@property (weak, nonatomic) IBOutlet UITextView *CheckReason;

@property (copy, nonatomic)  NSString *ownerNameStr;

@property (copy, nonatomic)  NSString *ownerTeleStr;


@end
