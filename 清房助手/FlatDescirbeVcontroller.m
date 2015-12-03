//
//  FlatDescirbeVcontroller.m
//  用scollview做表格
//
//  Created by Larry on 11/30/15.
//  Copyright © 2015 Larry. All rights reserved.
//

#import "FlatDescirbeVcontroller.h"

@interface FlatDescirbeVcontroller ()

@end

@implementation FlatDescirbeVcontroller



- (void)viewDidLoad {
   [super viewDidLoad];
    NSLog(@"ViewDidLoad");
   [self TextContentUIChange];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (IBAction)SaveAndBackClick:(id)sender {
     NSString *text = self.ContentText.text;
    if (self.UIUpdate && ![text isEqualToString:@"在这里描述详情或备注～"]) {
       self.UIUpdate(text);  //UI更新
    }
    [self.HandleNSDic setObject:text forKey:@"fangyuanmiaoshu"]; //数据保存
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)TextContentUIChange {
    self.ContentText.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.ContentText.layer.borderColor = [[UIColor colorWithRed:13.0/255.0 green:148.0/255.0 blue:252.0/255.0 alpha:1.0]CGColor];
    self.ContentText.layer.borderWidth = 1.0;
    self.ContentText.layer.cornerRadius = 8.0f;
    [self.ContentText.layer setMasksToBounds:YES];
    
    NSString *str=[self.HandleNSDic objectForKey:@"fangyuanmiaoshu"];
    if (str) {
        self.ContentText.text = str ;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
}

@end
