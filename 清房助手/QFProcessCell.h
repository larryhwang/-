//
//  QFProcessCell.h
//  清房助手
//
//  Created by Larry on 12/25/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFProcessCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *QFProcessLabel;
@property (weak, nonatomic) IBOutlet UILabel *QFDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QFimg;
@property (weak, nonatomic) IBOutlet UIView *QF_VetiLine;

@property(nonatomic,assign) BOOL QF_isLastestCell;

@end
