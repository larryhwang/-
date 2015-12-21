//
//  ZuGouDetailCell.h
//  清房助手
//
//  Created by Larry on 12/21/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZuGouDetailCell : UITableViewCell

//"region": "河南岸",
//"tingchechang": true,
//"biaoti": "1500-2000元2房 2厅",
//"tingshu": 2,
//"kuandai": null,
//"tel": "13516666006",
//"shengfen": "广东省",
//"userid": "13480556006",
//"pricef": 1500,
//"acreage": null,
//"jiadian": true,
//"publisher": "曾剑军",
//"fangshu": 2,
//"id": 5,
//"dianshi": null,
//"name": "悦和地产",
//"mingcheng": null,
//"qu": "惠城区",
//"shi": "惠州市",
//"tupian": null,
//"zhuangxiuyaoqiu": "精装修",
//"weituodate": "2015-11-02 10:31:45",
//"meiqi": null,
//"leixing": null,
//"zugou": false,
//"dianhua": null,
//"fangyuanmiaoshu": "以沃尔玛附近为佳",
//"pricel": 2000,
//"unit": "元",
//"balconys": 1,
//"fenlei": 0,
//"youxiaoqi": 1,
//"toilets": 1,
//"dianti": null
//}


@property (weak, nonatomic) IBOutlet UILabel *regionLabel;


@property (weak, nonatomic) IBOutlet UILabel *RoomStyleLabel;


@property (weak, nonatomic) IBOutlet UILabel *aceaLabel;


@property (weak, nonatomic) IBOutlet UILabel *DecorationLabel;

@property (weak, nonatomic) IBOutlet UILabel *Expritime;


@property (weak, nonatomic) IBOutlet UILabel *attachMent;


@end
