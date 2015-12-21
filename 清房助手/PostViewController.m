//
//  PostViewController.m
//  上传模块测试
//
//  Created by Larry on 15/10/26.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "PostViewController.h"
#import "PostCategory.h"



#define SCREEN_WIDTH                  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                 ([UIScreen mainScreen].bounds.size.height)
#define ContenterHeight 255
#define ButtonHeight 90
#define Pading 40
#define ImgWidth  236
#define ImgHeight 76

@interface PostViewController ()
@property (weak, nonatomic)  UIView *FucntionContentView;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    UIView *contView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ContenterHeight, ContenterHeight)];
    [self.view addSubview:contView];
    CGPoint  OriginPoint = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT + 10);
    contView.center = OriginPoint ;
    self.FucntionContentView = contView;
    
    CGRect salesOut = CGRectMake(0, 0, ButtonHeight, ButtonHeight);
    CGRect rentOut  = CGRectMake(ContenterHeight -ButtonHeight, 0, ButtonHeight, ButtonHeight);
    CGRect WanPurch = CGRectMake(0, ButtonHeight + Pading ,ButtonHeight, ButtonHeight);
    CGRect WanRent  = CGRectMake(ContenterHeight-ButtonHeight, ButtonHeight + Pading ,ButtonHeight, ButtonHeight);
    
    [self setBtnWithimgName:@"chushou" titleName:@"出售" rect:salesOut];
    [self setBtnWithimgName:@"chuzu" titleName:@"出租" rect:rentOut];
    [self setBtnWithimgName:@"qiugou" titleName:@"求购" rect:WanPurch];
    [self setBtnWithimgName:@"qiuzu" titleName:@"求租" rect:WanRent];
    
    [self Move:nil];
    
    [self setTitleLable];
  
}


-(void) setTitleLable {
    UIImageView *tittleImgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - ImgWidth)/2, self.view.frame.origin.y + 2*ImgHeight -30 , ImgWidth, ImgHeight)];
    if(isI5){
        [tittleImgView setFrame:CGRectMake((SCREEN_WIDTH - ImgWidth)/2, self.view.frame.origin.y + 2*ImgHeight -70 , ImgWidth, ImgHeight)];
    }
    
    tittleImgView.image = [UIImage imageNamed:@"wenzi"];
    [self.view addSubview:tittleImgView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)Move:(id)sender {
    [UIView animateWithDuration:1.f animations:^{
        CGPoint  First  =  CGPointMake(self.view.center.x, self.view.center.y + 10);
        self.FucntionContentView.center = First ;
    } completion:^(BOOL finished) {
    }];
}


- (void) setBtnWithimgName:(NSString *)imgName titleName:(NSString *)titleName rect :(CGRect ) currentCGR {
    UIButton *btn = [[UIButton alloc]initWithFrame:currentCGR];
    [btn addTarget:self action:@selector(salesOut) forControlEvents:UIControlEventTouchUpInside];
    CGRect titleRect = CGRectMake(currentCGR.origin.x, currentCGR.origin.y + 2 + ButtonHeight, ButtonHeight, 30);
    UILabel *title = [[UILabel alloc]initWithFrame:titleRect];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = titleName ;
   [title setTextColor: [UIColor darkGrayColor]];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [self.FucntionContentView addSubview:btn];
    [self.FucntionContentView addSubview:title];

}

-(void)salesOut {
    PostCategory *Chose = [PostCategory new];
    Chose.title = @"请选择种类";
    [self.navigationController pushViewController:Chose animated:YES];
}

@end
