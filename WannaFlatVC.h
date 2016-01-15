//
//  WannaFlatVC.h
//  清房助手
//
//  Created by Larry on 1/13/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "FilterViewController.h"
#import "SaleOutPostEditForm.h"


@interface WannaFlatVC : SaleOutPostEditForm


@property(nonatomic,assign) BOOL iSQiuzu;


//便于继承
@property(nonatomic,strong)  NSArray  *AdressKeyArr;
@property(nonatomic,strong)    QFTableView_Sco *main;
@property(nonatomic,weak) UIButton *SaveBtn;
@property(nonatomic,weak) UIButton *PostBtn;
@property(nonatomic,copy) void (^updateBtnsFrame) (void);

-(void)addCell:(EditCell *)headcell After:(EditCell *)cell;
-(void)removeCellWithTag:(NSInteger)tag ;
-(void)getMaxAndMinArea:(NSString *) str ;
@end
