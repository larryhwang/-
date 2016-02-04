//
//  TableViewCell.m
//  清房助手
//
//  Created by Larry on 2/2/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "TableViewCell.h"



@interface TableViewCell() {
    __weak IBOutlet UILabel *MsgType;
    __weak IBOutlet UILabel *MsgTime;
    __weak IBOutlet UILabel *MsgName;
    __weak IBOutlet UILabel *Tele;
    __weak IBOutlet UILabel *WeChat;
    __weak IBOutlet UILabel *Descibe;
}

@end

@implementation TableViewCell


//
//fid = 297;
//gouShou = 0;
//miaoshu = "";
//phone = "\U4ed6\U2026\Uff01 ";
//senderName = "\U60e0";
//title = "\U6c5f\U5357\U5fa1\U90fd";
//weixinNum = "\U4f3c\U4e4e";

-(void)setCellDic:(NSDictionary *)CellDic {
    _CellDic = CellDic;
    if ([_CellDic[@"gouShou"] isEqualToString:@"0"] ) {
        MsgType.text = @"求购消息";
    } else {
        MsgType.text = @"卖房消息";
    }
    
    MsgTime.text = _CellDic[@"createtime"];
    MsgName.text = _CellDic[@"senderName"];
    Tele.text    = _CellDic[@"phone"];
    WeChat.text  = _CellDic[@"weixinNum"];
    Descibe.text = _CellDic[@"miaoshu"];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
