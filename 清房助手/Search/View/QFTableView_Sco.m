//
//  QFTableView_Sco.m
//  筛选界面的模块_动态表格的添加
//
//  Created by Larry on 12/10/15.
//  Copyright © 2015 Larry. All rights reserved.
//

#import "QFTableView_Sco.h"
#import "commonFile.h"


#define Padding     2
#define CellHeight  44

#define CellPaddingToVertical 10



@interface QFTableView_Sco(){
    CGRect _tempRect;
    
}

@end
@implementation QFTableView_Sco



-(NSMutableArray*) Cell_NSArr {
    if (_Cell_NSArr ==nil) {
        _Cell_NSArr = [NSMutableArray new];
    }
    return _Cell_NSArr;
}



-(void)layoutSubviews {
    NSLog(@"触发");
    CGFloat orignY = 12;
    int count = ((int)[_GroupFlagNoArr count]);
    int Dcount = ((int)[_Cell_NSArr count]);
    //增加Cell后，重置所有Cell
    
    //摆放算法
    
    int cellIndex =0;
    for (int i=0; i<count; i++) {  //第几组
        int m = [(NSNumber *)_GroupFlagNoArr[i] intValue];  // 第几小组的数量
        for (int j=0; j<m; j++) {
            //每个组里的第一个单元格要间隔开
            
            UIView *SinleView = _Cell_NSArr[cellIndex] ;
            cellIndex ++;
            if (j==0 && i==0) {
                [(UIView *)SinleView setFrame:CGRectMake(CellPaddingToVertical/2, orignY + GroupPadding,ScreenWidth-CellPaddingToVertical, CellHeight)];
                _tempRect = SinleView.frame;
                [self addSubview:SinleView];
            } else if(j==0 && i!=0){
                [(UIView *)SinleView setFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(_tempRect) + GroupPadding,ScreenWidth-CellPaddingToVertical, CellHeight)];
                _tempRect = SinleView.frame;
                [self addSubview:SinleView];
            } else {
                [(UIView *)SinleView setFrame:CGRectMake(CellPaddingToVertical/2, CGRectGetMaxY(_tempRect) -CellClipPadding,ScreenWidth-CellPaddingToVertical, CellHeight)];
                _tempRect = SinleView.frame;
                [self addSubview:SinleView];
                
            }
        }
    }
    

}

@end
