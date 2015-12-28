//
//  InnerTabBarController.m
//  清房助手
//
//  Created by Larry on 12/19/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.

/**
 *   说明:  1.内部房源和内部客源都用同一个 InnerBasicViewController  类 ， 由参数决定申请展示内容
            2.
 *
 *
 */

//



#import "InnerTabBarController.h"
#import "InnerCustomer.h"
#import "InnerFangVC.h"
#import "TableViewController.h"
#import "InnerBasicViewController.h"
#import "HomeViewController.h"
#import "QFNavController.h"




@interface InnerTabBarController () {
    NSString   *_LeftListUrl;
    NSString *_RightListUrl;
}
@property(nonatomic,assign) TabBarType type;
@end

@implementation InnerTabBarController


-(id)initWithTabBarType:(TabBarType )type {
  //  self = [super init];
    self.type = type;
    if (self.type == FangYuan) {
        //公司房源
         _LeftListUrl  = @"http://www.123qf.cn:81/testApp/fkyuan/companyFKyuan.api?isfangyuan=1-c";
        
        //个人房源
         _RightListUrl = @"http://www.123qf.cn:81/testApp/fkyuan/companyFKyuan.api?isfangyuan=1-c";
    } else {
         // 公司客源
          _LeftListUrl  = @"http://www.123qf.cn:81/testApp/fkyuan/companyFKyuan.api?isfangyuan=0-c";
       
          // 个人客源
          _RightListUrl = @"http://www.123qf.cn:81/testApp/fkyuan/companyFKyuan.api?isfangyuan=0-u";
        // 个人客源

    }

    
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllChildViewController];
}





- (void)setUpAllChildViewController
{
    InnerBasicViewController *LeftViewController =   [[InnerBasicViewController alloc]initWithUrl:_LeftListUrl] ;
    
    LeftViewController.type = _type;
    [self setUpOneChildViewController:LeftViewController image:[UIImage imageNamed:@"company"] title:@"公司"];
    
    
    InnerBasicViewController *RightViewController = [[InnerBasicViewController alloc]initWithUrl:_RightListUrl];
     RightViewController.type = _type;
    [self setUpOneChildViewController:RightViewController image:[UIImage imageNamed:@"person"] title:@"个人"];
    
}


- (void)setUpOneChildViewController:(InnerBasicViewController *)vc image:(UIImage *)image  title:(NSString *)title
{

    vc.title = title;
    vc.tabBarItem.image = image;
    vc.type = _type;
    
    QFNavController *nav = [[QFNavController alloc] initWithRootViewController:vc];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

    [self addChildViewController:nav];

}




//返回系统首页
-(void)Dissback {
    [self dismissViewControllerAnimated:YES completion:nil];
    HomeViewController *home = [HomeViewController new];
    KeyWindow.rootViewController = home;
}

//筛选
-(void)ConditionsFilter {
    NSLog(@"筛选,待建设");
    //    FilterViewController *FVC =[[FilterViewController alloc]init];
    //    FVC.filterStatus = self.ResultListStatus;
    //    FVC.param = _searchParam;  //就是输入文字后，返回某某几件的title
    //    FVC.title = @"筛选条件";
    //    FVC.delegate = self;
    //    [self.navigationController pushViewController:FVC animated:YES];
    
}
@end
