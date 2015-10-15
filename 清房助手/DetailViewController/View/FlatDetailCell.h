//
//  FlatDetailCell.h
//  清房助手
//
//  Created by Larry on 15/10/15.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlatDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *FlatType;

@property (weak, nonatomic) IBOutlet UILabel *Decrorelation;

@property (weak, nonatomic) IBOutlet UILabel *FloatNo;

@property (weak, nonatomic) IBOutlet UILabel *LookTime;

@property (weak, nonatomic) IBOutlet UILabel *WithFacility;

@property (weak, nonatomic) IBOutlet UILabel *ExtryTime;

@property (weak, nonatomic) IBOutlet UILabel *Direction;
@property (weak, nonatomic) IBOutlet UILabel *Area;
@property (weak, nonatomic) IBOutlet UILabel *Type;

@end
