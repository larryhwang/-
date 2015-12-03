//
//  FlatDescirbeVcontroller.h
//  用scollview做表格
//
//  Created by Larry on 11/30/15.
//  Copyright © 2015 Larry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChangeUI) (NSString *content);

@interface FlatDescirbeVcontroller : UIViewController
@property (weak, nonatomic) IBOutlet UITextView  *ContentText;
@property (weak, nonatomic) IBOutlet UIButton    *SaveAndBackBtn;
@property(nonatomic,weak)   NSMutableDictionary  *HandleNSDic;
@property(nonatomic,copy) ChangeUI UIUpdate;

@end
