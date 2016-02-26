//
//  FlatLocationCell.h
//  清房助手
//
//  Created by Larry on 15/10/15.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlatLocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *PostTime;
@property (weak, nonatomic) IBOutlet UILabel *Price;
@property (weak, nonatomic) IBOutlet UILabel *LouPanName;
@property (weak, nonatomic) IBOutlet UILabel *Region;
@property (weak, nonatomic) IBOutlet UILabel *TittlePre;


@end