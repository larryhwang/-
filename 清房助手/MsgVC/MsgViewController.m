//
//  MsgViewController.m
//  清房助手
//
//  Created by Larry on 2/2/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "MsgViewController.h"
#import "TableViewCell.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "HttpTool.h"
#import "MBProgressHUD+CZ.h"

@interface MsgViewController ()<UITableViewDataSource,UITableViewDataSource>

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.MsgTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSLog(@"TTT:%@",self.MsgArr);
    
    [self RequestUnreadMsg];
}


-(void)dealData {
    
}


-(void)getNetData {
   
    
    
    
}

-(void)RequestUnreadMsg {
    //如果未读消息数量不变
    [MBProgressHUD showMessage:@"加载中"];
    NSLog(@"数据请求");
    NSMutableArray *MsgArrMsg = [NSMutableArray new];    NSMutableArray *MsgArrOrder = [NSMutableArray new];
    [HttpTool keepDectectMessageWithSucess:^(NSArray *MsgArr) {
        int count = (int) [MsgArr count];
        if(count ==0) {
            return ;
        }
        [MsgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([(NSString *)obj[@"type"] isEqualToString:@"1"]) {
                NSLog(@"消息原:%@",obj);
                NSString *String = obj[@"date"];
                NSMutableDictionary *realDiC = [self dictionaryWithJsonString:String];
                [realDiC setObject: obj[@"createtime"]forKey:@"createtime"];
                [realDiC setObject:obj[@"rhid"]  forKey:@"rhid"];
                NSLog(@"过滤后的消息:%@",realDiC);
                [MsgArrMsg addObject:realDiC];
            } else {
                NSLog(@"订单");
                [MsgArrOrder addObject:obj];
            }
        }];
        
        self.MsgArr = MsgArrMsg;
        [MBProgressHUD hideHUD];
        [self.MsgTable reloadData];
       
        
        NSLog(@"以获取消息:%@",MsgArrMsg);
    
        
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    return 148;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 //   return 5;
    return [self.MsgArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString    *identifer = @"identifer";
    TableViewCell *cell = [TableViewCell new];
    
     cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:nil options:nil]lastObject];
        cell.CellDic = [self.MsgArr objectAtIndex:indexPath.row];
    }
    return cell;
}
@end
