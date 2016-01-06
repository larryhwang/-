//
//  MUtiSelectViewController.m
//  用scollview做表格
//
//  Created by Larry on 15/11/21.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "MUtiSelectViewController.h"

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
    NSArray  *_OptBtnSqlTittles_NARR;
}
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *canleeBtn;
@property (weak, nonatomic) IBOutlet UIButton *TestBtn;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *OptBtn;
@property(nonatomic,assign)   BOOL testSelected;
@property(nonatomic,strong)   NSMutableArray *SelectedAppendAttachMentTextArr;
@property(nonatomic,strong)   NSArray  *OptBtnTitlesArra;
//@property(nonatomic,strong)   NSArray  *OptBtnSqlTittles_NARR;
@property(nonatomic,strong)   NSMutableArray  *selectedOptArraCopy;


@end

@implementation MUtiSelectViewController

-(NSMutableArray*)AppendAttachMentTextArr {
    if (_SelectedAppendAttachMentTextArr ==nil) {
        _SelectedAppendAttachMentTextArr =[NSMutableArray new];
    }
    return _SelectedAppendAttachMentTextArr;
}


-(NSMutableArray*)selectedOptArraCopy {
    if (_selectedOptArraCopy ==nil) {
        _selectedOptArraCopy = [NSMutableArray new];
    }
    return _selectedOptArraCopy;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    if (isI5) {
        
        [self.sureBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.canleeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        for (UIButton *btn in self.OptBtn) {
            [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        }
    }
    
    
    if (isI4) {
        
        [self.sureBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.canleeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        for (UIButton *btn in self.OptBtn) {
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        }
    }

    
    [self initialData];
    [self initHasSelecteStatus];  // initial the selected options


    //    &meiqi=true
    //    &kuandai=true
    //    &dianti=true
    //    &tingchechang=true
    //    &dianshi=true
    //    &jiadian=true
    //    &dianhua=true
    //    &lingbaoruzhu=true

}

-(void)initialData {
    //aviod  the original Array muted when initial enumeration
    for (NSString *str in self.hasSelectedArrar) {
        [self.selectedOptArraCopy addObject:str];
    }
    self.OptBtnTitlesArra  = [NSArray arrayWithObjects:@"天然气",@"宽带",@"电梯",@"停车场",@"电视",@"家电",@"电话",@"拎包入住", nil];
    _OptBtnSqlTittles_NARR = [NSArray arrayWithObjects:@"meiqi",@"kuandai",@"dianti",@"tingchechang",@"dianshi",@"jiadian",@"dianhua",@"lingbaoruzhu", nil];
    
    
    _AppendAttachMentText = @"";
    NSInteger count = 0;
    
    //add Action
    [self.TestBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    for (UIButton *btn in self.OptBtn) {
        btn.tag = count;
        NSLog(@"名字:%@",btn.titleLabel.text);
        count ++;
        [btn addTarget:self action:@selector(ChoosedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)ChoosedAction:(UIButton *)btn {
    [btn setTintColor: [UIColor clearColor]];
    NSString *OptTitle = btn.titleLabel.text;
    NSInteger BtnIndex = btn.tag;
    NSString *BtnIndexString = [NSString stringWithFormat:@"%ld",(long)BtnIndex];
    NSLog(@"标题:%@,%d",OptTitle,BtnIndex);
    if (!btn.selected) {
        //UI变化
       [btn setBackgroundColor:[UIColor orangeColor]];
        btn.selected = YES;
        //数据变化保存
        [self.hasSelectedArrar addObject:BtnIndexString];  //save selected Options Index
        [_HandleDic setObject:@"1" forKey:_OptBtnSqlTittles_NARR[BtnIndex]];  //Data Dealing
    }else {
       [btn setBackgroundColor:OptionsLabelDeafualtBackgroudColor]; //UI Changes
        //when options unseleted,remove the selected data
       [_HandleDic setObject:@"0" forKey:_OptBtnSqlTittles_NARR[BtnIndex]];  // Data Dealing
       [self.hasSelectedArrar removeObject:BtnIndexString];
        btn.selected = NO;
    }
}


-(void)selectedStatusReset:(UIButton *)btn {
    [btn setSelected:YES];
    [btn setBackgroundColor:[UIColor orangeColor]];   //UI变化
}


-(void)saveSelectedStatus:(NSInteger )tag{
    NSString *tagString = [NSString stringWithFormat:@"%ld",(long)tag];
   [self.hasSelectedArrar addObject:tagString];
    NSLog(@"函数已存TAG%@",self.hasSelectedArrar);
    
}


-(void)initHasSelecteStatus {
    for (NSString *tagString in _selectedOptArraCopy) {
        NSInteger hasSelectedTag = [tagString intValue];
        UIButton *hasSelectedBtn = [self.OptBtn objectAtIndex:hasSelectedTag];
       [self selectedStatusReset:hasSelectedBtn];
    }
}



- (IBAction)cancleBtn:(id)sender {
    self.dismissAction();
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)sureBtn:(id)sender {
    for (NSString *indexString in _hasSelectedArrar) {
        NSInteger index = [indexString intValue];
        NSString *OptTittle = self.OptBtnTitlesArra[index];
        _AppendAttachMentText  = [_AppendAttachMentText stringByAppendingFormat:@"%@ ",OptTittle];
    }
  self.HandleTextField.text = _AppendAttachMentText ;
    self.dismissAction();
  [self dismissViewControllerAnimated:YES completion:nil];
}



@end
