//
//  FilterViewController.h
//  清房助手
//
//  Created by Larry on 12/10/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeachRusultDisplayController.h"

#import  "FilterViewController.h"
#import  "QFTableView_Sco.h"
#import  "EditCell.h"
#import  "AppDelegate.h"
#import  "SelectRegionVC.h"

@interface FilterViewController : UIViewController

@property(nonatomic,strong)  NSMutableDictionary  *PostDictionary;
@property(nonatomic,weak)    QFTableView_Sco *main;
@property(nonatomic,weak)    EditCell *RegionTF;
@property(nonatomic,strong)  NSArray  *AdressKeyArr;


@property(nonatomic,copy)   NSString *param;
@property(nonatomic,assign) CellStatus filterStatus;
@property(nonatomic,assign) id<SeachRusultDisplayVCdelegate> delegate;



//

-(void)addCell:(EditCell *)headcell After:(EditCell *)cell;


-(void)FormatHouseTypeData;

-(void)FormatAdressData;

-(void)removeCellWithTag:(NSInteger)tag;


@end
