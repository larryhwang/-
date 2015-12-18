//
//  QFLocateButton.h
//  导航栏向下弹窗选择
//
//  Created by Larry on 12/15/15.
//  Copyright © 2015 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFLocateButton : UIButton

@property(nonatomic,copy) NSString *nextRequsetCode;

-(void)becameSelected;
-(void)becameUslected;

@end
