//
//  PostController.m
//  上传模块测试
//
//  Created by Larry on 15/10/28.
//  Copyright © 2015年 Larry. All rights reserved.

/*
    说明: 此页面描述发布界面前四大选项(动画)后，的四个房屋类别选择
 */
//





#import "PostCategory.h"
#import "SaleOutPostEditForm.h"
#import "AppDelegate.h"
#import "SaleOutOfiice.h"
#import "SaleOutShangPu.h"
#import "SaleoutChangFangViewController.h"



#import "RentOutFlatView.h"
#import "RentOutShangPu.h"
#import "RentOutOfiice.h"
#import "RentOutChang.h"

#import "WannaFlatVC.h"
#import "WannaShangPu.h"
#import "WannaOffice.h"
#import "WannaChang.h"

@interface PostCategory ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *CategoryTable;

@end
@implementation PostCategory

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.CategoryTable.scrollEnabled  = NO;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.Status == WantBuy || self.Status== WantRent) {
        return 3;
    }
    
    return 4;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.Status == WantBuy || self.Status== WantRent) {
        if (indexPath.row ==0) {
            cell.textLabel.text  =@"住宅";
        } else if (indexPath.row ==1) {
            cell.textLabel.text = @"商铺";
        }else if (indexPath.row ==2) {
            cell.textLabel.text = @"写字楼";
        }
    }  else {
        if (indexPath.row ==0) {
            cell.textLabel.text  =@"住宅";
        } else if (indexPath.row ==1) {
            cell.textLabel.text = @"商铺";
        }else if (indexPath.row ==2) {
            cell.textLabel.text = @"写字楼";
        }else  {
            cell.textLabel.text = @"厂房";
        }
    }
    
     return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SaleOutPostEditForm *editForm = [[SaleOutPostEditForm alloc]init];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //解除遗留灰色
    if (self.Status==SalesOut) {
        if (indexPath.row ==0) {
            NSLog(@"%@",app.provnceIndexDic);
            editForm.indexData  = app.provnceIndexDic;
            editForm.PreStatus  = SalesOut;
            editForm.Fenlei = FlatType;
            editForm.username   = app.usrInfoDic[@"username"];
            editForm.userId     = app.usrInfoDic[@"userid"];
            editForm.typeStr    = @"11";
            editForm.title = @"住宅出售";
            [self.navigationController pushViewController:editForm animated:YES];
        } else if (indexPath.row ==1) {
            SaleOutShangPu *pu = [[SaleOutShangPu alloc]init];
            pu.typeStr    = @"12";
            pu.PreStatus = SalesOut;
            pu.Fenlei = ShangPuType;
            pu.username   = app.usrInfoDic[@"username"];
            pu.userId     = app.usrInfoDic[@"userid"];
            pu.indexData  = app.provnceIndexDic;
            pu.title = @"商铺出售";
            
            [self.navigationController pushViewController:pu animated:YES];
        }else if (indexPath.row ==2) {
            //  cell.textLabel.text = @"写字楼";
            SaleOutOfiice *saleOffice = [SaleOutOfiice new];
            saleOffice.Fenlei = OfficeType;
            saleOffice.PreStatus = SalesOut;
            saleOffice.typeStr    = @"13";
            saleOffice.username   = app.usrInfoDic[@"username"];
            saleOffice.userId     = app.usrInfoDic[@"userid"];
            saleOffice.indexData  = app.provnceIndexDic;
            saleOffice.title = @"出售写字楼";
            [self.navigationController pushViewController:saleOffice animated:YES];
        }else  {
            SaleoutChangFangViewController *chang =[SaleoutChangFangViewController new];
            chang.PreStatus = SalesOut;
            chang.Fenlei = FactoryType;
            chang.typeStr    = @"14";
            chang.username   = app.usrInfoDic[@"username"];
            chang.userId     = app.usrInfoDic[@"userid"];
            chang.indexData  = app.provnceIndexDic;
            chang.title = @"出售工厂";
            [self.navigationController pushViewController:chang animated:YES];
        }
    }//end_出售
else if (self.Status==RentOut){
      NSLog(@"出租");
        if (indexPath.row ==0) {
            NSLog(@"住宅出租");
            RentOutFlatView  *rentFlat = [RentOutFlatView new];
            rentFlat.indexData  = app.provnceIndexDic;
            rentFlat.PreStatus  = RentOut;
            rentFlat.Fenlei = FlatType;
            rentFlat.username   = app.usrInfoDic[@"username"];
            rentFlat.userId     = app.usrInfoDic[@"userid"];
            rentFlat.typeStr    = @"21";
            rentFlat.title = @"住宅出租";
            [self.navigationController pushViewController:rentFlat animated:YES];
        } else if (indexPath.row ==1) {
          NSLog(@"商铺出租");
            RentOutShangPu *rentShangpu = [RentOutShangPu new];
            rentShangpu.indexData  = app.provnceIndexDic;
            rentShangpu.PreStatus  = RentOut;
            rentShangpu.Fenlei = ShangPuType;
            rentShangpu.username   = app.usrInfoDic[@"username"];
            rentShangpu.userId     = app.usrInfoDic[@"userid"];
            rentShangpu.typeStr    = @"22";
            rentShangpu.title = @"商铺出租";
            [self.navigationController pushViewController:rentShangpu animated:YES];
            
        }else if (indexPath.row ==2) {
          NSLog(@"写字楼出租");
            RentOutOfiice *RentOffice =[RentOutOfiice new];
            RentOffice.indexData  = app.provnceIndexDic;
            RentOffice.PreStatus  = RentOut;
            RentOffice.Fenlei = OfficeType;
            RentOffice.username   = app.usrInfoDic[@"username"];
            RentOffice.userId     = app.usrInfoDic[@"userid"];
            RentOffice.typeStr    = @"23";
            RentOffice.title = @"写字楼出租";
            [self.navigationController pushViewController:RentOffice animated:YES];
            
        }else  {
          NSLog(@"出租工厂");
            RentOutChang *rentChang = [RentOutChang new];
            rentChang.indexData  = app.provnceIndexDic;
            rentChang.PreStatus  = RentOut;
            rentChang.Fenlei = FactoryType;
            rentChang.username   = app.usrInfoDic[@"username"];
            rentChang.userId     = app.usrInfoDic[@"userid"];
            rentChang.typeStr    = @"24";
            rentChang.title = @"厂房出租";
            [self.navigationController pushViewController:rentChang animated:YES];
            
        }
    }//end_出租
else if (self.Status==WantBuy){
    if (indexPath.row ==0) {
        NSLog(@"住宅求购");
        WannaFlatVC *QiuzuFlat = [WannaFlatVC new];
        QiuzuFlat.indexData = app.provnceIndexDic;
        QiuzuFlat.username   = app.usrInfoDic[@"username"];
        QiuzuFlat.userId     = app.usrInfoDic[@"userid"];
        QiuzuFlat.typeStr = @"31";
        QiuzuFlat.title = @"住房求购";
        QiuzuFlat.iSQiuzu = NO;
       [self.navigationController pushViewController:QiuzuFlat animated:YES];
    } else if (indexPath.row ==1) {
        NSLog(@"商铺求购");
        WannaShangPu *wangShangu = [WannaShangPu new];
        wangShangu.indexData = app.provnceIndexDic;
        wangShangu.username   = app.usrInfoDic[@"username"];
        wangShangu.userId     = app.usrInfoDic[@"userid"];
        wangShangu.typeStr = @"32";
        wangShangu.title = @"商铺求购";
        wangShangu.iSQiuzu = NO;
        [self.navigationController pushViewController:wangShangu animated:YES];
    }else if (indexPath.row ==2) {
        NSLog(@"写字楼求购");
        WannaOffice *wanaOffice = [WannaOffice new];
        wanaOffice.indexData = app.provnceIndexDic;
        wanaOffice.username   = app.usrInfoDic[@"username"];
        wanaOffice.userId     = app.usrInfoDic[@"userid"];
        wanaOffice.title = @"写字楼求购";
        wanaOffice.typeStr = @"33";
        wanaOffice.iSQiuzu = NO;
        [self.navigationController pushViewController:wanaOffice animated:YES];
    }else  {
        NSLog(@"工厂求购");
        WannaChang *wangChang = [WannaChang new];
        wangChang.indexData = app.provnceIndexDic;
        wangChang.username   = app.usrInfoDic[@"username"];
        wangChang.userId     = app.usrInfoDic[@"userid"];
        wangChang.title = @"工厂求购";
        wangChang.typeStr = @"34";
        wangChang.iSQiuzu = NO;
        [self.navigationController pushViewController:wangChang animated:YES];
    }
}// end_求购
else if (self.Status==WantRent){
    NSLog(@"求租");
    if (indexPath.row ==0) {
        NSLog(@"住宅求租");
        WannaFlatVC *QiuzuFlat = [WannaFlatVC new];
        QiuzuFlat.indexData = app.provnceIndexDic;
        QiuzuFlat.username   = app.usrInfoDic[@"username"];
        QiuzuFlat.userId     = app.usrInfoDic[@"userid"];
        QiuzuFlat.typeStr = @"41";
        QiuzuFlat.title = @"住房求租";
        QiuzuFlat.iSQiuzu = YES;
        [self.navigationController pushViewController:QiuzuFlat animated:YES];
    } else if (indexPath.row ==1) {
        NSLog(@"商铺求租");
        WannaShangPu *wangShangu = [WannaShangPu new];
        wangShangu.indexData = app.provnceIndexDic;
        wangShangu.username   = app.usrInfoDic[@"username"];
        wangShangu.userId     = app.usrInfoDic[@"userid"];
        wangShangu.typeStr = @"42";
        wangShangu.title = @"商铺求租";
        wangShangu.iSQiuzu = YES;
        [self.navigationController pushViewController:wangShangu animated:YES];
    }else if (indexPath.row ==2) {
        NSLog(@"写字楼求租");
        WannaOffice *wanaOffice = [WannaOffice new];
        wanaOffice.indexData = app.provnceIndexDic;
        wanaOffice.username   = app.usrInfoDic[@"username"];
        wanaOffice.userId     = app.usrInfoDic[@"userid"];
        wanaOffice.title = @"写字楼求租";
        wanaOffice.typeStr = @"43";
        wanaOffice.iSQiuzu = YES;
        [self.navigationController pushViewController:wanaOffice animated:YES];
    }else  {
        NSLog(@"工厂求租");
        WannaChang *wangChang = [WannaChang new];
        wangChang.indexData = app.provnceIndexDic;
        wangChang.username   = app.usrInfoDic[@"username"];
        wangChang.userId     = app.usrInfoDic[@"userid"];
        wangChang.title      = @"工厂求租";
        wangChang.typeStr    = @"44";
        wangChang.iSQiuzu    = YES;
        [self.navigationController pushViewController:wangChang animated:YES];
    }
}// end_求租
    
    
}

@end
