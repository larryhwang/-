//
//  QFLocateButton.m
//  导航栏向下弹窗选择
//
//  Created by Larry on 12/15/15.
//  Copyright © 2015 Larry. All rights reserved.
//

#import "QFLocateButton.h"

@implementation QFLocateButton

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    //增加自定义效果
    self.layer.cornerRadius  = 8;
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 1.5;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.titleLabel.font   = [UIFont systemFontOfSize: 13];
    
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
//  
  //  [self.titleLabel sizeToFit];
    return self;
}


-(void)becameSelected {
    self.selected = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
}
-(void)becameUslected {
    self.selected = NO;
    self.backgroundColor = [UIColor clearColor];
}

@end
