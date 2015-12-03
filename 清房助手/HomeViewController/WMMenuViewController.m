//
//  WMMenuViewController.m
//  QQSlideMenu
//
//  Created by wamaker on 15/6/12.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import "WMMenuViewController.h"
#import "WMMenuTableViewCell.h"
#import "WMCommon.h"
#import "UIImage+WM.h"
#import "QFSearchBar.h"
#import "MenuListCell.h"
#import "PostViewController.h"

@interface WMMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) WMCommon *common;
@property (strong ,nonatomic) NSArray  *listArray;
@property (weak, nonatomic) IBOutlet UILabel *userNameDis;
@property (weak, nonatomic) IBOutlet UILabel *userTeleDis;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton    *nightModeBtn;
@property (weak, nonatomic) IBOutlet UIButton    *settingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

- (IBAction)btnClick:(id)sender;

@end

@implementation WMMenuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.common = [WMCommon getInstance];
    self.listArray = @[@"房源查询", @"客源查询", @"发布", @"我的客源", @"我的房源"];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight       = 50 * (self.common.screenW / 320);
    NSLog(@"高度:%f",   self.tableView.rowHeight);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.headerImageView.image = [[UIImage imageNamed:@"Icon"] getRoundImage];
}

- (void)btnClick:(id)sender {
    if (sender == self.nightModeBtn) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"使用提示" message:@"要使用夜间模式需下载主题包，立即下载？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即下载", nil];
        [alertView show];
    } else {
        if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
            [self.delegate didSelectItem:self.settingBtn.titleLabel.text];
        }
    }
}

#pragma mark - tableView代理方法及数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 没有用系统自带的类而用了自己重新定义的cell，仅仅为了之后扩展方便，无他
    MenuListCell *cell = [[MenuListCell alloc]init];
  
    cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuListCell" owner:nil options:nil] firstObject];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        UIImage *img = [UIImage imageNamed:@"search-house"];
        cell.Icon.image = img;
    } else if (indexPath.row ==1) {
        UIImage *img = [UIImage imageNamed:@"search-people"];
        cell.Icon.image = img;
    }else if (indexPath.row ==2) {
        UIImage *img = [UIImage imageNamed:@"pen"];
        cell.Icon.image = img;
    }else if (indexPath.row ==3){
        UIImage *img = [UIImage imageNamed:@"people"];
        cell.Icon.image = img;
    }else {
        UIImage *img = [UIImage imageNamed:@"house"];
        cell.Icon.image = img;
    }

    cell.MenuTitle.text = self.listArray[indexPath.row];
    return cell;
}

#pragma mark 侧栏菜单选择

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#warning 侧栏菜单选择
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //解除遗留灰色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.delegate OnlyBack];  //仅仅回到
    } else if (indexPath.row == 1) {
        [self.delegate transToRentAndSale];
         //客源查询
    } else if (indexPath.row ==2) {
        //发布
//        PostViewController *Ct = [[PostViewController alloc]init];
//        Ct.title = @"发布";
//        [self.navigationController pushViewController:Ct animated:YES];
        
        [self.delegate transToPost];
    } else if (indexPath.row ==3){
        //我的客源
    } else {
        //我的房源
    }
//    if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
    //    [self.delegate didSelectItem:self.listArray[indexPath.row]];
//    }
    
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
                                return scaledImage;
   }

@end
