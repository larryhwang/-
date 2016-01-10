//
//  MUtiSelectViewController.m
//  用scollview做表格
//
//  Created by Larry on 15/11/21.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "MUtiSelectViewController.h"
#import "GBTagListView.h"

#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define OptionsLabelDeafualtBackgroudColor  UIColorWithRGBA(169,237,255,1)

#define   meiqiTag          0
#define   kuandaiTag        1
#define   diantiTag         2
#define   tingchechangTag   3
#define   dianshiTag        4
#define   jiadianTag        5
#define   dianhuaTag        6
#define   lingbaoruzhuTag   7


@interface MUtiSelectViewController ()

{
    UIColor   *_titleColor;
    UIColor   *_defaultColor;
    NSString  *_AppendAttachMentText;

    
    GBTagListView*_tempTag;
}

@property(nonatomic,strong)   NSMutableArray  *hasSelectedArr;
@property(nonatomic,strong) GBTagListView  *GBTag;


@end

@implementation MUtiSelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    GBTagListView *tagList=[[GBTagListView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,0)];
    self.GBTag = tagList;
    /**允许点击 */
    tagList.canTouch=YES;
    /**可以控制允许点击的标签数 */
    tagList.canTouchNum = [self.OptBtnTitlesArra count];
    tagList.signalTagColor=[UIColor whiteColor];
    [tagList setTagWithTagArray:self.OptBtnTitlesArra];
    
    
    CGFloat ContentHeight = 3 * tagList.frame.size.height;
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - ContentHeight, ScreenWidth, ContentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn  = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 35)];
    [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancleBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth -10 - 60, 5, 60, 35)];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:leftBtn];   [contentView addSubview:rightBtn];
    
    CGPoint  p = CGPointMake(ScreenWidth/2, ContentHeight * .7);
    tagList.center = p;


    NSLog(@"%f %f",p.x,p.y);
    [contentView addSubview:tagList];
    [self.view addSubview:contentView];
    [tagList setDidselectItemBlock:^(NSArray *arr) {
        
        //1.通知展示页面更新已选中的配套
        //2.设置上传所需参数
       [self.hasSelectedArr removeAllObjects];
        self.hasSelectedArr = [NSMutableArray arrayWithArray:arr];
        NSMutableSet *set = [NSMutableSet setWithArray:self.OptBtnTitlesArra];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:self.OptBtnSqlTittles_NARR forKeys:self.OptBtnTitlesArra];
        NSLog(@"%@",dic);
        
        //参数设置
        for (NSString *strng in self.hasSelectedArr) {
            if ([set containsObject:strng]) {
                [self.HandleDic setObject:@"1" forKey:dic[strng]];
            }
        }

    }];
    [self roverLastStatus];
}


-(void)roverLastStatus {
    NSArray *tempArr = [self.GBTag.OptBtnsArr copy];
    for (UIButton *btn in self.GBTag.OptBtnsArr) {
        NSString *str = btn.titleLabel.text;
        if ([self.hasSelectedSets containsObject:str]) {
          [btn  sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}


- (void)cancleBtn:(id)sender {
    self.dismissAction();
   [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)sureBtn:(id)sender {
    _AppendAttachMentText = @"";
    for (NSString *indexString in self.hasSelectedArr) {
       _AppendAttachMentText  = [_AppendAttachMentText stringByAppendingFormat:@"%@ ",indexString];
    }
  self.HandleTextField.text = _AppendAttachMentText ;
    NSLog(@"%@",_AppendAttachMentText);
  self.dismissAction();
  [self dismissViewControllerAnimated:YES completion:nil];
}



@end
