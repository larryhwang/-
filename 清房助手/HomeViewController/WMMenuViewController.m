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
#import "MBProgressHUD+CZ.h"



#import "UIImageView+WebCache.h"

#import "AppDelegate.h"

@interface WMMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) WMCommon *common;
@property (strong ,nonatomic) NSArray  *listArray;

/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameDis;

/**
 *  电话号码
 */
@property (weak, nonatomic) IBOutlet UILabel *userTeleDis;


/**
 *  功能列表
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;


/**
 *  弃用的
 */
@property (weak, nonatomic) IBOutlet UIButton    *nightModeBtn;


/**
 *  设置功能按钮
 */
@property (weak, nonatomic) IBOutlet UIButton    *settingBtn;

/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

/**
 *  头像点击按钮，覆盖了头像图像
 */
@property (weak, nonatomic) IBOutlet UIButton *userInfoBtn;

@end

@implementation WMMenuViewController


//设置按钮
- (IBAction)settingBtnClick:(id)sender {
    NSLog(@"setting @@@————@@@@");
    //可以由StoryBoard 来设置的

    [self.delegate transToSetting];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.common = [WMCommon getInstance];
    self.listArray = @[@"房源查询", @"客源查询", @"信息发布", @"内部房源", @"内部客源",@"售后业务"];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight       = 50 * (self.common.screenW / 320);
    NSLog(@"高度:%f",   self.tableView.rowHeight);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.headerImageView.image = [UIImage imageNamed:@"head"];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 40;
    [self updateHeadimg];
    [self updateNameAndTele];
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


/**
 *  更改头像
 */
-(void)updateHeadimg {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSDictionary *dic = appDelegate.usrInfoDic;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.123qf.cn:81/portrait/%@/%@",dic[@"userid"],dic[@"portrait"]];
    
    NSLog(@"%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.headerImageView.frame];
    [imgView sd_setImageWithURL:url];
  //  [self.headerImageView sd_setImageWithURL:url];
    [self.headerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head"]];
}


/**
 *  更新姓名和电话
 */
-(void)updateNameAndTele {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSDictionary *dic = appDelegate.usrInfoDic;
    self.userNameDis.text = dic[@"username"];
    self.userTeleDis.text = dic[@"tel"];
    
}

- (IBAction)userInfoClick:(id)sender {
    NSLog(@"头像点击");
    //通知代理去跳转
    [self.delegate transToUserInfo];
}






#pragma mark - tableView代理方法及数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //定义图片
    
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
        UIImage *img = [UIImage imageNamed:@"house"];
        cell.Icon.image = img;
    }else if (indexPath.row ==4){
        UIImage *img = [UIImage imageNamed:@"people"];
        cell.Icon.image = img;
    }
    else {
        UIImage *img = [UIImage imageNamed:@"afterMarket"];
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
        [self.delegate transToPost];
    } else if (indexPath.row ==3){
        //内部房源
        [self.delegate transtoInnerFang];
    } else if (indexPath.row ==4) {
        //内部客源
        [self.delegate transtoInnerKeyuan];
    }else {
        //综合业务
        [self.delegate transtoMutiTask];
    }

    
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
