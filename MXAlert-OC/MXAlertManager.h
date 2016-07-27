//
//  MXAlertManager.h
//  MXAlertView-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MXAlertOperation.h"

@interface MXAlertManager : NSObject
+ (instancetype _Nonnull)defaultManager;
- (void)addAlert:(MXAlertOperation * _Nullable)alert;
- (MXAlertOperation * _Nullable)currentAlert;
- (void)cancelAllAlert;
@end
