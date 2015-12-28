//
//  QFDateSelectStartToEnd.m
//  清房助手
//
//  Created by Larry on 12/28/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "QFDateSelectStartToEnd.h"

@interface QFDateSelectStartToEnd () {
    NSString *_QFdateStr;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *datePikerView;



@end

@implementation QFDateSelectStartToEnd


- (IBAction)cancleClick:(id)sender {
    if (self.DismissView) {
      self.DismissView();
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)SureClick:(id)sender {
    NSString *dateStr = [self stringFromDate:self.datePikerView.date];
    [self cancleClick:nil];
    if (self.SureBtnAciton) {
        self.SureBtnAciton(dateStr);
    }
    NSLog(@"%@",dateStr);
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewDidLoad {
  [super viewDidLoad];
   self.datePikerView.backgroundColor = [UIColor whiteColor];
    
    
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}



@end
