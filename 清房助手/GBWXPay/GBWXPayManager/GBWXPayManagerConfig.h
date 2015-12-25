//
//  GBWXPayManagerConfig.h
//  微信支付
//
//  Created by 张国兵 on 15/7/25.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#ifndef _____GBWXPayManagerConfig_h
#define _____GBWXPayManagerConfig_h
//===================== 微信账号帐户资料=======================

#import "payRequsestHandler.h"         //导入微信支付类
#import "WXApi.h"

#define APP_ID          @"wxc18bcaefb8a325cf"               //APPID
#define APP_SECRET      @"b3d4a1b5958de7ba0035f1886dc326a8" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1295009801"
//商户API密钥，填写相应参数
#define PARTNER_ID      @"HuiZhouHeSiFangWLKJYXGS123456HSF"
//支付结果回调页面
#define NOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

#endif
