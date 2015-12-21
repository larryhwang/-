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
    
     NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"acount"];
    if (name.length>0) {
        self.userName.text = name;
    }   else {
        self.userName.text =@"";
    }
    self.passWord.text = @"";
}


- (IBAction)loginClick:(id)sender {
#warning 加密处理
    NSString   *userName = self.userName.text;
    NSString   *passWord = self.passWord.text;
    
    NSMutableDictionary *PramaDic = [NSMutableDictionary new];
    //http://127.0.0.1:8080/qfzsapi/user/loginUser.front?userID=admin&psWord=2
    //http://www.123qf.cn/testApp/user/loginUser.front?userID=15018639039&psWord=5798161"
//    PramaDic[@"userid"] = @"17090239027";
//    PramaDic[@"psword"] = @"123456";
    
        PramaDic[@"userid"] = userName;
        PramaDic[@"psword"] = passWord;

    
    
    

    AFHTTPRequestOperationManager *mgr1  = [AFHTTPRequestOperationManager manager];
    NSString *completeUrl = @"http://www.123qf.cn:81/testApp/user/loginUser.front";

    HomeViewController *home = [HomeViewController new];

   [mgr1 POST:completeUrl parameters:PramaDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"修理:%@",responseObject);
        [MBProgressHUD showMessage:@"正在登录"];
       if (responseObject) {
        [MBProgressHUD hideHUD];
           
           //保存到本地账号信息
           [[NSUserDefaults standardUserDefaults]setObject:userName forKey:@"acount"];
           [[NSUserDefaults standardUserDefaults]setObject:passWord forKey:@"pw"];
           
           
           
           [self getdata];  //测试数据，可删
       }
       long Cp=[responseObject[@"code"] integerValue];
       if (Cp==1) {
           //获取到省份的数据，并且按首字母拼音分开了
           AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
           appDelegate.provnceIndexDic = [LoacationNameTool dictionaryWithUrl:@"http://www.123qf.cn:81/testApp/area/selectArea.api?parentid=0"];
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
-(void)getdata {
    AFHTTPRequestOperationManager *mgr  = [AFHTTPRequestOperationManager manager];
    NSString *com2= @"http://www.123qf.cn:81/testApp/fangyuan/detailsHouse.api?fenlei=3&fangyuan_id=268";
    NSLog(@"即将抓取:%@",com2);
    [mgr POST:com2 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"登陆时的抓的详细信息%@",responseObject);
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
