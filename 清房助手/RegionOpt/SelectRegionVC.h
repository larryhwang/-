//
//  SelectRegionVC.h
//  上传模块测试
//
//  Created by Larry on 15/10/31.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>
//SelectRegionVC


@protocol SelectRegionDelegate <NSObject>

-(void)appendName:(NSString *)locationName;
- (void)updateTableData;
@end



@interface SelectRegionVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *LocationNameTable;
@property(nonatomic,strong)  NSArray  *indexChara;
@property(nonatomic,strong)  NSArray  *OrderedCity;
@property(nonatomic,strong) NSDictionary *indexData;
@property(nonatomic,assign)  id<SelectRegionDelegate> delegate;;

@end
