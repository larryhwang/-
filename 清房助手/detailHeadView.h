//
//  detailHeadView.h
//  清房助手
//
//  Created by Larry on 12/25/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel  *QFProcessStatus;

@property (weak, nonatomic) IBOutlet UILabel  *QFOrderNO;

@property (weak, nonatomic) IBOutlet UILabel  *QFServiceType;

@property (weak, nonatomic) IBOutlet UILabel  *QFCreateTime;

@property (weak, nonatomic) IBOutlet UILabel  *QFIntermeName;

@property (weak, nonatomic) IBOutlet UIButton *QFIntermTeleNO;

@property (weak, nonatomic) IBOutlet UILabel  *QFIntermeAdress;

@property (weak, nonatomic) IBOutlet UILabel  *QFBuyerName;

@property (weak, nonatomic) IBOutlet UIButton *QFBuyerTeleNO;

@property (weak, nonatomic) IBOutlet UILabel  *QFSalerName;

@property (weak, nonatomic) IBOutlet UIButton *QFSalerBtn;

@property(nonatomic,weak) NSDictionary *QFheadViewDic;




@end
