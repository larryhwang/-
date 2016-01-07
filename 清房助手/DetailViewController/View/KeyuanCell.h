//
//  KeyuanCell.h
//  清房助手
//
//  Created by Larry on 12/20/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyuanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titileLabel;

@property (weak, nonatomic) IBOutlet UILabel *acreaLabel;


@property (weak, nonatomic) IBOutlet UILabel *roomsContLabel;


@property (weak, nonatomic) IBOutlet UILabel *attachmentLabel;


@property (weak, nonatomic) IBOutlet UILabel *requestDescrbeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;

@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *QFZhuangTai;


@end
