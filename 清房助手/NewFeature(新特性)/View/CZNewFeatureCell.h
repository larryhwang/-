//
//  CZNewFeatureCell.h
//  ET微博
//
//  Created by Larry on 15-9-7.
//  Copyright (c) 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZNewFeatureCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;


// 判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;
@end
