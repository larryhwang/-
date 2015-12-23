//
//  TESTViewController.m
//  
//
//  Created by Larry on 12/23/15.
//
//

#import "TESTViewController.h"

@interface TESTViewController ()

@end

@implementation TESTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect popOrigin = CGRectMake(60, 79+20 , ScreenWidth, 200);
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TypesSelect" owner:self options:nil];
    TypesSelect *popView  = [nibs lastObject];
    popView.backgroundColor = [UIColor redColor];
    [self.view addSubview:popView];
    [popView setFrame:popOrigin];
}


@end
