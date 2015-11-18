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
    //http://127.0.0.1:8080/qfzsapi/user/loginUser.front?userID=admin&psWord=2
    //http://www.123qf.cn/testApp/user/loginUser.front?userID=15018639039&psWord=5798161"
    PramaDic[@"userid"] = @"15018639039";
    PramaDic[@"psword"] = @"5798161";
    
    
    //    NSString *completeUrl = @"http://www.123qf.cn:81/testApp/user/loginUser.front?userid=15018639039&psword=5798161";
    /*
     15018639039  123456
     */
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    NSString *completeUrl = @"http://www.123qf.cn:81/testApp/user/loginUser.front";
    HomeViewController *home = [HomeViewController new];
   // KeyWindow.rootViewController = home;
   [mgr POST:completeUrl parameters:PramaDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"修理:%@",responseObject);
        [MBProgressHUD showMessage:@"正在登录"];
       if (responseObject) {
        [MBProgressHUD hideHUD];
       }
       long Cp=[responseObject[@"code"] integerValue];
       if (Cp==1) {
           HomeViewController *home = [HomeViewController new];
           KeyWindow.rootViewController = home;
       }else{
          //进入主界面
           [self loginErroAlert];
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
