//
//  QFTableView_Sco.m
//  筛选界面的模块_动态表格的添加
//
//  Created by Larry on 12/10/15.
//  Copyright © 2015 Larry. All rights reserved.
//

#import "QFTableView_Sco.h"

#define Padding     2
#define CellHeight  44



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
    

    //增加Cell后，重置所有Cell
    [_Cell_NSArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(UIView *)obj setFrame:CGRectMake(0, orignY + (Padding + CellHeight) * idx ,ScreenWidth, CellHeight)];
        [self addSubview:obj];
    }];

}

@end
