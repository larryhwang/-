//
//  TableViewController.m
//  UISearchController_Demo
//
//  Created by 沈红榜 on 15/5/5.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "TableViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface TableViewController ()

@end

@implementation TableViewController {
    NSMutableArray *_dataArray;
    AFHTTPRequestOperationManager *_AFNmanager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.textLabel.text = dic[@"biaoti"];
    
    return cell;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *intputStr = searchController.searchBar.text;
    if ([intputStr length] ==0) {
        return;
    }
    NSLog(@"输入数据:%@",intputStr);
    NSMutableDictionary *param  = [NSMutableDictionary dictionaryWithObjects:@[@"20",@"0",@"1"]
                                                       forKeys:@[@"sum",@"zushou",@"currentpage"]];
    
//    NSString *url = @"http://www.123qf.cn:81/testApp/fangyuan/rentalOrBuyHouseSearch.api?sum=20&zushou=0&shengfen=广东省&currentpage=1";
    [param setObject:intputStr forKey:@"shengfen"];
    NSString *url = @"http://www.123qf.cn:81/testApp/fangyuan/rentalOrBuyHouseSearch.api";
    [_AFNmanager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"数据接收%@",responseObject);
        NSNumber *flag = responseObject[@"code"];
        NSArray *ar = responseObject[@"data"];
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

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击搜索结果，跳到详情页面
    NSLog(@"点击搜索结果");
}

@end
