//
//  CommitOrderVC.m
//  清房助手
//
//  Created by Larry on 12/22/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "CommitOrderVC.h"
#import "TypesSelect.h"



@interface CommitOrderVC (){
    CGRect _Origin;
    CGRect _popOrigin;
    TypesSelect *_popView;
}
@property (weak, nonatomic) IBOutlet UILabel *QFServiceTypeName;
@property (weak, nonatomic) IBOutlet UIImageView *QFarrowImg;


//// self.view.backgroundColor  = [UIColor blueColor];
//CGRect origin = CGRectMake(0, 100, ScreenWidth, 200);
//CGRect popOrigin = CGRectMake(60, 79+20 , ScreenWidth, 200);
//_Origin = origin;
//_popOrigin = popOrigin;
////    TypesSelect *popView =[[TypesSelect alloc]initWithFrame:origin];
////   popView.backgroundColor = [UIColor brownColor];
//
//NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TypesSelect" owner:self options:nil];
//TypesSelect *popView  = [nibs lastObject];
//popView.backgroundColor = [UIColor redColor];
//_popView = popView ;
//[self.view addSubview:popView];
////[popView setFrame:origin];
//[_popView setFrame:_popOrigin];
//
////    popView.hidden = YES;

@end

@implementation CommitOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
  //  self.edgesForExtendedLayout = UIRectEdgeNone;
    CGRect popOrigin = CGRectMake(60, 79+20 , ScreenWidth, 200);
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TypesSelect" owner:self options:nil];
    TypesSelect *popView  = [nibs lastObject];
    popView.backgroundColor = [UIColor redColor];
    [self.view addSubview:popView];
    [popView setFrame:popOrigin];

    


}

- (IBAction)ChosenBtnClick:(id)sender {
    NSLog(@"选择按钮");
    
    [UIView animateWithDuration:1. animations:^{
    [_popView setFrame:_popOrigin];
        [_popView setHidden:NO];
        
}];

    

}

@end
