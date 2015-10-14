//
//  DetailCell.h
//  清房助手
//
//  Created by Larry on 15/10/13.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FactoryDetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *Decoration;

@property (weak, nonatomic) IBOutlet UILabel *ManerFee;

@property (weak, nonatomic) IBOutlet UILabel *LookTime;
@property (weak, nonatomic) IBOutlet UILabel *Area;
@property (weak, nonatomic) IBOutlet UILabel *Type;


@property (weak, nonatomic) IBOutlet UILabel *Expiry;



@end
