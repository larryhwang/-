//
//  QFCitySwitchCellBtn.m
//  导航栏向下弹窗选择
//
//  Created by Larry on 12/16/15.
//  Copyright © 2015 Larry. All rights reserved.
//

#import "QFCitySwitchCellBtn.h"





#define isI4  ([UIScreen mainScreen].bounds.size.height == 480)
#define isI5  ([UIScreen mainScreen].bounds.size.height == 568)
#define isI6  ([UIScreen mainScreen].bounds.size.height == 667)
#define isI6p ([UIScreen mainScreen].bounds.size.height == 736)
@implementation QFCitySwitchCellBtn

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 220, 0, 0);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setTitle:@"切换" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

    [self setCurrentCityName:@"惠州市"];
    return self;
}


-(void)setCurrentCityName:(NSString *)currentCityName{
    _currentCityName = currentCityName;
    if (self.currentCityNameLabel==nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
        self.currentCityNameLabel =label;
        UIImageView *imgeView = [[UIImageView alloc]initWithFrame:CGRectMake(320, 10, 20, 20)];
        
        if (isI4) {
            [label setFrame:CGRectMake(0, 0, 120, 40)];
            [imgeView setFrame:CGRectMake(280, 10, 20, 20)];
        }else if (isI5){
            [label setFrame:CGRectMake(0, 0, 120, 40)];
            [imgeView setFrame:CGRectMake(280, 10, 20, 20)];
            
        }else if (isI6){
            [label setFrame:CGRectMake(0, 0, 120, 40)];
            [imgeView setFrame:CGRectMake(320, 10, 20, 20)];
            
        }else if (isI6p){
            [label setFrame:CGRectMake(0, 0, 130, 40)];
            [imgeView setFrame:CGRectMake(350, 10, 20, 20)];
            
        }
        
        [imgeView setImage:[UIImage imageNamed:@"arrowRight"]];
        
        [label setTextColor:[UIColor whiteColor]];
        label.font = [UIFont systemFontOfSize:15];
        NSLog(@"当前:%@",currentCityName);
        label.text = [NSString stringWithFormat:@"当前城市:%@",_currentCityName];
        [self addSubview:label];
        [self addSubview:imgeView];
    } else {
        self.currentCityNameLabel.text = [NSString stringWithFormat:@"当前城市:%@",_currentCityName];
    }
   
}

@end
