//
//  UserInfoBasic.m
//  清房助手
//
//  Created by Larry on 12/31/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "UserInfoBasic.h"
#import "UIImageView+WebCache.h"

@interface UserInfoBasic ()
@property (strong, nonatomic)  UIImageView *iCoView;

@property (weak, nonatomic)  UILabel *QFuserName;

@property (weak, nonatomic)  UILabel *QFcompanyName;

@property (weak, nonatomic)  UILabel *QFuserID;

@property (weak, nonatomic)  UILabel *QFSex;

@property (weak, nonatomic)  UILabel *QFminzu;

@property (weak, nonatomic)  UILabel *QFbirthDate;

@property (weak, nonatomic)  UILabel *QFemail;

@property (weak, nonatomic)  UILabel *QFregion;
@end

@implementation UserInfoBasic

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iCoView.layer.cornerRadius = 25;
    self.iCoView.layer.masksToBounds = YES;
    self.navigationController.navigationBarHidden = YES;
    
}




/**
 *  更新数据
 */
-(void)displayDataFromNet {
    //头像
    NSString *urlStr = [NSString stringWithFormat:@"http://www.123qf.cn:81/portrait/%@/%@",self.QFDataDic[@"userid"],self.QFDataDic[@"portrait"]];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.iCoView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iCoView.image = image;
    }];
    //姓名
    self.QFuserName.text = self.QFDataDic[@"username"];
    //公司
    self.QFcompanyName.text = self.QFDataDic[@"name"];
    //手机号
    self.QFuserID.text =self.QFDataDic[@"tel"];
    //性别
    self.QFSex.text = self.QFDataDic[@"gender"];
    self.QFbirthDate.text = self.QFDataDic[@"birth"];
    self.QFemail.text = self.QFDataDic[@"mail"];
    self.QFregion.text =[NSString stringWithFormat:@"%@ %@ %@",self.QFDataDic[@"province"],self.QFDataDic[@"city"],self.QFDataDic[@"county"]];
}
@end
