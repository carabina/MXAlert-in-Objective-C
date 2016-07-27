//
//  UIColor+MXAlertColor.m
//  MXAlertView-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "UIColor+MXAlertColor.h"

@implementation UIColor (MXAlertColor)
//+ (UIColor *)fuegoColor {
//    return [UIColor colorWithRed:0.69 green:0.84 blue:0.20 alpha:1.00];
+ (UIColor *)positiveColor {
    return [UIColor colorWithRed:0.87 green:0.29 blue:0.22 alpha:1.00];
}

//+ (UIColor *)valenciaColor {
+ (UIColor *)negativeColor {
    return [UIColor colorWithRed:0.87 green:0.29 blue:0.22 alpha:1.00];
}

+ (UIColor *)inputColor {
    // SeashellColor
    return [UIColor colorWithRed:0.99 green:0.96 blue:0.93 alpha:1.00];
}
@end
