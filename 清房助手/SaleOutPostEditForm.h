//
//  ViewController.h
//  用scollview做表格
//
//  Created by Larry on 15/11/14.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditCell.h"
#import "CZKeyboardToolbar.h"
#import "MUtiSelectViewController.h"
#import <JYBMultiImageSelector/JYBMultiImageSelector.h>
#import "Common.h"



@interface SaleOutPostEditForm : UIViewController

@property (nonatomic,strong)  NSDictionary *indexData;

@property(nonatomic,copy) NSString *username;

@property(nonatomic,copy) NSString *userId;

@property(nonatomic,strong)  NSMutableArray *cellMARR;


//为了便于继承

//UIScrollView
@property(nonatomic,strong)   EditCell  *pictureDisplay;
@property (nonatomic, strong) JYBMultiImageView *multiImageView;
@property (nonatomic, copy)   UIView *(^viewGetter)(NSString *imageName);
@property (nonatomic, copy)   void (^blockTest)(void);

@property(nonatomic,strong)   NSMutableArray  *tfArrs;
@property(nonatomic,strong)   NSMutableArray  *footArrs;

@property(nonatomic,assign) CellStatus PreStatus;


/**
 *  房屋分类
 */
@property(nonatomic,assign) BuildingType Fenlei;
/**
 *  发布类型，4种乘以4种
 */
@property(nonatomic,copy) NSString *typeStr;



/**
 *  上传的参数信息
 */
@property(nonatomic,strong)   NSMutableDictionary  *PostDataDic;


/**
 *  上一次上传的参数信息
 */
@property(nonatomic,strong)  NSDictionary  *LatPostDataDic;


@property(nonatomic,copy)     NSString *lastRegionName;
@property(nonatomic,strong)   CZKeyboardToolbar  *keyBoardBar;
@property(nonatomic,strong)   UIScrollView  *mainScrollview;
@property(nonatomic,assign)   BOOL ScoSwitch;
@property(nonatomic,strong)   NSMutableSet  *hasSelectedAttachMent;
@property(nonatomic,strong)   UIView  *footerView;
@property(nonatomic,weak)     NSMutableArray *haSelectedImgs_MARR;
@property(nonatomic,strong)   NSMutableArray  *SelectedImgsData_MARR;



@property(nonatomic,strong)  EditCell  *RegionTF;




//公共方法便于继承
-(UITextField *) getFirstResponderTextfield;
-(NSInteger ) indexOfFirstResponder;
-(void)willShow:(NSNotificationCenter *)notifInfo;
-(void)willHide;
-(void)dealTextfield :(UITextField *)textfied isTextCenter:(BOOL)isTextCenter;
-(void)loadLastParamDic;
-(void)FormatRegionParam;


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);
-(void)checkContinue;
-(void)DataSave;
-(void)textFieldDidEndEditing:(UITextField *)textField;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

