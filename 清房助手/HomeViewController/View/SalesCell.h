//
//  SalesCell.h
//  清房助手
//
//  Created by Larry on 15/10/12.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *QFImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *style;
@property (weak, nonatomic) IBOutlet UILabel *elevator;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *postUer;
@property (weak, nonatomic) IBOutlet UILabel *postTime;


@property (weak, nonatomic) IBOutlet UILabel *QFZhuangTai;




@end
