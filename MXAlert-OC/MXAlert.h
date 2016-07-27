//
//  MXAlert.h
//  MXAlertView-OC-Demo
//
//  Created by Meniny on 16/7/27.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "MXAlertOperation.h"

@interface MXAlert : MXAlertOperation
+ (instancetype _Nonnull)infoAlert;
+ (instancetype _Nonnull)aboutAlert;
+ (instancetype _Nonnull)inquireAlert;
+ (instancetype _Nonnull)inputAlert;
+ (instancetype _Nonnull)loadingAlert;
+ (instancetype _Nonnull)pointsAlert;
+ (instancetype _Nonnull)imageAlert;
+ (instancetype _Nonnull)detailAlert;
@end
