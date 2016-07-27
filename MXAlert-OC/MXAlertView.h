//
//  MXAlertViewView.h
//  MXAlertView-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXAlertShadowView.h"

typedef enum : NSUInteger {
    MXAlertTypeAbout = 0, // 关于框
    MXAlertTypeInfo = 1, // 信息框
    MXAlertTypeInquire = 2, // 询问框
    MXAlertTypeInput = 3, // 输入框
    MXAlertTypeLoading = 4, // 载入框
    MXAlertTypePoints = 5, // 积分框
    MXAlertTypeImage = 6, // 图片框
    MXAlertTypeDetail = 7, // 详情
} MXAlertType;

@class MXAlertView;

@interface MXAlertView : MXAlertShadowView
/**
 *  Image View
 */
@property (nonatomic, strong) UIImageView * _Nonnull imageView;
/**
 *  QRCode Image View
 */
@property (nonatomic, strong) UIImageView * _Nonnull detailImageView;
/**
 *  Title Label
 */
@property (nonatomic, strong) UILabel * _Nonnull titleLabel;
/**
 *  Subtitle Label
 */
@property (nonatomic, strong) UILabel * _Nonnull subtitleLabel;
/**
 *  Message Label
 */
@property (nonatomic, strong) UILabel * _Nonnull messageLabel;
/**
 *  Text Input View
 */
@property (nonatomic, strong) UITextView * _Nonnull inputView;
/**
 *  Right Button
 */
@property (nonatomic, strong) UIButton * _Nonnull positiveButton;
/**
 *  Left Button
 */
@property (nonatomic, strong) UIButton * _Nonnull negativeButton;
/**
 *  Only Valid with MXAlertPoints
 */
@property (nonatomic, strong) UIButton * _Nonnull pointsButton;
/**
 *  Added Points Label
 */
@property (nonatomic, strong) UILabel * _Nonnull addedPointsLabel;
/**
 *  Total Points Label
 */
@property (nonatomic, strong) UILabel * _Nonnull totalPointsLabel;
/**
 *  Alert Type
 */
@property (nonatomic, assign) MXAlertType type;
@property (nonatomic, assign) BOOL hasDetailPositiveButton;
@property (nonatomic, assign) BOOL hasDetailImage;
/**
 *  Update Frames
 */
- (void)updateView;
@end
