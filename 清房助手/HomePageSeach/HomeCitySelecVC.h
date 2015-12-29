//
//  HomeCitySelecVC.h
//  清房助手
//
//  Created by Larry on 12/29/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCitySelecVC : UIViewController

@property(nonatomic,strong)   NSArray    *QFProvinces_Arr;

@property(nonatomic,copy) void  (^updateCityOptionsWithDic)(NSDictionary *dic,NSString *proName, NSString *cityName);

@end
