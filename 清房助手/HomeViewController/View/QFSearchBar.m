//
//  CZSearchBar.m
//  清房助手
//
//  Created by Larry on 15-9-7.
//  Copyright (c) 2015年 Larry. All rights reserved.
//

#import "QFSearchBar.h"

@implementation QFSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.font = [UIFont systemFontOfSize:13];
        
        self.background = [UIImage imageWithStretchableName:@"searchbar_textfield_background"];
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
        imageV.width += 10;
        imageV.contentMode = UIViewContentModeCenter;
        self.leftView = imageV;
        self.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return self;
}

@end
