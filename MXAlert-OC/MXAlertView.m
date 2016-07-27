//
//  MXAlertViewView.m
//  MXAlertView-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "MXAlertView.h"
#import "MXAlertWindow.h"
#import "UIColor+MXAlertColor.h"

const CGFloat kMXAlertViewButtonLength = 60.000;
const CGFloat kMXConstraintMargin = 8.000;
const CGFloat kMXMargin = 15.000;
const CGFloat kMXMaxInformationHeight = CGFLOAT_MAX;

@interface MXAlertView () {
    UITextView *_inputView;
}
@property (nonatomic, assign) UIEdgeInsets textInsets;
@property (nonatomic, strong) UIFont * _Nonnull font;
@property (nonatomic, strong) UIView * _Nonnull pointTopView;
@property (nonatomic, strong) UIView * _Nonnull pointBottomView;
@property (nonatomic, strong) UIView * _Nonnull pointViewContainer;
@property (nonatomic, strong) UIActivityIndicatorView * _Nonnull loadingIndicator;
@property (nonatomic, strong) UIView * _Nonnull backgroundView;
@end

@implementation MXAlertView

/*- (void)clipBottomWithButton:(UIButton *)button {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat offset = 10;
    CGFloat bottom = CGRectGetMaxY([button frame]) - [button frame].size.height * 0.5000;
    CGPathMoveToPoint(path, NULL, 0 - offset, 0 - offset); // 左上角
    CGPathAddLineToPoint(path, NULL, [self frame].size.width + offset, 0 - offset);// 右上角
    CGPathAddLineToPoint(path, NULL, [self frame].size.width + offset, bottom - self.layer.cornerRadius); // 右下角
    CGPathAddArc(path, NULL, [self frame].size.width - self.layer.cornerRadius, bottom - self.layer.cornerRadius, self.layer.cornerRadius, 0, 0.500 * (M_PI), NO); // 右下角圆角
    CGPathAddLineToPoint(path, NULL, [self frame].size.width - 0.500 * ([self frame].size.width - kMXAlertViewButtonLength), bottom); // 右下角到底部按钮右边
    CGPathAddArc(path, NULL, 0.500 * ([self frame].size.width), bottom, 0.500 * (kMXAlertViewButtonLength), 0, M_PI, NO); // 底部按钮下半部分
    CGPathAddLineToPoint(path, NULL, self.layer.cornerRadius, bottom); // 底部按钮左边到左下角圆角
    CGPathAddArc(path, NULL, self.layer.cornerRadius, bottom - self.layer.cornerRadius, self.layer.cornerRadius, 0.500 * (M_PI), M_PI, NO); // 左下角圆角
    CGPathAddLineToPoint(path, NULL, 0 - offset, 0 - offset); // 回到左上角
    
    CGPathCloseSubpath(path);
    [shapeLayer setPath:path];
    
    self.layer.mask = shapeLayer;
    
    CFRelease(path);
}*/

- (void)dealloc {
    if ([self type] == MXAlertTypeInput) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    }
}

- (void)setType:(MXAlertType)type {
    _type = type;
    if ([self type] == MXAlertTypeInput) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
}

#pragma mark - 键盘监视
// 将要显示
- (void)keyboardWillShow:(NSNotification *)note {
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = [weakSelf frame];
        frame.origin.y = 20;
        [weakSelf setFrame:frame];
    }];
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 100, 100)];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, 100, 100)];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    [self setFont:[UIFont systemFontOfSize:13]];
    CGSize containerSize = [[MXAlertWindow defaultWindow] frame].size;
    [self setBackgroundColor:[UIColor clearColor]];
    [self setClipsToBounds:YES];
    CGFloat width = containerSize.width - kMXMargin * 2;
    [self setFrame:CGRectMake((containerSize.width - width) * 0.5000, 0, width, width)];
    
    [self setBackgroundView:[[MXAlertShadowView alloc] initWithFrame:[self bounds]]];
    [[self backgroundView] setBackgroundColor:[UIColor whiteColor]];
    [[self backgroundView] setClipsToBounds:YES];
    [[[self backgroundView] layer] setCornerRadius:3];
    [self addSubview:[self backgroundView]];
    
    [self setPointViewContainer:[[UIView alloc] initWithFrame:[self bounds]]];
    [[self pointViewContainer] setClipsToBounds:YES];
    [[self pointViewContainer] setBackgroundColor:[UIColor clearColor]];
    [self addSubview:[self pointViewContainer]];
    
    [self setPointTopView:[[UIView alloc] initWithFrame:[self bounds]]];
    [[self pointTopView] setBackgroundColor:[UIColor whiteColor]];
    [[self pointViewContainer] addSubview:[self pointTopView]];
    
    [self setPointBottomView:[[UIView alloc] initWithFrame:[self bounds]]];
    [[self pointBottomView] setBackgroundColor:[UIColor positiveColor]];
    [[self pointViewContainer] addSubview:[self pointBottomView]];
    
    [self setAddedPointsLabel:[[UILabel alloc] initWithFrame:[self bounds]]];
    [[self addedPointsLabel] setTextColor:[UIColor blackColor]];
    [[self addedPointsLabel] setFont:[UIFont boldSystemFontOfSize:65]];
    [[self addedPointsLabel] setBackgroundColor:[UIColor clearColor]];
    [[self addedPointsLabel] setNumberOfLines:1];
    [[self addedPointsLabel] setText:@"0"];
    [[self addedPointsLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self addedPointsLabel] setClipsToBounds:YES];
    [[self pointViewContainer] addSubview:[self addedPointsLabel]];
    
    [self setTotalPointsLabel:[[UILabel alloc] initWithFrame:[self bounds]]];
    [[self totalPointsLabel] setTextColor:[UIColor whiteColor]];
    [[self totalPointsLabel] setFont:[UIFont boldSystemFontOfSize:20]];
    [[self totalPointsLabel] setBackgroundColor:[UIColor clearColor]];
    [[self totalPointsLabel] setNumberOfLines:1];
    [[self totalPointsLabel] setText:@"0"];
    [[self totalPointsLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self totalPointsLabel] setClipsToBounds:YES];
    [[self pointViewContainer] addSubview:[self totalPointsLabel]];
    
    [self setPointsButton:[[UIButton alloc] initWithFrame:[self bounds]]];
    [[self pointViewContainer] addSubview:[self pointsButton]];
    
    [self setImageView:[[UIImageView alloc] initWithFrame:[self bounds]]];
    [[self imageView] setBackgroundColor:[UIColor whiteColor]];
    [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
    [[self imageView] setClipsToBounds:YES];
    [self addSubview:[self imageView]];
    
    [self setDetailImageView:[[UIImageView alloc] initWithFrame:[self bounds]]];
    [[self detailImageView] setBackgroundColor:[UIColor whiteColor]];
    [[self detailImageView] setContentMode:UIViewContentModeScaleAspectFill];
    [[self detailImageView] setClipsToBounds:YES];
    [self addSubview:[self detailImageView]];
    
    [self setTitleLabel:[[UILabel alloc] initWithFrame:[self bounds]]];
    [[self titleLabel] setTextColor:[UIColor blackColor]];
    [[self titleLabel] setFont:[UIFont boldSystemFontOfSize:17]];
    [[self titleLabel] setBackgroundColor:[UIColor clearColor]];
    [[self titleLabel] setNumberOfLines:0];
    [[self titleLabel] setText:@"Title"];
    [[self titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self titleLabel] setLineBreakMode:NSLineBreakByCharWrapping];
    [[self titleLabel] setClipsToBounds:YES];
    [self addSubview:[self titleLabel]];
    
    [self setSubtitleLabel:[[UILabel alloc] initWithFrame:[self bounds]]];
    [[self subtitleLabel] setTextColor:[UIColor lightGrayColor]];
    [[self subtitleLabel] setFont:[UIFont systemFontOfSize:13]];
    [[self subtitleLabel] setBackgroundColor:[UIColor clearColor]];
    [[self subtitleLabel] setNumberOfLines:0];
    [[self subtitleLabel] setText:@"Subtitle"];
    [[self subtitleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self subtitleLabel] setLineBreakMode:NSLineBreakByCharWrapping];
    [[self subtitleLabel] setClipsToBounds:YES];
    [self addSubview:[self subtitleLabel]];
    
    [self setMessageLabel:[[UILabel alloc] initWithFrame:[self bounds]]];
    [[self messageLabel] setTextColor:[UIColor blackColor]];
    [[self messageLabel] setFont:[self font]];
    [[self messageLabel] setBackgroundColor:[UIColor clearColor]];
    [[self messageLabel] setNumberOfLines:0];
    [[self messageLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self messageLabel] setClipsToBounds:YES];
    [[self messageLabel] setLineBreakMode:NSLineBreakByCharWrapping];
    [self addSubview:[self messageLabel]];
    
    [self setInputView:[[UITextView alloc] initWithFrame:[self bounds]]];
    [[self inputView] setBackgroundColor:[UIColor inputColor]];
    [[self inputView] setTextColor:[UIColor blackColor]];
    [[self inputView] setFont:[self font]];
    [self addSubview:[self inputView]];
    
    CGFloat cornerRadius = kMXAlertViewButtonLength * 0.5000;
    
    [self setPositiveButton:[[UIButton alloc] initWithFrame:[self bounds]]];
    [[[self positiveButton] titleLabel] setNumberOfLines:0];
    [[self positiveButton] setTitle:@"OK" forState:UIControlStateNormal];
    [[self positiveButton] setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [[[self positiveButton] titleLabel] setFont:[self font]];
    [[self positiveButton] setClipsToBounds:YES];
    [[[self positiveButton] layer] setCornerRadius:cornerRadius];
    [[self positiveButton] setBackgroundColor:[UIColor positiveColor]];
    [self addSubview:[self positiveButton]];
    
    [self setNegativeButton:[[UIButton alloc] initWithFrame:[self bounds]]];
    [[[self negativeButton] titleLabel] setNumberOfLines:0];
    [[self negativeButton] setTitle:@"Cancel" forState:UIControlStateNormal];
    [[self negativeButton] setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [[[self negativeButton] titleLabel] setFont:[self font]];
    [[self negativeButton] setClipsToBounds:YES];
    [[[self negativeButton] layer] setCornerRadius:cornerRadius];
    [[self negativeButton] setBackgroundColor:[UIColor negativeColor]];
    [self addSubview:[self negativeButton]];
    
    [self setLoadingIndicator:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
    [[self loadingIndicator] setHidesWhenStopped:NO];
    [self addSubview:[self loadingIndicator]];
    
    [self setTextInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    for (UIView *view in [self subviews]) {
        [view setHidden:YES];
    }
//    [[self backgroundView] setHidden:YES];
//    [[self imageView] setHidden:YES];
//    [[self QRCodeView] setHidden:YES];
//    [[self titleLabel] setHidden:YES];
//    [[self messageLabel] setHidden:YES];
//    [[self positiveButton] setHidden:YES];
//    [[self subtitleLabel] setHidden:YES];
//    [[self negativeButton] setHidden:YES];
//    [[self inputView] setHidden:YES];
//    [[self pointViewContainer] setHidden:YES];
//    [[self loadingIndicator] setHidden:YES];
}

- (void)updateView {
    
    CGSize containerSize = [[MXAlertWindow defaultWindow] frame].size;
    CGSize constraintSize = CGSizeMake(containerSize.width * (280.0 / 320.0), CGFLOAT_MAX);
    CGSize buttonSize = CGSizeMake(kMXAlertViewButtonLength, kMXAlertViewButtonLength);
    CGFloat backgroundWidth = 250.000;
//    CGFloat backgroundWidth = containerSize.width * 0.8;
//    CGFloat backgroundWidth = containerSize.width - [self textInsets].left - [self textInsets].right;
    CGSize labelFitsSize = CGSizeMake(backgroundWidth - [self textInsets].left - [self textInsets].right, constraintSize.height);
    CGFloat margin = kMXConstraintMargin;
    CGFloat buttonTopMargin = kMXMargin;
    CGFloat imageLength = 80.000;
    
    switch ([self type]) {
        case MXAlertTypeInfo: {
            CGSize messageSize = [[self messageLabel] sizeThatFits:labelFitsSize];
            
            [[self messageLabel] setFrame:CGRectMake([self textInsets].left,
                                                     [self textInsets].top,
                                                     backgroundWidth - [self textInsets].left - [self textInsets].right,
                                                     messageSize.height)];
            
            [[self positiveButton] setFrame:CGRectMake((backgroundWidth - buttonSize.width) * 0.5000,
                                                       CGRectGetMaxY([[self messageLabel] frame]) + buttonTopMargin,
                                                       buttonSize.width,
                                                       buttonSize.height)];
            
            CGFloat backgroundHeight = CGRectGetMaxY([[self positiveButton] frame]) + kMXMargin;
            
            [[self backgroundView] setFrame:CGRectMake(0, 0,
                                                       backgroundWidth,
                                                       backgroundHeight)];
            
            [[self imageView] setHidden:YES];
            [[self messageLabel] setHidden:NO];
            [[self positiveButton] setHidden:NO];
        }
            break;
        case MXAlertTypeAbout: {
            CGSize logoSize = CGSizeMake(imageLength, imageLength);
            
            [[self imageView] setFrame:CGRectMake((backgroundWidth - logoSize.width) * 0.5000,
                                                      [self textInsets].top,
                                                      logoSize.width,
                                                      logoSize.height)];
            
            [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
            
            CGSize titleSize = [[self titleLabel] sizeThatFits:labelFitsSize];
            
            CGSize subtitleSize = [[self subtitleLabel] sizeThatFits:labelFitsSize];
            
            CGSize messageSize = [[self messageLabel] sizeThatFits:labelFitsSize];
            
            [[self titleLabel] setFrame:CGRectMake([self textInsets].left,
                                                     CGRectGetMaxY([[self imageView] frame]) + margin,
                                                     labelFitsSize.width,
                                                     titleSize.height)];
            
            [[self subtitleLabel] setFrame:CGRectMake([self textInsets].left,
                                                     CGRectGetMaxY([[self titleLabel] frame]) + margin,
                                                     labelFitsSize.width,
                                                     subtitleSize.height)];
            
            [[self messageLabel] setFrame:CGRectMake([self textInsets].left,
                                                     CGRectGetMaxY([[self subtitleLabel] frame]) + margin,
                                                     messageSize.width,
                                                     messageSize.height)];
            
            [[self positiveButton] setFrame:CGRectMake((backgroundWidth - buttonSize.width) * 0.5000,
                                                       CGRectGetMaxY([[self messageLabel] frame]) + buttonTopMargin,
                                                       buttonSize.width,
                                                       buttonSize.height)];
            
            CGFloat backgroundHeight = CGRectGetMaxY([[self positiveButton] frame]) + kMXMargin;
            
            [[self backgroundView] setFrame:CGRectMake(0, 0,
                                                       backgroundWidth,
                                                       backgroundHeight)];
            
            [[self messageLabel] setTextAlignment:NSTextAlignmentNatural];
            
            [[self imageView] setHidden:NO];
            [[self titleLabel] setHidden:NO];
            [[self messageLabel] setHidden:NO];
            [[self positiveButton] setHidden:NO];
            [[self subtitleLabel] setHidden:NO];
        }
            break;
        case MXAlertTypeInquire: {
            CGSize messageSize = [[self messageLabel] sizeThatFits:CGSizeMake(constraintSize.width - [self textInsets].left, constraintSize.height)];
            CGSize buttonSize = CGSizeMake(kMXAlertViewButtonLength, kMXAlertViewButtonLength);
            
            [[self messageLabel] setFrame:CGRectMake([self textInsets].left,
                                                     [self textInsets].top,
                                                     backgroundWidth - [self textInsets].left - [self textInsets].right,
                                                     messageSize.height)];
            
            CGFloat buttonMargin = 2 * kMXMargin;
            CGFloat leftButtonX = (backgroundWidth - buttonSize.width * 2 - buttonMargin) * 0.5000;
            
            [[self positiveButton] setFrame:CGRectMake(leftButtonX + buttonSize.width + buttonMargin,
                                                       CGRectGetMaxY([[self messageLabel] frame]) + buttonTopMargin,
                                                       buttonSize.width,
                                                       buttonSize.height)];
            
            [[self negativeButton] setFrame:CGRectMake(leftButtonX,
                                                       [[self positiveButton] frame].origin.y,
                                                       buttonSize.width,
                                                       buttonSize.height)];
            
            CGFloat backgroundHeight = CGRectGetMaxY([[self positiveButton] frame]) + kMXMargin;
            
            [[self backgroundView] setFrame:CGRectMake(0, 0,
                                                       backgroundWidth,
                                                       backgroundHeight)];
            
            [[self messageLabel] setHidden:NO];
            [[self positiveButton] setHidden:NO];
            [[self negativeButton] setHidden:NO];
        }
            break;
        case MXAlertTypeInput: {
            CGSize messageSize = [[self messageLabel] sizeThatFits:labelFitsSize];
            CGSize buttonSize = CGSizeMake(kMXAlertViewButtonLength, kMXAlertViewButtonLength);
            
            [[self messageLabel] setFrame:CGRectMake([self textInsets].left,
                                                     [self textInsets].top,
                                                     messageSize.width,
                                                     messageSize.height)];
            
            [[self inputView] setFrame:CGRectMake(0,
                                                 CGRectGetMaxY([[self messageLabel] frame]) + margin,
                                                  backgroundWidth, 130)];
            
            CGFloat buttonMargin = 2 * kMXMargin;
            CGFloat leftButtonX = (backgroundWidth - buttonSize.width * 2 - buttonMargin) * 0.5000;
            
            [[self positiveButton] setFrame:CGRectMake(leftButtonX + buttonSize.width + buttonMargin,
                                                       CGRectGetMaxY([[self inputView] frame]) + buttonTopMargin,
                                                       buttonSize.width,
                                                       buttonSize.height)];
            
            [[self negativeButton] setFrame:CGRectMake(leftButtonX,
                                                       [[self positiveButton] frame].origin.y,
                                                       buttonSize.width,
                                                       buttonSize.height)];
            
            CGFloat backgroundHeight = CGRectGetMaxY([[self positiveButton] frame]) + kMXMargin;
            
            [[self backgroundView] setFrame:CGRectMake(0, 0,
                                                       backgroundWidth,
                                                       backgroundHeight)];
            
            [[self messageLabel] setTextAlignment:NSTextAlignmentLeft];
            
            [[self messageLabel] setHidden:NO];
            [[self positiveButton] setHidden:NO];
            [[self negativeButton] setHidden:NO];
            [[self inputView] setHidden:NO];
        }
            break;
        case MXAlertTypePoints: {
            CGFloat backgroundHeight = backgroundWidth;
            
            [[self backgroundView] setFrame:CGRectMake(0,
                                                       0,
                                                       backgroundWidth,
                                                       backgroundHeight)];
            
            [[[self backgroundView] layer] setCornerRadius:[[self backgroundView] frame].size.height * 0.5000];
            
            [[self pointViewContainer] setFrame:[[self backgroundView] frame]];
            [[[self pointViewContainer] layer] setCornerRadius:[[[self backgroundView] layer] cornerRadius]];
            
            [[self pointTopView] setFrame:CGRectMake(0,
                                                    0,
                                                    [[self pointViewContainer] frame].size.width,
                                                     [[self pointViewContainer] frame].size.height * 0.65000)];
            
            [[self pointBottomView] setFrame:CGRectMake(0,
                                                     CGRectGetMaxY([[self pointTopView] frame]),
                                                     [[self pointViewContainer] frame].size.width,
                                                     [[self pointViewContainer] frame].size.height - [[self pointTopView] frame].size.height)];
            
            CGSize addedSize = [[self addedPointsLabel] sizeThatFits:[[self pointTopView] bounds].size];
            CGSize titleSize = [[self titleLabel] sizeThatFits:[[self pointTopView] bounds].size];
            
            CGFloat titleY = 0.5000 * ([[self pointTopView] frame].size.height - addedSize.height - titleSize.height - kMXConstraintMargin);
            
            [[self titleLabel] setFrame:CGRectMake(0,
                                                   titleY,
                                                   [[self pointTopView] frame].size.width,
                                                   titleSize.height)];
            
            [[self addedPointsLabel] setFrame:CGRectMake(0,
                                                        CGRectGetMaxY([[self titleLabel] frame]) + kMXConstraintMargin,
                                                        [[self pointTopView] frame].size.width,
                                                         addedSize.height)];
            
            CGSize totalSize = [[self totalPointsLabel] sizeThatFits:[[self pointBottomView] bounds].size];
            CGSize messageSize = [[self messageLabel] sizeThatFits:[[self pointBottomView] bounds].size];
            CGFloat messageY = 0.5000 * ([[self pointBottomView] frame].size.height - totalSize.height - messageSize.height - kMXConstraintMargin) + [[self pointTopView] frame].size.height;
            
            [[self messageLabel] setFrame:CGRectMake(0,
                                                     messageY,
                                                     [[self pointBottomView] frame].size.width,
                                                     messageSize.height)];
            
            [[self totalPointsLabel] setFrame:CGRectMake(0,
                                                         CGRectGetMaxY([[self messageLabel] frame]) + kMXConstraintMargin,
                                                         [[self pointBottomView] frame].size.width,
                                                         totalSize.height)];
            [[self pointsButton] setFrame:[[self pointViewContainer] bounds]];
            
            [[self titleLabel] setText:@"新增积分共"];
            [[self messageLabel] setText:@"全部积分共"];
            [[self messageLabel] setTextColor:[UIColor whiteColor]];
            
            [[self titleLabel] setHidden:NO];
            [[self messageLabel] setHidden:NO];
            [[self pointViewContainer] setHidden:NO];
        }
            break;
        case MXAlertTypeImage: {
            CGFloat backgroundHeight = 0;
            if ([self hasDetailImage]) {
                CGSize imageSize = [[self imageView] image].size;
                if (imageSize.width > backgroundWidth) {
                    backgroundHeight = imageSize.height / (imageSize.width / backgroundWidth);
                } else {
                    backgroundWidth = imageSize.width;
                    backgroundHeight = imageSize.height;
                }
            } else {
                backgroundHeight = 100;
            }
            
            [[self detailImageView] setFrame:CGRectMake(0,
                                                  0,
                                                  backgroundWidth,
                                                  backgroundHeight)];
            
            [[self positiveButton] setFrame:CGRectMake((backgroundWidth - buttonSize.width) * 0.5000,
                                                       CGRectGetMaxY([[self detailImageView] frame]) + buttonTopMargin,
                                                       buttonSize.width,
                                                       buttonSize.height)];
            
            [[self backgroundView] setFrame:CGRectMake(0, 0,
                                                       backgroundWidth,
                                                       CGRectGetMaxY([[self positiveButton] frame]) + kMXMargin)];
            
            [[self detailImageView] setContentMode:UIViewContentModeScaleAspectFit];
            
            [[self positiveButton] setHidden:NO];
            [[self detailImageView] setHidden:NO];
        }
            break;
        case MXAlertTypeLoading: {
            CGFloat backgroundHeight = 100;
            
            [[self backgroundView] setFrame:CGRectMake(0, 0,
                                                       backgroundWidth,
                                                       backgroundHeight)];
            
            [[self loadingIndicator] setCenter:[[self backgroundView] center]];
            [[self loadingIndicator] startAnimating];
            
            [[self loadingIndicator] setHidden:NO];
            
        }
            break;
        case MXAlertTypeDetail: {
            CGFloat backgroundHeight = 0;
            
            [[self imageView] setFrame:CGRectMake([self textInsets].left,
                                                 [self textInsets].top,
                                                 imageLength,
                                                  imageLength)];
            
            [[self titleLabel] setFrame:CGRectMake(CGRectGetMaxX([[self imageView] frame]) + margin,
                                                  [[self imageView] frame].origin.y,
                                                  backgroundWidth - CGRectGetMaxX([[self imageView] frame]) - [self textInsets].right,
                                                   18)];
            
            [[self subtitleLabel] setFrame:CGRectMake([[self titleLabel] frame].origin.x,
                                                      CGRectGetMaxY([[self imageView] frame]) - [[self titleLabel] frame].size.height,
                                                      [[self titleLabel] frame].size.width,
                                                      [[self titleLabel] frame].size.height)];
            
            CGFloat messageMaxHeight = [[self imageView] frame].size.height - margin - [[self titleLabel] frame].size.height * 2;
            CGSize messageSize = [[self messageLabel] sizeThatFits:CGSizeMake([[self titleLabel] frame].size.width, messageMaxHeight)];
            if (messageSize.height > messageMaxHeight) {
                messageSize.height = messageMaxHeight;
            }
            
            [[self messageLabel] setFrame:CGRectMake([[self titleLabel] frame].origin.x,
                                                      CGRectGetMaxY([[self titleLabel] frame]) + margin,
                                                      [[self titleLabel] frame].size.width,
                                                      messageSize.height)];
            
            CGFloat QRLength = 100;
            
            [[self detailImageView] setFrame:CGRectMake((backgroundWidth - QRLength) * 0.5,
                                                  CGRectGetMaxY([[self subtitleLabel] frame]) + margin,
                                                  QRLength,
                                                   (![self hasDetailImage] ? 0 : QRLength))];
            if ([self hasDetailPositiveButton]) {
                CGFloat buttonMargin = 2 * kMXMargin;
                CGFloat leftButtonX = (backgroundWidth - buttonSize.width * 2 - buttonMargin) * 0.5000;
                
                [[self positiveButton] setFrame:CGRectMake(leftButtonX + buttonSize.width + buttonMargin,
                                                           CGRectGetMaxY([[self detailImageView] frame]) + buttonTopMargin,
                                                           buttonSize.width,
                                                           buttonSize.height)];
                
                [[self negativeButton] setFrame:CGRectMake(leftButtonX,
                                                           [[self positiveButton] frame].origin.y,
                                                           buttonSize.width,
                                                           buttonSize.height)];
                
            } else {
                [[self negativeButton] setFrame:CGRectMake((backgroundWidth - buttonSize.width) * 0.5000,
                                                           CGRectGetMaxY([[self detailImageView] frame]) + buttonTopMargin,
                                                           buttonSize.width,
                                                           buttonSize.height)];
            }
            
            backgroundHeight = CGRectGetMaxY([[self negativeButton] frame]) + kMXMargin;
            
            [[self backgroundView] setFrame:CGRectMake(0, 0,
                                                       backgroundWidth,
                                                       backgroundHeight)];
            
            [[self titleLabel] setTextAlignment:NSTextAlignmentLeft];
            [[self subtitleLabel] setTextAlignment:NSTextAlignmentLeft];
            [[self messageLabel] setTextAlignment:NSTextAlignmentLeft];
            
            [[self titleLabel] setHidden:NO];
            [[self subtitleLabel] setHidden:NO];
            [[self messageLabel] setHidden:NO];
            [[self imageView] setHidden:NO];
            [[self detailImageView] setHidden:![self hasDetailImage]];
            [[self positiveButton] setHidden:![self hasDetailPositiveButton]];
            [[self negativeButton] setHidden:NO];
        }
            break;
            
        default: {
            CGFloat backgroundHeight = 100;
            
            [[self positiveButton] setFrame:CGRectMake((backgroundWidth - buttonSize.width) * 0.5000,
                                                       (backgroundHeight - buttonSize.height) * 0.5000,
                                                       buttonSize.width,
                                                       buttonSize.height)];
            
            [[self backgroundView] setFrame:CGRectMake(0, 0,
                                                       backgroundWidth,
                                                       backgroundHeight)];
            
            [[self positiveButton] setHidden:NO];
        }
            break;
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown ||
        ![[MXAlertWindow defaultWindow] shouldRotateManually]) {
        width = containerSize.width;
        height = containerSize.height;
    } else {
        width = containerSize.height;
        height = containerSize.width;
    }
    
    CGSize backgroundViewSize = [[self backgroundView] frame].size;
    x = (width - backgroundViewSize.width) * 0.5;
    y = (height - backgroundViewSize.height) * 0.5;
    [self setFrame:CGRectMake(x, y, backgroundViewSize.width, backgroundViewSize.height)];
    [[self layer] setCornerRadius:[[[self backgroundView] layer] cornerRadius]];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if ([self superview] != nil) {
//        CGPoint pointInWindow = [self convertPoint:point toView:[self superview]];
//        BOOL contains = CGRectContainsPoint([self frame], pointInWindow);
//        if (contains && [self isUserInteractionEnabled]) {
//            return self;
//        }
//    }
//    return nil;
//}

@end
