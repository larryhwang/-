//
//  ZuGouDetailViewController.h
//  清房助手
//
//  Created by Larry on 12/21/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZuGouDetailViewController : UIViewController


@property(nonatomic,copy) NSString *fenlei;
@property(nonatomic,copy) NSString *keYuanID;

/**
 *  用于判读是否是内部XX，如果是则要显示查看信息按钮
 */
@property(nonatomic,assign) BOOL  isInner;

@end
