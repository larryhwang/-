//
//  commonFile.h
//  用scollview做表格
//
//  Created by Larry on 15/11/16.
//  Copyright © 2015年 Larry. All rights reserved.
//

#ifndef commonFile_h
#define commonFile_h


#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
#define TotalTextFieldCount 12
#define CellHeight  44
#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define CellPaddingToVertical 10
#define GroupPadding  10
#define CellClipPadding 0.5
#define CellWidth Screen_width-CellPaddingToVertical
#define CurrentCityName @"CurrentCityName"

#endif /* commonFile_h */
