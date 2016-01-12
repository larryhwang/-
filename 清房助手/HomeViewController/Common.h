//
//  Common.h
//  清房助手
//
//  Created by Larry on 15/10/26.
//  Copyright © 2015年 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#ifndef Common_h
#define Common_h

//typedef NS_ENUM(NSInteger, CellStatus) {
//    SalesOut = 0,   //出售
//    RentOut = 1,    //出租
//    WantBuy = 2,   //求购
//    WantRent = 3  //求租
//};


/**
 *  房屋类型
 */
typedef NS_ENUM(NSInteger,BuildingType) {
    /**
     *  住宅
     */
    FlatType      =0,
    
    /**
     *  商铺
     */
    ShangPuType   =1,
    
    /**
     *  办公室
     */
    
    OfficeType    =2,
    
    /**
     *  工厂
     */
    FactoryType   =3
};

#endif /* Common_h */
