//
//  SharePopVC.m
//  清房助手
//
//  Created by Larry on 1/28/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "SharePopVC.h"
#import "commonFile.h"


#define HXOriginX 15.0 //ico起点X坐标
#define HXOriginY 15.0 //ico起点Y坐标
#define HXIcoWidth 57.0 //正方形图标宽度
#define HXIcoAndTitleSpace 10.0 //图标和标题间的间隔
#define HXTitleSize 10.0 //标签字体大小
#define HXTitleColor [UIColor colorWithRed:52/255.0 green:52/255.0 blue:50/255.0 alpha:1.0] //标签字体颜色
#define HXLastlySpace 15.0 //尾部间隔
#define HXHorizontalSpace 15.0 //横向间距

@interface SharePopVC ()  {
    UIView *_contentView;
}


@end

@implementation SharePopVC

//image":@"shareView_wx",
//@"title":@"微信"},



-(void)setQFImgSAndTittleSDicArr:(NSArray *)QFImgSAndTittleSDicArr  {
   _QFImgSAndTittleSDicArr  = QFImgSAndTittleSDicArr;
   //执行摆放算法
}





- (UIView *)ittemShareViewWithFrame:(CGRect)frame dic:(NSDictionary *)dic Andindex:(NSInteger)index {
    
    NSString *image = dic[@"image"];
    NSString *highlightedImage = dic[@"highlightedImage"];
    NSString *title = [dic[@"title"] length] > 0 ? dic[@"title"] : @"";
    
    UIImage *icoImage = [UIImage imageNamed:image];
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    button.frame = CGRectMake((view.frame.size.width-icoImage.size.width)/2, 0, icoImage.size.width, icoImage.size.height);
    button.titleLabel.font = [UIFont systemFontOfSize:HXTitleSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    if (image.length > 0) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (highlightedImage.length > 0) {
        [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    }
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.origin.y +button.frame.size.height+ HXLastlySpace, view.frame.size.width, HXTitleSize)];
    label.textColor = HXTitleColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:HXTitleSize];
    label.text = title;
    [view addSubview:label];
    
    return view;
}




- (void)viewDidLoad {
    [super viewDidLoad];
   // self.view.userInteractionEnabled = NO ;
    UIView *popContentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 220, Screen_width, 220)];
    _contentView  = popContentView ;
    
  
    
    
    
    //"分享到"  头部
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 54)];
    CGPoint headViewPoint = CGPointMake(Screen_width/2, 54/2);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 15)];
    label.center = headViewPoint;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, headerView.frame.size.width, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [headerView addSubview:lineLabel];
    [popContentView addSubview:headerView];
    
   // 中间按钮
    [self layoutShareBtnIttems];
    
    
    //"取消"  --底部
    UIButton *footView = [[UIButton alloc] initWithFrame:CGRectMake(0, 220-54, Screen_width, 54)];
    CGPoint footViewPoint = CGPointMake(Screen_width/2, 54/2);
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 54)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn setTitleColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    btn.center =  footViewPoint ;
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
    [footView addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0.5, footView.frame.size.width, 0.5)];
    lineLabel2.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [footView addSubview:lineLabel2];
    
    
    popContentView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:btn];
    [popContentView addSubview:footView];
    
    
    [self.view addSubview:popContentView];
}


-(void)buttonAction:(UIButton *)button {
    [self diss];
    [self.delegate QFsharedWith:button.tag];
}

-(void)diss {
    self.DismissView();
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  摆放算法
 */
-(void)layoutShareBtnIttems {
    
    NSDictionary  *dic  = [_QFImgSAndTittleSDicArr firstObject];
    CGRect rect = CGRectMake(Screen_width/4 - 54/2, 54 + 15, HXIcoWidth, HXIcoWidth);
    UIView  *view = [self ittemShareViewWithFrame:rect dic:dic Andindex:0];
    NSLog(@"%@",_contentView);
    [_contentView addSubview: view];
    
    NSDictionary  *dic1  = _QFImgSAndTittleSDicArr[1];
    CGRect rect1 = CGRectMake(3*Screen_width/4 -54/2, 54 + 15, HXIcoWidth, HXIcoWidth);
    UIView  *view1 = [self ittemShareViewWithFrame:rect1 dic:dic1 Andindex:1];
    NSLog(@"%@",_contentView);
    [_contentView addSubview: view1];

    

}

@end
