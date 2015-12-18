//
//  SettingViewCotroller.m
//  清房助手
//
//  Created by Larry on 12/18/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "SettingViewCotroller.h"
#import "MBProgressHUD+CZ.h"

#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>


@interface SettingViewCotroller ()

@end

@implementation SettingViewCotroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)checkUpadate:(id)sender {

    
    [[PgyUpdateManager sharedPgyManager] checkUpdate];  //检查更新
    
    
    
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
    NSLog(@"就在这里啊");

}


- (void)updateMethod:(NSDictionary *)response
{
    NSLog(@"Pgy Dic :%@",response);
    if (response[@"downloadURL"]) {

    }else{
        NSString *message = response[@"releaseNote"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前已是最新版本了"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil,
                                  nil];
        
        [alertView show];
    }
    
    //    调用checkUpdateWithDelegete后可用此方法来更新本地的版本号，如果有更新的话，在调用了此方法后再次调用将不提示更新信息。
    //        [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
}
@end
