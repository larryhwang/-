//
//  HomeCitySelecVC.m
//  清房助手
//
//  Created by Larry on 12/29/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "HomeCitySelecVC.h"
#import "AFNetworking.h"

@interface HomeCitySelecVC ()<UITableViewDataSource,UITableViewDelegate> {
    int clickDepth;
    NSString *provName;
    NSString *cityName;
}
@property (weak, nonatomic) IBOutlet UITableView *QFtable;

@end

@implementation HomeCitySelecVC

- (void)viewDidLoad {
     [super viewDidLoad];
     self.edgesForExtendedLayout = UIRectEdgeNone;
     clickDepth = 0 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_QFProvinces_Arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString    *identifer = @"identifer";
    NSDictionary *dict = _QFProvinces_Arr[indexPath.row];
    UITableViewCell    *Cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == Cell)
    {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
    }
    Cell.textLabel.text = dict[@"name"];
    return Cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _QFProvinces_Arr[indexPath.row];
    NSString *code = dic[@"code"];
    NSString *locateName = dic[@"name"];
    NSRange rangeOfshi = [locateName rangeOfString:@"市"];
    NSString *url = [NSString stringWithFormat:@"http://www.123qf.cn:81/testApp/area/selectArea.api?parentid=%@",code];
    clickDepth ++ ;

    //保留省市名称
#warning 北京市崩溃
    if(clickDepth ==1) {
        if(rangeOfshi.length) {
           cityName = locateName;
           self.updateCityOptionsWithDic(dic,provName,cityName);
           [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        provName = locateName;
    }else {
        cityName = locateName;
    }
    
    
    
    if (clickDepth>1  ||rangeOfshi.length ) {      //点击层数达到两级，就完返回
        
        self.updateCityOptionsWithDic(dic,provName,cityName);
        [self.navigationController popViewControllerAnimated:YES];
    } else {  //重载数据
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        [mgr POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            _QFProvinces_Arr = responseObject[@"data"];
            [_QFtable reloadData];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
    }
}

@end
