//
//  TableViewController.m
//  UISearchController_Demo
//
//  Created by 沈红榜 on 15/5/5.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "TableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SeachRusultDisplayController.h"
#import "DetailViewController.h"


@interface TableViewController ()

@end

@implementation TableViewController {
    NSMutableArray *_dataArray;
    AFHTTPRequestOperationManager *_AFNmanager;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"接收到的:%d",self.searchStyle);
    NSLog(@"TableVC导航类名:%@",[self.navigationController class]);
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray new];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    _AFNmanager = manger;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    


    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.textLabel.text  = dic[@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"约%@件",dic[@"count"]];  //dic[@"count"];
    return cell;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"接收到的:%d",self.searchStyle);
    NSString *intputStr = searchController.searchBar.text;
    if ([intputStr length] ==0) {
        return;
    }
    NSLog(@"输入数据:%@",intputStr);
    NSMutableDictionary *param  = [NSMutableDictionary dictionaryWithObjects:@[@"0",@"1"]
                                                                    forKeys:@[@"state",@"isfangyuan"]];
    switch (_searchStyle) {
        case 0:
            [param setObject:@"0" forKey:@"state"];
            [param setObject:@"1" forKey:@"isfangyuan"];
            break;
        case 1:
            [param setObject:@"1" forKey:@"state"];
            [param setObject:@"1" forKey:@"isfangyuan"];
            break;
        case 2:
            [param setObject:@"1" forKey:@"state"];
            [param setObject:@"0" forKey:@"isfangyuan"];
            break;
        case 3:
            [param setObject:@"0" forKey:@"state"];
            [param setObject:@"1" forKey:@"isfangyuan"];
            break;
        default:
            break;
    }
    
   [param setObject:intputStr forKey:@"param"];
    NSString *SeachBasicURL = @"http://www.123qf.cn:81/testApp/seach/echoSeach.api";
    NSString *url = @"http://www.123qf.cn:81/testApp/fangyuan/rentalOrBuyHouseSearch.api";
    [_AFNmanager POST:SeachBasicURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"数据接收%@",responseObject);
        NSNumber *flag = responseObject[@"code"];
        NSArray  *ar = responseObject[@"data"];
        if ([flag isEqualToNumber:[NSNumber numberWithInt:1]] ) {
        _dataArray = responseObject[@"data"];
        [self.tableView reloadData];            
        } else {
            if (![ar isKindOfClass:[NSArray class]]) {
                _dataArray = (NSMutableArray *)@[];
                [self.tableView reloadData];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}



#pragma mark -tableMethodDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击搜索结果，跳到详情页面
    NSDictionary *dict = _dataArray[indexPath.row];
    NSLog(@"点击搜索到的文字结果");
    SeachRusultDisplayController *result = [[SeachRusultDisplayController alloc]init];
    result.ResultListStatus = _searchStyle;  //状态
    result.resultDataArr    = _dataArray;     //数组
    result.searchParam      = dict[@"title"];
    result.navigationController.navigationBar.barTintColor = [DeafaultColor2 colorWithAlphaComponent:0.5];
    UINavigationController *search = [[UINavigationController alloc]initWithRootViewController:result];
    search.navigationController.navigationBar.barTintColor = [DeafaultColor2 colorWithAlphaComponent:0.5];
    NSLog(@"导航栏:%@",self.navigationController);
    NSLog(@"自己:%@",self);
    
//    [self presentViewController:search animated:NO completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    mainWindow.rootViewController = search ;

}










@end
