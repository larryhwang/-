//
//  EditCell.h
//  上传模块测试
//
//  Created by Larry on 15/10/29.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCell : UIView
@property(nonatomic,strong) UILabel  *tittleLabel;
@property(nonatomic,strong) UIView   *leftview;
@property(nonatomic,assign) BOOL isOptionalCell;
@property(nonatomic,assign) BOOL isNoKeyboardPad;
@property(nonatomic,strong) NSString  *title;
@property(nonatomic,strong) NSString  *placeHoderString;
@property(nonatomic,strong) NSString  *contentString;
@property (nonatomic, copy) void (^otherAction)(void);
@property(nonatomic,strong)  UITextField  *contentFiled;
+(id)cellWithEqualTitle:(NSString *)name;
@end
////