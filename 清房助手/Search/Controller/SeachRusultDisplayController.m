//
//  SeachRusultDisplayController.m
//  清房助手
//
//  Created by Larry on 12/8/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "SeachRusultDisplayController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "SalesCell.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "OneViewController.h"
#import "HomeViewController.h"
#import "FilterViewController.h"
#import "QFTableView_Sco.h"

/**
 *  本页面用于展示搜索结果后的图列表信息
 */

@interface SeachRusultDisplayController ()<UITableViewDelegate,UITableViewDataSource> {
    AFHTTPRequestOperationManager     *_HttpManager;
    NSString                          *_preName;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation SeachRusultDisplayController


-(NSArray *) dataFromNet {
    if (_dataFromNet ==nil) {
        _dataFromNet = [NSArray new];
    }
    return _dataFromNet;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"TableVC导航类名:%@",[self.navigationController class]);
    self.edgesForExtendedLayout = NO;
    [self initNav];
    [self basicUISet];
    [self netData];
    NSLog(@"FUCK:%@",self.navigationController);

}



-(void)initNav {
    UIButton *RightBarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 27)];
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"筛选"]];
    [img setFrame:CGRectMake(0, 0, 27, 27)];
    [RightBarBtn addSubview:img];
    [RightBarBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [RightBarBtn addTarget:self action:@selector(ConditionsFilter) forControlEvents:UIControlEventTouchUpInside];
    [RightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RightBarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
    UIBarButtonItem *gripeBarBtn = [[UIBarButtonItem alloc]initWithCustomView:RightBarBtn];
    self.navigationItem.rightBarButtonItem =gripeBarBtn;
}
-(void)basicUISet {
    self.title = @"搜索结果";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Dissback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationController.navigationBar.barTintColor = [DeafaultColor2 colorWithAlphaComponent:0.5];
    self.navigationController.navigationItem.leftBarButtonItem = back ;
    self.navigationItem.leftBarButtonItem = back ;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone ;
}

-(void)QFshowDetailWithFangYuanID:(NSString *)FangId andFenlei:(NSString *)Fenlei userID:(NSString *)UserId XiaoquName:(NSString *)name ListStatus:(NSString *)status {
    DetailViewController *test = [DetailViewController new];
    test.title = name;
    test.PreTitle = status;
    test.DisplayId = FangId;
    test.FenLei = Fenlei;
    test.uerID = UserId;
   [self.navigationController pushViewController:test animated:YES];

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataFromNet[indexPath.row];
    [self QFshowDetailWithFangYuanID:dic[@"id"] andFenlei:dic[@"fenlei"] userID:dic[@"userid"] XiaoquName:dic[@"mingcheng"] ListStatus:_preName];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"单元格数量%d",self.dataFromNet.count);
    return self.dataFromNet.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_ResultListStatus ==SalesOut) {
        _preName = @"[出售]";
    } else if (_ResultListStatus ==RentOut) {
        _preName = @"[出租]";
    } else if (_ResultListStatus ==WantBuy) {
        _preName = @"[求购]";
    }else {
        _preName = @"[求租]";
    }
    // 1.创建CELL
    static NSString *ID = @"identifer";
    SalesCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SalesCell" owner:nil options:nil] firstObject];
    }
    NSDictionary *SingleData = self.dataFromNet[indexPath.row];
#pragma mark 售价高亮属性
    NSString *PriceString = [NSString stringWithFormat:@"%@万元",SingleData[@"shoujia"]];
    NSMutableAttributedString *HiligntNo = [[NSMutableAttributedString alloc]initWithString:PriceString];
    NSRange NoRange = NSMakeRange(0, [PriceString length]-2);
    [HiligntNo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NoRange];
    [HiligntNo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ]  range:NoRange];
    
    NSString *imgCollects = SingleData[@"tupian"];
    NSArray *imgArray = [imgCollects componentsSeparatedByString:@","];
    NSString *imgURL = [NSString stringWithFormat:@"http://www.123qf.cn/testWeb/img/%@/userfile/qfzs/fy/mini/%@",SingleData[@"userid"],[imgArray firstObject]];
    NSLog(@"图片地址:%@",imgURL);
    
    NSString *BigTitle = [NSString stringWithFormat:@"%@%@",_preName,SingleData[@"biaoti"]];
    NSArray *titlePartArra = [BigTitle componentsSeparatedByString:@" "]; //
    UIImage  *PlaceHoder = [UIImage imageNamed:@"DeafaultImage"];
    PlaceHoder = [PlaceHoder imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [cell.QFImageView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:PlaceHoder];
    cell.title.text = [titlePartArra firstObject];
    cell.area.text  = [NSString stringWithFormat:@"面积:%@㎡",SingleData[@"mianji"]]; //SingleData[@"mianji"];
#warning 几室几厅数据没有返回
    cell.style.text = @"两室";
    cell.elevator.text = @"电梯";
    cell.price.text =[NSString stringWithFormat:@"%@万",PriceString];
   [cell.price setAttributedText:HiligntNo];
    
    NSString *Publisher =SingleData[@"publisher"];
    if ([Publisher isKindOfClass:[NSNull class]]) {
        cell.postUer.text = @"佚名";
    }else{
        cell.postUer.text =[NSString stringWithFormat:@"发布人:%@",SingleData[@"publisher"]];
    }
    cell.postTime.text = [NSString stringWithFormat:@"发布时间:%@",SingleData[@"weituodate"]];
    return cell;

}

-(void)netData{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:_searchParam forKey:@"param"];
    [param setObject:@"20" forKey:@"sum"];
    [param setObject:@"1"  forKey:@"currentpage"];
    
    switch (_ResultListStatus) {
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
    
    _HttpManager   =  [AFHTTPRequestOperationManager manager];
     NSString *url = @"http://www.123qf.cn:81/testApp/seach/echoSeachFKYuanList.api";
    
   [_HttpManager POST:url parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    NSLog(@"%@",responseObject);
    self.dataFromNet = responseObject[@"data"];
    [self.tableview reloadData];
     } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
         NSLog(@"%@",error);
     }];
}

-(void)Dissback {
    [self dismissViewControllerAnimated:YES completion:nil];
    HomeViewController *home = [HomeViewController new];
    KeyWindow.rootViewController = home;
}

-(void)ConditionsFilter {

    FilterViewController *FVC =[[FilterViewController alloc]init];
    FVC.title = @"筛选条件";
    [self.navigationController pushViewController:FVC animated:YES];
    
    
}


@end
