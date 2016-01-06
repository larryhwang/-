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
    return 4;
}

-(void)saveDataAlert {
    NSLog(@"已拦截");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row ==0) {
        cell.textLabel.text  =@"住宅";
    } else if (indexPath.row ==1) {
        cell.textLabel.text = @"商铺";
    }else if (indexPath.row ==2) {
        cell.textLabel.text = @"写字楼";
    }else  {
        cell.textLabel.text = @"厂房";
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES]; //解除遗留灰色
    if (indexPath.row ==0) {
       // cell.textLabel.text  =@"住宅";
        SaleOutPostEditForm *editForm = [[SaleOutPostEditForm alloc]init];
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        NSLog(@"%@",app.provnceIndexDic);
        editForm.indexData    =   app.provnceIndexDic;
        editForm.title = @"住宅出售";
        [self.navigationController pushViewController:editForm animated:YES];
    } else if (indexPath.row ==1) {
       // cell.textLabel.text = @"商铺";
    }else if (indexPath.row ==2) {
      //  cell.textLabel.text = @"写字楼";
    }else  {
        //cell.textLabel.text = @"广场";
    }
    
}

@end
