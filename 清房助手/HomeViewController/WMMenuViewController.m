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

#import "HttpTool.h"

#import "UIImageView+WebCache.h"

#import "AppDelegate.h"

#import <AudioToolbox/AudioToolbox.h>

#import "MsgViewController.h"
#import "QFMyOrderTableVC.h"

@interface WMMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) WMCommon *common;
@property (strong ,nonatomic) NSArray  *listArray;
@property(nonatomic,strong)   NSArray   *MethodArray;
@property(nonatomic,strong)  NSArray   *ImageNameArr;
@property(nonatomic,strong)  NSTimer   *ReuqeustTimer;

@property(nonatomic,strong)  NSMutableArray  *MsgMArr;
@property(nonatomic,strong)  NSMutableArray  *OrderMArr;

@property(nonatomic,assign) int CurrentMsgCount;

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



@property(nonatomic,weak)  MenuListCell  *MsgMenuCell;
@property(nonatomic,weak)  MenuListCell  *OderMenuCell;
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
    self.listArray = @[@"我的信息",@"房源查询", @"客源查询", @"信息发布", @"内部房源", @"内部客源",@"售后业务",@"我的收藏"];
    self.MethodArray = @[@"transtoMyMsg",@"OnlyBack",@"transToRentAndSale",@"transToPost",@"transToPost",@"transtoInnerKeyuan",@"transtoMutiTask",@"tranStoMyStars"];
    self.ImageNameArr = @[@"MsgmenuIcon",@"search-house",@"search-people",@"pen",@"house",@"people",@"afterMarket",@"pStar"];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight       = 50 * (self.common.screenW / 320);  //i6 = 100
 //  self.tableView.backgroundColor = [UIColor redColor];
    
 
    
    NSLog(@"高度:%f",   self.tableView.rowHeight);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.headerImageView.image = [UIImage imageNamed:@"head"];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 40;
    [self updateHeadimg];
    [self updateNameAndTele];
    
    
//    [NSTimer timerWithTimeInterval:6 target:self selector:@selector(RequestUnreadMsg) userInfo:nil repeats:YES];
   self.ReuqeustTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(RequestUnreadMsg) userInfo:nil repeats:YES];
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
    
  //   NSString *urlStr = [NSString stringWithFormat:@"http://www.123qf.cn:81/portrait/%@/%@",dic[@"userid"],dic[@"portrait"]];
      NSString *urlStr = [NSString stringWithFormat:@"http://www.123qf.cn/portrait/%@/%@",dic[@"userid"],dic[@"portrait"]];
    
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
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (isI5) {
        return 42;
    }
    
    if (isI4) {
        return 40;
    }
    
    if (isI6) {
       return 56;
    }
    return 65;  //IP6
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //定义图片
    
    // 没有用系统自带的类而用了自己重新定义的cell，仅仅为了之后扩展方便，无他
    MenuListCell *cell = [[MenuListCell alloc]init];
  
    if (isI6p) {
       cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuListCell" owner:nil options:nil] lastObject];
        cell.height = 100;
    } else if(isI6){
     cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuListCell" owner:nil options:nil] objectAtIndex:1];
           cell.height = 100;
    } else {
     cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuListCell" owner:nil options:nil]firstObject];
    }
   
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row==0) {
        self.MsgMenuCell = cell ;
    }
    
    if (indexPath.row ==6) {
        self.OderMenuCell = cell;
    }
    
     [self setCell:cell andIndex:indexPath];
    
    if (isI4) {
        [cell.MenuTitle setFont:[UIFont systemFontOfSize:15]];
    }
    
    return cell;
}

#pragma mark 侧栏菜单选择


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
// 被夹在这中间的代码针对于此警告都会无视并且不显示出来
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#warning 侧栏菜单选择
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //解除遗留灰色
    [self CallDelegateMethodWithIndexPath:indexPath];
    
}



-(void)CallDelegateMethodWithIndexPath:(NSIndexPath *)indexPath {
    NSString *methodName = self.MethodArray[indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.delegate performSelector:NSSelectorFromString(methodName)];
}
#pragma clang diagnostic pop

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
                                return scaledImage;
   }


-(void)RequestUnreadMsg {
    //如果未读消息数量不变
    NSLog(@"数据请求");
    NSMutableArray *MsgArrMsg = [NSMutableArray new];    NSMutableArray *MsgArrOrder = [NSMutableArray new];
    NSMutableArray *MsgRhid = [NSMutableArray new];
    [HttpTool keepDectectMessageWithSucess:^(NSArray *MsgArr) {
        int count = (int) [MsgArr count];
        if(count ==0) {
            [self MsgTipsClean];
        }
        
        if(count ==self.CurrentMsgCount) {    //如果和之前的数量不变
            return ;
        } else {
            //如果有新增
            
            //区分订单消息和网页消息
            
            [MsgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([(NSString *)obj[@"type"] isEqualToString:@"1"]) {
                    NSLog(@"消息原:%@",obj);
                    NSString *String = obj[@"date"];
                    NSMutableDictionary *realDiC = [self dictionaryWithJsonString:String];
                    [realDiC setObject: obj[@"createtime"]forKey:@"createtime"];
                    [realDiC setObject:obj[@"rhid"] forKey:@"rhid"];
                    [realDiC setObject:obj[@"rhid"]  forKey:@"rhid"];
                    NSLog(@"过滤后的消息:%@",realDiC);
                    
                    [MsgRhid addObject:obj[@"rhid"]];
                   [MsgArrMsg addObject:realDiC];
                } else {
                    NSLog(@"订单");
                    [MsgArrOrder addObject:obj];
                }
            }];
            
            self.MsgMArr = MsgArrMsg;  self.OrderMArr = MsgArrOrder;
            
            
            //订单消息
            if ([MsgArrOrder count]>0) {
                [self.OderMenuCell.MsgView setHidden:NO];
                 self.OderMenuCell.MsgCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[MsgArrOrder count]];
            }
            
            //留言消息
            if ([MsgArrMsg count]>0) {
                [self.MsgMenuCell.MsgView setHidden:NO];
                 self.MsgMenuCell.MsgCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[MsgArrMsg count]];
               
                
            }
            self.CurrentMsgCount = count;
            //我的消息，提示红色数量
            //震动与声音
          AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
          AudioServicesPlaySystemSound(1007);
            //保存数组的信息，用于展示 我的信息 之用
        }
        NSLog(@"以获取消息:%@",MsgArr);
        NSDictionary *dict = [MsgArr firstObject];
        
        NSLog(@"%@",dict[@"date"]);
        
        NSString *String = dict[@"date"];
        
        NSDictionary *realData = [self dictionaryWithJsonString:String];
        
        NSLog(@"过滤后的消息:%@",realData);

    }];
}

-(void)MsgTipsClean {
    [self.MsgMenuCell.MsgView setHidden:YES];
}

-(void)OrederTipsClean {
    [self.OderMenuCell.MsgView setHidden:YES];
}


-(void)setCell:(MenuListCell *)cell andIndex:(NSIndexPath *)indexpath {
    cell.Icon.image = [UIImage imageNamed:self.ImageNameArr[indexpath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.MenuTitle.text = self.listArray[indexpath.row];
}

- (NSMutableDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(UIImage *)setCellImgWithIndexPath:(NSIndexPath *)indexPath {
    UIImage *img = [UIImage imageNamed:self.ImageNameArr[indexPath.row]];
    return img;
}


-(void)PassMSgData:(MsgViewController *)MsgVC{
 //   MsgVC.MsgArr = self.MsgMArr;
}




@end
