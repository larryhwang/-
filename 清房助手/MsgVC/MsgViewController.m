//
//  MsgViewController.m
//  清房助手
//
//  Created by Larry on 2/2/16.
//  Copyright © 2016 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "MsgViewController.h"
#import "TableViewCell.h"

@interface MsgViewController ()<UITableViewDataSource,UITableViewDataSource>

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.MsgTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSLog(@"TTT:%@",self.MsgArr);
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
