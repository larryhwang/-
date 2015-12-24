//
//  EditCell.m
//  上传模块测试
//
//  Created by Larry on 15/10/29.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "EditCell.h"
#import "CoreLabel.h"


#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
#define TotalTextFieldCount 12
#define CellHeight  44
#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define CellPaddingToVertical 10
#define GroupPadding  10
#define CellClipPadding 0.5
#define DetailHeight 20
#define CellWidth Screen_width-CellPaddingToVertical

@implementation EditCell


+ (id) cellWithEqualTitle:(NSString *)name {
    EditCell *cell = [[self alloc]init];
    CoreLabel *label=[[CoreLabel alloc] initWithFrame:CGRectMake(15, 0, 120, 50)];
    label.text =name;
    if ([name length]==3) {  //2字
        [label addAttr:CoreLabelAttrKern value:@(37) range:NSMakeRange(0, 1)];
    }else if ([name length] == 4) { //3字
        [label addAttr:CoreLabelAttrKern value:@(10) range:NSMakeRange(0, 2)];
    }else {   //4字
        [label addAttr:CoreLabelAttrKern value:@(1) range:NSMakeRange(0, 3)];
    }
    
  [label updateLabelStyle];
   cell.tittleLabel = label;

  return cell;
    

}


-(void)setContentString:(NSString *)contentString {
    _contentFiled.text = contentString;
}

-(void)setPlaceHoderString:(NSString *)placeHoderString {
    if (_contentFiled == nil) {
        UITextField *TF = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, CellWidth - 60, 50)];
        
      //  TF.backgroundColor = [UIColor blueColor];
        if (_isNoKeyboardPad) {
            TF.keyboardType = UIKeyboardTypeNamePhonePad;
        }
        _contentFiled = TF;
        TF.placeholder = placeHoderString ;
        [self addSubview:TF];
    } else {
        _contentFiled.text = placeHoderString ;
    }
    if (_isOptionalCell) {
        _contentFiled.enabled = NO;
    }

}

-(void)setIsOptionalCell:(BOOL)isOptionalCell {
    _isOptionalCell = isOptionalCell ;
    if(_isOptionalCell)  {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ColorChange)];
        [self addGestureRecognizer:tap]; //如果是多选Cell，将增加点击效果
        UIImageView *DetailIcon = [[UIImageView alloc]initWithFrame:CGRectMake(CellWidth- DetailHeight, (CellHeight-DetailHeight)/2,DetailHeight, DetailHeight)];
        DetailIcon.image = [UIImage imageNamed:@"timeline_icon.png"];
        [self addSubview:DetailIcon];
    }
}

-(id)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];
   self.backgroundColor = [UIColor whiteColor];
   self.clipsToBounds = YES;
   self.layer.borderWidth = 0.5;
   self.layer.borderColor =[[UIColor lightGrayColor]CGColor];
   return self;
}

- (void)setLeftview:(UIView *)Leftview {
    _leftview = Leftview;
    [_leftview setFrame:CGRectMake(100, 0, Screen_height - 100, 50)];

}

-(void)setTitle:(NSString *)Title {
    CoreLabel *label=[[CoreLabel alloc] initWithFrame:CGRectMake(10, 0, 110, 50)];
    label.font = [UIFont systemFontOfSize:15];
    label.text =Title;
    if ([Title length]==3) {  //2字
        [label addAttr:CoreLabelAttrKern value:@(37) range:NSMakeRange(0, 1)];
    }else if ([Title length] == 4) { //3字
        [label addAttr:CoreLabelAttrKern value:@(10) range:NSMakeRange(0, 2)];
    }else {   //4字
        [label addAttr:CoreLabelAttrKern value:@(1)  range:NSMakeRange(0, 3)];
    }
   [label updateLabelStyle];
   [self addSubview:label];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  //  [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)ColorChange {
    [UIView animateWithDuration:0.1 animations:^{
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self setBackgroundColor:[UIColor whiteColor]];
    }];
    //在这里执行跳转
    if (_otherAction) {
        _otherAction();
    }

    
}



@end
