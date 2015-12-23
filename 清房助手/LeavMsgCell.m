//
//  LeavMsgCell.m
//  清房助手
//
//  Created by Larry on 12/22/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "LeavMsgCell.h"

@interface LeavMsgCell() {
    
    __weak IBOutlet UILabel *QFname;
    
    __weak IBOutlet UILabel *QFteleNo;
    
    __weak IBOutlet UILabel *QFResonContent;
    
    __weak IBOutlet UILabel *QFDate;
    
    NSDictionary *_SingleDic;
}

@end

@implementation LeavMsgCell

//
//-(void)setSingleCellDataDic:(NSDictionary *)SingleCellDataDic {
//    _SingleDic = SingleCellDataDic;
//    QFname.text   = _SingleDic[@"username"];
//    QFteleNo.text = _SingleDic[@"tel"];
//    QFResonContent.text =_SingleDic[@"content"];
//    QFDate.text =_SingleDic[@"createtime"];
//}

-(void)setQFSingleCellDataDic:(NSDictionary *)QFSingleCellDataDic{
        _SingleDic = QFSingleCellDataDic;
        QFname.text   = _SingleDic[@"username"];
        QFteleNo.text = _SingleDic[@"tel"];
        QFResonContent.text =_SingleDic[@"content"];
        QFDate.text =_SingleDic[@"createtime"];
}

- (void)awakeFromNib {
    QFResonContent.numberOfLines = 0 ;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
