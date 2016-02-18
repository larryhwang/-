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

@property(nonatomic,strong)  AFHTTPRequestOperationManager  *ShareMgr;
@property(nonatomic,strong)  NSMutableArray  *MsgRhidArr;
@property(nonatomic,weak) NSDictionary *SingleMsgData;

@end

@implementation MsgViewController

- (void)viewDidLoad {
 
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.MsgTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    NSLog(@"TTT:%@",self.MsgArr);
    
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(RequestUnreadMsg) userInfo:nil repeats:NO];
    

    
    
}


-(void)dealData {
    
}


-(void)getNetData {
   
    
}

-(void)RequestUnreadMsg {
    //如果未读消息数量不变
    // 先追加，再存取
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDirectory = [paths objectAtIndex:0];
    
    NSString *path = [pathDirectory stringByAppendingPathComponent:@"MsgArr.archive"];
    NSMutableArray *lastMsgArr = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSLog(@"取出的数组:%@",lastMsgArr);
    [MBProgressHUD showMessage:@"加载中"];
    NSLog(@"数据请求");
    NSMutableArray *MsgArrMsg = [NSMutableArray new];    NSMutableArray *MsgRhid = [NSMutableArray new];
    [HttpTool keepDectectMessageWithSucess:^(NSArray *MsgArr) {
        int count = (int) [MsgArr count];
        if(count ==0) {
            if ([lastMsgArr count]) {
                self.MsgArr = lastMsgArr;
                [MBProgressHUD hideHUD];
               [self.MsgTable reloadData];
            }else {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"暂无消息"];
            }
            return ;
        } else {
            [MsgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([(NSString *)obj[@"type"] isEqualToString:@"1"]) {
                    NSLog(@"消息原:%@",obj);
                    NSString *String = obj[@"date"];
                    NSMutableDictionary *realDiC = [self dictionaryWithJsonString:String];
                    [realDiC setObject: obj[@"createtime"]forKey:@"createtime"]; //时间
                    [MsgRhid addObject:obj[@"rhid"]];  //消息标记码
                    NSLog(@"过滤后的消息:%@",realDiC);
                    [MsgArrMsg addObject:realDiC];
                } else {
                    
                }
            }];
        }
      
        self.MsgRhidArr = MsgRhid ;
        NSArray   *arr = [NSArray new];
        if ([MsgArrMsg count] &&[lastMsgArr count]) {
           arr   =  [MsgArrMsg arrayByAddingObjectsFromArray:lastMsgArr];
           self.MsgArr = arr;
        }
        BOOL sucess = [NSKeyedArchiver archiveRootObject:self.MsgArr toFile:path];
        if (sucess)
        {
            NSLog(@"archive sucess");
        }
 
        //获取到网络端的数据后再追加到本地数据
        
        NSLog(@"最后:a%@",arr);
        
       
       
        
        [MBProgressHUD hideHUD];
        [self.MsgTable reloadData];
       
     
        NSLog(@"以获取消息:%@",MsgArrMsg);
    
        
    }];
}


-(void)cleanMsgUreadFlag  {
    // updatePant.back
    self.ShareMgr = [AFHTTPRequestOperationManager manager];
    NSString *url = @"http://www.123qf.cn/app/updatePant.api?rhid=";   // self.ShareMgr
  __block    NSString *Rhids = [self.MsgRhidArr firstObject];
    [self.MsgRhidArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >0) {
           Rhids = [Rhids stringByAppendingString:[NSString stringWithFormat:@",%@",(NSString *)obj]];
        }
    }];
    
    url = [url stringByAppendingString:Rhids];
   [self.ShareMgr POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"shabi:%@",responseObject);
       NSLog(@"DEBUG");
   } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
       NSLog(@"HHHH%@",error);
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
 
    return [self.MsgArr count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.MsgTable setEditing:false animated:true];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString    *identifer = @"UITableViewCell";
    TableViewCell *cell = [TableViewCell new];
   
  //   cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:nil options:nil]lastObject];
        self.SingleMsgData = [self.MsgArr objectAtIndex:indexPath.row];
        cell.CellDic = [self.MsgArr objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.MsgTable setEditing:false animated:true];
        
        NSLog(@"%@",action.title);
        
        if(indexPath.row ==0) {
            NSLog(@"0");
        }
        
        if(indexPath.row ==1) {
            NSLog(@"1");
        }
        
        if(indexPath.row ==2) {
            NSLog(@"2");
        }
    };
    

    //    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[buttonForImage imageForState:UIControlStateNormal] handler:rowActionHandler];
    //
    //    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"disenable" handler:rowActionHandler];
    //    action2.enabled = false;
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消" handler:rowActionHandler];
    UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    
    return @[action2,action3];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   //  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
