//
//  LocateTool.h
//  上传模块测试
//
//  Created by Larry on 15/11/2.
//  Copyright © 2015年 Larry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <UIKit/UIKit.h>

@protocol LocateToolDelegate <NSObject>

-(void)passValue:(NSString *) value;

@end

@interface LocateTool : NSObject

@property(nonatomic,strong)  NSString  *Provname;
@property(nonatomic,strong)  NSString  *CityName;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic,assign) id<LocateToolDelegate> delegate;
@property(nonatomic,copy) void (^update)(NSString *cityName);

+ (instancetype)sharedLocateTool;
- (void)StartGetCityName;

- (NSString *)GetCityName;


@end
