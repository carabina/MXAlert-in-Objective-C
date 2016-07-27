//
//  MXAlertShadowView.m
//  MXAlertView-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "MXAlertShadowView.h"

@interface MXAlertShadowView ()
@property (weak, nonatomic) CALayer * innerView;
@end

@implementation MXAlertShadowView
- (instancetype)init {
    self = [super init];
    [self setup];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setup {
}

- (void)layoutSubviews {
    [super layoutSubviews];//is must to ensure rightly layout children view
    CGColorRef color = [[UIColor whiteColor] CGColor];
    
    if (self.innerView == nil) {
        //1. first, create Inner layer with content
        CALayer *innerView = [CALayer layer];
        innerView.frame = self.bounds;
        //instead of: innerView.frame = self.frame;
        //            innerView.borderWidth = 1.0f;
        innerView.cornerRadius = self.layer.cornerRadius;
        innerView.masksToBounds = YES;
        //            innerView.borderColor = [[UIColor lightGrayColor] CGColor];
        //put the layer to the BOTTOM of layers is also a MUST step...
        //otherwise this layer will overlay the sub uiviews in current uiview...
        [innerView setBackgroundColor:color];
        self.innerView = innerView;
        [self.layer insertSublayer:self.innerView atIndex:0];
        
        //2. then, create shadow with self layer
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.2f;
        //shadow length
        self.layer.shadowRadius = 1.5f;
        //no offset
        self.layer.shadowOffset = CGSizeZero;
        //right down shadow
        //[self.layer setShadowOffset: CGSizeMake(1.0f, 1.0f)];
        
        //3. last but important, MUST clear current view background color, or the color will show in the corner!
        self.backgroundColor = [UIColor clearColor];
        //    } else {
        //        self.innerView.frame = self.bounds;
        //        self.innerView.cornerRadius = self.layer.cornerRadius;
    } else {
        self.innerView.frame = self.bounds;
    }
    [self.innerView setBackgroundColor:color];
}
@end
