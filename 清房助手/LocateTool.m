//
//  LocateTool.m
//  上传模块测试
//
//  Created by Larry on 15/11/2.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import "LocateTool.h"


static LocateTool *sharedInstance;    //静态对象，用于标记

@interface LocateTool()<CLLocationManagerDelegate>  //CLLocationManagerDelegate
{
    
}

@end

@implementation LocateTool


- (id)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //设置定位的精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;//kCLLocationAccuracyBest;
      //  设置移动多少距离后,触发代理.
       //     _locationManager.distanceFilter = 10;
        if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)
        {
            [_locationManager requestWhenInUseAuthorization];// 前台定位
            [_locationManager requestAlwaysAuthorization];// 前后台同时定位

        }
    }
    return self;
}


//单实例的创建

+(id) allocWithZone:(NSZone *)zone {   // 对类操作 ＋
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}


+(LocateTool *) sharedLocateTool {   //对类操作 用＋
    static dispatch_once_t onceToken;   //防止多线程开启
    dispatch_once(&onceToken, ^{
        sharedInstance =[[LocateTool alloc]init];
    });
    return sharedInstance;
}

- (NSString *)GetCityName {
    return _CityName;
}



- (void)StartGetCityName {
    [_locationManager startUpdatingLocation];
}


#pragma mark -delegate
// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error%@",error);
}
//// 6.0 以上调用这个函数
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = locations[0];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       for (CLPlacemark *place in placemarks) {
                           _CityName = place.locality ;
                           _update(_CityName);   //更新页面
                           NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                           [defaults setObject:_CityName forKey:@"NowCityname"];
                           [self.delegate passValue:_CityName];
                       }
                           [_locationManager stopUpdatingLocation];
                   }];
   
}




@end
