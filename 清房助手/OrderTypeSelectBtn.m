//
//  OrderTypeSelectBtn.m
//  清房助手
//
//  Created by Larry on 12/23/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "OrderTypeSelectBtn.h"

@implementation OrderTypeSelectBtn


//重载父类控件
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    return self;
}


-(void)becameSelected {
    NSLog(@"确定");
    self.selected = YES;
    self.backgroundColor = DeafaultColor2;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}
-(void)becameUslected {
    NSLog(@"取消");
    self.selected = NO;
    self.backgroundColor = [UIColor clearColor];
}

@end
