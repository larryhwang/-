//
//  PopSelectViewController.m
//  用scollview做表格
//
//  Created by Larry on 15/11/16.
//  Copyright © 2015年 Larry. All rights reserved.
//
#import "commonFile.h"
#import "PopSelectViewController.h"
#define ModalViewTag 10

@interface PopSelectViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIContentContainer> {
    NSString *_SelectedString;
    NSString *_test;
}
@property (weak, nonatomic) IBOutlet UIPickerView *selectOpt;


@end

@implementation PopSelectViewController

- (IBAction)cancleClick:(id)sender {
     self.DismissView();
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sureClick:(id)sender {
    self.SureBtnAciton(_test);
    [self cancleClick:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _test = _pikerDataArr[0];

}


#pragma mark -PikerViewDelegate 

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pikerDataArr count];;
}

#pragma 数据源 协议方法
//为某个波轮提供显示数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    _SelectedString = [_pikerDataArr objectAtIndex:row];
//    NSLog(@"滚轮:%@",_SelectedString);
    return _SelectedString;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _test = _pikerDataArr[row];
    NSLog(@"滚轮:%@,数据:%d",_test,row);
}


@end
