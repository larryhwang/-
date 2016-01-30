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
#import "AppDelegate.h"
#import "LoacationNameTool.h"

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
     self.userName.keyboardType = UIKeyboardTypeNumberPad ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
     NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"acount"];
    NSString *pw = [[NSUserDefaults standardUserDefaults]objectForKey:@"pw"];
    if (name.length>0) {
        self.userName.text = name;
    }   else {
        self.userName.text =@"";
    }
    self.passWord.text = pw;
}


- (IBAction)loginClick:(id)sender {
#warning 加密处理
    NSString   *userName = self.userName.text;
    NSString   *passWord = self.passWord.text;
    
    NSMutableDictionary *PramaDic = [NSMutableDictionary new];
//    PramaDic[@"userid"] = @"17090239027";
//    PramaDic[@"psword"] = @"123456";
    
        PramaDic[@"userid"] = userName;
        PramaDic[@"psword"] = passWord;

    
    //这个账号有订单跟踪数据
//    PramaDic[@"userid"] = @"13725007900";
//    PramaDic[@"psword"] = @"123456";
    
    
    //江哥账号 ／ 有头像
//    PramaDic[@"userid"] = @"15018639039";
//    PramaDic[@"psword"] = @"5798161";
    

    AFHTTPRequestOperationManager *mgr1  = [AFHTTPRequestOperationManager manager];
    mgr1.requestSerializer.timeoutInterval  = 6.0;
 //   NSString *completeUrl = @"http://www.123qf.cn:81/testApp/user/loginUser.front";
 NSString *completeUrl = @"http://www.123qf.cn/app/user/loginUser.front";

  [MBProgressHUD showMessage:@"正在登录"];
   [mgr1 POST:completeUrl parameters:PramaDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"修理:%@",responseObject);
       
       if (responseObject) {
        [MBProgressHUD hideHUD];
           
           //保存到本地账号信息
           [[NSUserDefaults standardUserDefaults]setObject:userName forKey:@"acount"];
           [[NSUserDefaults standardUserDefaults]setObject:passWord forKey:@"pw"];
           
           
       }
       long Cp=[responseObject[@"code"] integerValue];
       if (Cp==1) {
           //获取到省份的数据，并且按首字母拼音分开了
           AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        //   [LoacationNameTool dictionaryWithUrl:@"http://www.123qf.cn:81/testApp/area/selectArea.api?parentid=0"];
              [LoacationNameTool dictionaryWithUrl:@"http://www.123qf.cn/app/area/selectArea.api?parentid=0"];

           NSLog(@"省市资料:%@",appDelegate.provnceIndexDic);
           
           [self getUserInfoAndPermissions];
           

        
       }else{
          //进入主界面
           [self loginErroAlert];
       }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [MBProgressHUD hideHUD];
       [MBProgressHUD showError:@"网络超时，稍后尝试"];
       NSLog(@"%@",error);
  
   }];
    

}

/**
 *  返回该用户数据
 *
 *  @return NSDictionary
 */
-(void)getUserInfoAndPermissions {
   // NSString *url = @"http://www.123qf.cn:81/testApp/user/getUserInfo.api";
    NSString *url = @"http://www.123qf.cn/app/user/getUserInfo.api";
    __block  NSDictionary *dic = NULL;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"用户资料:%@",responseObject);
        dic = responseObject[@"data"];
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSArray *arr = dic[@"menus"];
        
        for (NSDictionary *SingleMenuDic in arr) {
            NSString *funcitonStr = SingleMenuDic[@"text"];
            [appDelegate.QFUserPermissionDic_NSMArr  addObject:funcitonStr];
        }
//        appDelegate.QFUserPermissionDic_NSMArr = dic[@"menus"];
        appDelegate.usrInfoDic = dic[@"userInfo"];
        
        NSLog(@"arr:%@,usrInfo:%@",appDelegate.QFUserPermissionDic_NSMArr,appDelegate.usrInfoDic);
        
            HomeViewController *home = [HomeViewController new];
           KeyWindow.rootViewController = home;
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)BasicUIset {
    self.userName.keyboardType = UIKeyboardTypeNumberPad ;
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
