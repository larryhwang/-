//
//  LoginViewController.m
//  清房助手
//
//  Created by Larry on 15/10/8.
//  Copyright © 2015年 Larry. All rights reserved.
//
#warning 记住密码
#warning 4s和5点击文本框后整体
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+CZ.h"
#import "HomeViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation LoginViewController
-(id)init {
    [self BasicUIset];
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)loginClick:(id)sender {
#warning 加密处理
    NSString   *userName = self.userName.text;
    NSString   *passWord = self.passWord.text;
    
    NSMutableDictionary *PramaDic = [NSMutableDictionary new];
    
    PramaDic[@"userID"] = userName;
    PramaDic[@"psWord"] = passWord;
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    NSString *completeUrl = [NSString stringWithFormat:@"%@/qfzsapi/user/loginUser.api",BasicUrl];
    NSLog(@"%@",completeUrl);
    HomeViewController *home = [HomeViewController new];
   // KeyWindow.rootViewController = home;
   [mgr POST:completeUrl parameters:PramaDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showMessage:@"正在登录"];
        NSLog(@"返回值%@",responseObject[@"code"]);
       if (responseObject) {
        [MBProgressHUD hideHUD];
       }
       long Cp=[responseObject[@"code"] integerValue];
       if (Cp==1) {
         [self loginErroAlert];
       }else{
          //进入主界面
           HomeViewController *home = [HomeViewController new];
           KeyWindow.rootViewController = home;
        
           
       }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",error);
   }];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)BasicUIset {
    self.view.backgroundColor =  QFUIRGBColor(3, 164, 255);    //浅蓝的感觉
    if (isI4 || isI5) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}


-(void)willShow:(NSNotificationCenter *)notifInfo {
    [UIView animateWithDuration:0.25 animations:^{
        if(isI4) {
        self.view.transform = CGAffineTransformMakeTranslation(0, -165);
        }else {
        self.view.transform = CGAffineTransformMakeTranslation(0, -70);
        }
    }];
}



-(void)willHide:(NSNotificationCenter *)notifInfo {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform =  CGAffineTransformIdentity;
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];   
}

-(void)loginErroAlert {
    UIAlertView *AW = [[UIAlertView alloc]initWithTitle:@"账户或密码错误"
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
    
    [AW show];
}

@end
