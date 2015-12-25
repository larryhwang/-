//
//  MyOrderCell.h
//  清房助手
//
//  Created by Larry on 12/24/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *QFOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *QFOrderStatus;
@property (weak, nonatomic) IBOutlet UILabel *QFServiceType;
@property (weak, nonatomic) IBOutlet UILabel *QFOrderCrtTime;
@property (weak, nonatomic) IBOutlet UILabel *QFChargePerson;
@property (weak, nonatomic) IBOutlet UILabel *QFChargeTeleNo;

@property(nonatomic,strong) NSDictionary *QFCellDataDic;

@end
