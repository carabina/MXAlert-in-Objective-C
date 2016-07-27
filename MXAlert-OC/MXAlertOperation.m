//
//  MXAlertView.m
//  MXAlertView-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "MXAlertOperation.h"
#import "MXAlertManager.h"
#import "MXAlertWindow.h"
#import "UIImageView+WebCache.h"

@interface MXAlertOperation () {
    BOOL _executing;
    BOOL _finished;
}

@property (nonatomic, copy) MXAlertViewActionBlock _Nullable clickPositiveButtonListener;
@property (nonatomic, copy) MXAlertViewActionBlock _Nullable clickNegativeButtonListener;
@end

@implementation MXAlertOperation

+ (instancetype _Nonnull)buildWithType:(MXAlertType)type {
    MXAlertOperation *alert = [MXAlertOperation new];
    [[alert alertView] setType:type];
    [alert setClickPositiveButtonListener:^(MXAlertOperation * _Nonnull alertView, NSString * _Nonnull inputString) {
        [alertView hide];
    }];
    [alert setClickNegativeButtonListener:^(MXAlertOperation * _Nonnull alertView, NSString * _Nonnull inputString) {
        [alertView hide];
    }];
    [[[alert alertView] positiveButton] addTarget:alert action:@selector(positiveAction) forControlEvents:UIControlEventTouchUpInside];
    [[[alert alertView] negativeButton] addTarget:alert action:@selector(negativeAction) forControlEvents:UIControlEventTouchUpInside];
    [[[alert alertView] pointsButton] addTarget:alert action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    return alert;
}

- (instancetype _Nonnull)setTitle:(NSString * _Nullable)title {
    NSString *_titleString;
    if (title != nil) {
        _titleString = [title copy];
    } else {
        _titleString = NSLocalizedString(@"AlertView", nil);
    }
    [[[self alertView] titleLabel] setText:_titleString];
    return self;
}

- (instancetype _Nonnull)setSubtitle:(NSString * _Nullable)subtitle {
    NSString *_subtitleString;
    if (subtitle != nil) {
        _subtitleString = [subtitle copy];
    } else {
        _subtitleString = NSLocalizedString(@"AlertView", nil);
    }
    [[[self alertView] subtitleLabel] setText:_subtitleString];
    return self;
}

- (instancetype _Nonnull)setMessage:(NSString * _Nullable)format, ... {
    NSString *_messageString;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        _messageString = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    } else {
        _messageString = NSLocalizedString(@"This is a alertView", nil);
    }
    [[[self alertView] messageLabel] setText:_messageString];
    return self;
}

- (instancetype _Nonnull)setPositiveButton:(NSString * _Nonnull)buttonTitle onClickListener:(MXAlertViewActionBlock _Nullable)onClickListener {
    NSString *_positiveButtonTitleString;
    if (buttonTitle != nil) {
        _positiveButtonTitleString = [buttonTitle copy];
    } else {
        _positiveButtonTitleString = NSLocalizedString(@"OK", nil);
    }
    [[self alertView] setHasDetailPositiveButton:YES];
    [[[self alertView] positiveButton] setTitle:_positiveButtonTitleString forState:UIControlStateNormal];
    [self setClickPositiveButtonListener:onClickListener];
    return self;
}

- (instancetype _Nonnull)setNegativeButton:(NSString * _Nonnull)buttonTitle onClickListener:(MXAlertViewActionBlock _Nullable)onClickListener {
    NSString *_negativeButtonTitleString;
    if (buttonTitle != nil) {
        _negativeButtonTitleString = [buttonTitle copy];
    } else {
        _negativeButtonTitleString = NSLocalizedString(@"Cancel", nil);
    }
    [[[self alertView] negativeButton] setTitle:_negativeButtonTitleString forState:UIControlStateNormal];
    [self setClickNegativeButtonListener:onClickListener];
    
    return self;
}

- (instancetype _Nonnull)setIcon:(UIImage * _Nullable)icon {
    [[[self alertView] imageView] setImage:icon];
    return self;
}

- (instancetype _Nonnull)setIconWithURL:(NSURL * _Nullable)iconURL placeholder:(UIImage * _Nullable)placeholder {
    [[[self alertView] imageView] sd_setImageWithURL:iconURL placeholderImage:placeholder];
    return self;
}

- (instancetype _Nonnull)setDetailImage:(UIImage * _Nullable)detail {
    [[self alertView] setHasDetailImage:(detail != nil)];
    [[[self alertView] detailImageView] setImage:detail];
    return self;
}

- (instancetype _Nonnull)setDetailImageWithURL:(NSURL * _Nullable)detailURL placeholder:(UIImage * _Nullable)placeholder {
    [[self alertView] setHasDetailImage:(detailURL != nil)];
    [[[self alertView] detailImageView] sd_setImageWithURL:detailURL placeholderImage:placeholder];
    return self;
}

- (instancetype _Nonnull)setAddedPoints:(NSUInteger)points {
    [[[self alertView] addedPointsLabel] setText:[NSString stringWithFormat:@"%zd", points]];
    return self;
}

- (instancetype _Nonnull)setTotalPoints:(NSUInteger)points {
    [[[self alertView] totalPointsLabel] setText:[NSString stringWithFormat:@"%zd", points]];
    return self;
}

#pragma mark - Button Action

- (void)positiveAction {
    if (self.clickPositiveButtonListener) {
        self.clickPositiveButtonListener(self, [self inputString]);
    }
}

- (void)negativeAction {
    if (self.clickNegativeButtonListener) {
        self.clickNegativeButtonListener(self, [self inputString]);
    }
}

#pragma mark - Setter & Getter

- (MXAlertView *)alertView {
    if (_alertView == nil) {
        _alertView = [MXAlertView new];
    }
    return _alertView;
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecuting {
    return _executing;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isFinished {
    return _finished;
}

- (MXAlertType)type {
    return [[self alertView] type];
}

- (NSString *)titleString {
    return [[[self alertView] titleLabel] text];
}

- (NSString *)subtitleString {
    return [[[self alertView] subtitleLabel] text];
}

- (NSString *)inputString {
    NSString *input = [[[self alertView] inputView] text];
    if (input == nil) {
        return @"";
    }
    return [input copy];
}

- (NSString *)messageString {
    return [[[self alertView] messageLabel] text];
}

- (NSString *)positiveButtonTitleString {
    return [[[self alertView] positiveButton] titleForState:UIControlStateNormal];
}

- (NSString *)negativeButtonTitleString {
    return [[[self alertView] negativeButton] titleForState:UIControlStateNormal];
}

#pragma mark - Show & Hide
- (void)show {
    [[MXAlertManager defaultManager] addAlert:self];
}

- (void)hide {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self alertView] endEditing:YES];
        
        [UIView animateWithDuration:0.25
                              delay:0.05
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             CGRect frame = [[weakSelf alertView] frame];
                             frame.origin.y = fmax([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                             [[weakSelf alertView] setFrame:frame];
                             [[weakSelf alertView] setAlpha:0];
                         } completion:^(BOOL finished) {
                             [[weakSelf alertView] removeFromSuperview];
                             [[MXAlertWindow defaultWindow] setAlpha:0];
                             [[MXAlertWindow defaultWindow] setUserInteractionEnabled:NO];
                             [weakSelf finish];
                         }];
    });
}

- (void)start {
    if (![NSThread isMainThread]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf start];
        });
    } else {
        [super start];
    }
}

- (void)main {
    [self setExecuting:YES];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[weakSelf alertView] updateView];
        [[weakSelf alertView] setAlpha:0];
        [[MXAlertWindow defaultWindow] setAlpha:0];
        [[MXAlertWindow defaultWindow] addSubview:[weakSelf alertView]];
        [[MXAlertWindow defaultWindow] setUserInteractionEnabled:YES];
        [[MXAlertWindow defaultWindow] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        CGRect frame = [[weakSelf alertView] frame];
        frame.origin.y = -frame.size.height;
        [[weakSelf alertView] setFrame:frame];
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [[weakSelf alertView] updateView];
                             [[MXAlertWindow defaultWindow] setAlpha:1];
                             [[weakSelf alertView] setAlpha:1];
                         } completion:^(BOOL finished) {
                             
                         }];
    });
}

- (void)cancel {
    [super cancel];
    [self finish];
    [[self alertView] removeFromSuperview];
}

- (void)finish {
    [self setExecuting:NO];
    [self setFinished:YES];
}
@end
