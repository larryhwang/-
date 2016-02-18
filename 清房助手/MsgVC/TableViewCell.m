//
//  TableViewCell.m
//  清房助手
//
//  Created by Larry on 2/2/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "TableViewCell.h"



@interface TableViewCell()<UIAlertViewDelegate> {
    __weak IBOutlet UILabel *MsgType;
    __weak IBOutlet UILabel *MsgTime;
    __weak IBOutlet UILabel *MsgName;
    __weak IBOutlet UILabel *Tele;
    __weak IBOutlet UILabel *WeChat;
    __weak IBOutlet UILabel *Descibe;
}

@end

@implementation TableViewCell

- (IBAction)test:(id)sender {
     NSLog(@"DEBUG");
    if (Tele.text.length >1) {
       [self TeleTap:nil];
    }
    
}

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
    
    if (Tele.text.length >1) {
   UITapGestureRecognizer *TeleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TeleTap:)];
        [Tele addGestureRecognizer:TeleTap];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)TeleTap:(id)sender {

    UIAlertView *AW = [[UIAlertView alloc]initWithTitle:nil
                                                message:_CellDic[@"phone"]
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"呼叫", nil];
    AW.tag = 0;
    [AW show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *tele =[NSString stringWithFormat:@"tel://%@", _CellDic[@"phone"]];//;
    if(buttonIndex == 1 && alertView.tag==0 ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tele]];
    } else {
        
        return ;
    }
}

@end
