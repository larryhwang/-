//
//  UserInfoVC_iSIX.m
//  清房助手
//
//  Created by Larry on 12/30/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "UserInfoVC_iSIX.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface UserInfoVC_iSIX ()



@property (strong, nonatomic) IBOutlet UIImageView *iCoView;

@property (weak, nonatomic) IBOutlet UILabel *QFuserName;

@property (weak, nonatomic) IBOutlet UILabel *QFcompanyName;

@property (weak, nonatomic) IBOutlet UILabel *QFuserID;

@property (weak, nonatomic) IBOutlet UILabel *QFSex;

@property (weak, nonatomic) IBOutlet UILabel *QFminzu;

@property (weak, nonatomic) IBOutlet UILabel *QFbirthDate;

@property (weak, nonatomic) IBOutlet UILabel *QFemail;

@property (weak, nonatomic) IBOutlet UILabel *QFregion;


@end

@implementation UserInfoVC_iSIX


- (void)viewDidLoad {
    [super viewDidLoad];
    self.iCoView.layer.cornerRadius = 35;
     self.iCoView.layer.masksToBounds = YES;
    self.navigationController.navigationBarHidden = YES;
    [self displayDataFromNet];
    self.view.tag = 9;
    
    UIView *ban = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    ban.alpha = 0.5;
    
    NSLog(@"banView %@",ban);
    NSLog(@"导航栏的View %@",self.navigationController.view);
    
    self.navigationItem.hidesBackButton =YES;
    

    
    ban.userInteractionEnabled = NO;
    ban.backgroundColor = [UIColor lightGrayColor];
 //  [self.view addSubview:ban];
    
  // self.navigationController.view.userInteractionEnabled = NO ;
    
    
    UIWindow *window = [[UIWindow alloc]init];
    window.backgroundColor = [UIColor lightGrayColor];
    window.alpha = .5;
 //   [self.view addSubview:window];

}




//[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_background.png"] forBarMetrics:UIBarMetricsDefault];
//self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

/**
 *  更新数据
 */
-(void)displayDataFromNet {
    

    
    //头像
    NSString *urlStr = [NSString stringWithFormat:@"http://www.123qf.cn:81/portrait/%@/%@",self.QFDataDic[@"userid"],self.QFDataDic[@"portrait"]];
    
    NSLog(@"FUCK-IMG:%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.iCoView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"FUCK-IMGError:%@",error);
        NSLog(@"FUCK-IMG");
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


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;

}



@end
