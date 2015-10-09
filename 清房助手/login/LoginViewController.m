//
//  LoginViewController.m
//  清房助手
//
//  Created by Larry on 15/10/8.
//  Copyright © 2015年 Larry. All rights reserved.
//
#warning 忘记密码没有做
#warning 4s和5点击文本框后整体
#import "LoginViewController.h"
#import "AFNetworking.h"

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
    NSString   *userName = self.userName.text;
    NSLog(@"%@",userName);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
