//
//  OrederByChara.m
//  上传模块测试
//
//  Created by Larry on 15/10/31.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "LoacationNameTool.h"
#import "HttpTool.h"
#import "pinyin.h"

@interface LoacationNameTool (){
    
  // UIViewController
}

@end

@implementation LoacationNameTool



+(NSDictionary *)dictionaryWithUrl:(NSString *)url {
    NSMutableDictionary  *NSMdict = [NSMutableDictionary dictionary];
    NSMutableSet *NStempSave = [NSMutableSet new];
    [HttpTool QFGet:url parameters:nil success:^(id responseObject) {
        NSArray *dt = [NSArray array];
        NSLog(@"地址获取");
        dt = responseObject[@"data"];
        for (NSDictionary *dict in dt) {
            NSString *name = dict[@"name"];
            NSString   *Singindex=@"";
            char index = pinyinFirstLetter([name characterAtIndex:0]) - 32;
            Singindex = [Singindex stringByAppendingFormat:@"%c",index];
            
            switch (pinyinFirstLetter([name characterAtIndex:0]) - 32) {
                case 65:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *names = [NSMutableArray array];  //CityDataAr
                        [names addObject:dict];
                        [NSMdict setObject:names forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                case 66:  //b
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *names = [NSMutableArray array];
                        [names addObject:dict];
                        [NSMdict setObject:names forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                case 67:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                        [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 68:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 69:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 70:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                case 71:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 72:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 73:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 74:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 75:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 76:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 77:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 78:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 79:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 80:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 81:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 82:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 83:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 84:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 85:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 86:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 87:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                case 88:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 89:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                    
                    
                case 90:  //A
                    if (![NStempSave containsObject:Singindex]) { //不存在
                        [NStempSave addObject:Singindex];
                        NSMutableArray *A = [NSMutableArray array];
                      [A addObject:dict];
                        [NSMdict setObject:A forKey:Singindex];
                    }else{ //存在
                        NSMutableArray *temp = NSMdict[Singindex];
                        [temp addObject:dict];
                        [NSMdict setObject:temp forKey:Singindex];
                    }
                    break;
                    
                default:
                    break;
            }

        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    return NSMdict;
  }
# pragma  mark 获取已存在的首字母
+ (NSArray *) nameArratoCharaterIndexArrayWithfullnames:(NSArray *)array{
    NSMutableArray *ar = [NSMutableArray new];
    for (NSString *name in array) {
        NSString   *Singindex=@"";
        char index = pinyinFirstLetter([name characterAtIndex:0]) - 32;
        Singindex = [Singindex stringByAppendingFormat:@"%c",index];
        [ar addObject:Singindex];
    }
    return ar;
}
@end
