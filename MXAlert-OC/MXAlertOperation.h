//
//  MXAlertOperation.h
//  MXAlertView-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MXAlertView.h"

@class MXAlertOperation;
typedef void (^MXAlertViewActionBlock) (MXAlertOperation * _Nonnull alertView, NSString * _Nonnull inputString);

@interface MXAlertOperation : NSOperation
@property (nonatomic, copy, readonly) NSString * _Nullable titleString;
@property (nonatomic, copy, readonly) NSString * _Nullable subtitleString;
@property (nonatomic, copy, readonly) NSString * _Nullable messageString;
@property (nonatomic, copy, readonly) NSString * _Nullable inputString;
@property (nonatomic, copy, readonly) NSString * _Nullable positiveButtonTitleString;
@property (nonatomic, copy, readonly) NSString * _Nullable negativeButtonTitleString;
@property (nonatomic, strong) MXAlertView * _Nonnull alertView;
@property (nonatomic, assign, readonly) MXAlertType type;

/**
 *  Build an Instance of MXAlertView
 *
 *  @param type MXAlertType Value
 *
 *  @return An MXAlertView Instance
 */
+ (instancetype _Nonnull)buildWithType:(MXAlertType)type;
/**
 *  Set MXAlertView Title
 *
 *  @param title Title String
 *
 *  @return The MXAlertView Instance
 */
- (instancetype _Nonnull)setTitle:(NSString * _Nullable)title;
/**
 *  Set MXAlertView Subtitle, Only Valid with MXAlertTypeAbout
 *
 *  @param subtitle Subtitle String
 *
 *  @return The MXAlertView Instance
 */
- (instancetype _Nonnull)setSubtitle:(NSString * _Nullable)subtitle;
/**
 *  Set MXAlertView Message Boay
 *
 *  @param format Formatted Message String
 *
 *  @return The MXAlertView Instance
 */
- (instancetype _Nonnull)setMessage:(NSString * _Nullable)format, ...;
/**
 *  Set MXAlertView Positive Button Title and Click Action
 *
 *  @param buttonTitle     Button Title
 *  @param onClickListener Click Action
 *
 *  @return The MXAlertView Instance
 */
- (instancetype _Nonnull)setPositiveButton:(NSString * _Nonnull)buttonTitle onClickListener:(MXAlertViewActionBlock _Nullable)onClickListener;
/**
 *  Set MXAlertView Positive Button Title and Click Action
 *
 *  @param buttonTitle     Button Title
 *  @param onClickListener Click Action
 *
 *  @return The MXAlertView Instance
 */
- (instancetype _Nonnull)setNegativeButton:(NSString * _Nonnull)buttonTitle onClickListener:(MXAlertViewActionBlock _Nullable)onClickListener;
/**
 *  Set MXAlert Icon Image
 *
 *  @param icon UIImage Object
 *
 *  @return The MXAlert Instance
 */
- (instancetype _Nonnull)setIcon:(UIImage * _Nullable)icon;
/**
 *  Set MXAlert Icon Image, Used by MXAlertTypeAbout & MXAlertTypeDetail
 *
 *  @param iconURL NSURL Object
 *  @param placeholder UIImage Object
 *
 *  @return The MXAlert Instance
 */
- (instancetype _Nonnull)setIconWithURL:(NSURL * _Nullable)iconURL placeholder:(UIImage * _Nullable)placeholder;
/**
 *  Set MXAlert Detail Image, Used by MXAlertTypeImage & MXAlertTypeDetail
 *
 *  @param detail UIImage Object
 *
 *  @return The MXAlert Instance
 */
- (instancetype _Nonnull)setDetailImage:(UIImage * _Nullable)detail;
/**
 *  Set MXAlert Detail Image, Used by MXAlertTypeImage & MXAlertTypeDetail
 *
 *  @param detailURL NSURL Object
 *  @param placeholder UIImage Object
 *
 *  @return The MXAlert Instance
 */
- (instancetype _Nonnull)setDetailImageWithURL:(NSURL * _Nullable)detailURL placeholder:(UIImage * _Nullable)placeholder;
/**
 *  Set MXAlert Added Points Count
 *
 *  @param points Points Count
 *
 *  @return The MXAlert Instance
 */
- (instancetype _Nonnull)setAddedPoints:(NSUInteger)points;
/**
 *  Set MXAlert Total Points Count
 *
 *  @param points Points Count
 *
 *  @return The MXAlert Instance
 */
- (instancetype _Nonnull)setTotalPoints:(NSUInteger)points;
/**
 *  Show MXAlertView
 */
- (void)show;
/**
 *  Hide MXAlertView
 */
- (void)hide;
@end
