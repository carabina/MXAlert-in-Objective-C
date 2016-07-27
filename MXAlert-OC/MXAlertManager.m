//
//  MXAlertManager.m
//  MXAlertView-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "MXAlertManager.h"

@interface MXAlertManager ()
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation MXAlertManager

#pragma mark - Allocation
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

+ (instancetype)defaultManager {
    static MXAlertManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MXAlertManager new];
    });
    return instance;
}

#pragma mark - Getter & Setter

- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [NSOperationQueue new];
        [_queue setMaxConcurrentOperationCount:1];
    }
    return _queue;
}

- (MXAlertOperation *)currentAlert {
    if ([[self queue] operationCount]) {
        return (MXAlertOperation *)[[[self queue] operations] firstObject];
    }
    return nil;
}

#pragma mark - Actions

- (void)addAlert:(MXAlertOperation *)alert {
    if (alert != nil) {
        [[self queue] addOperation:alert];
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    if ([[self queue] operationCount]) {
        MXAlertOperation *lastAlert = (MXAlertOperation *)[[[self queue] operations] firstObject];
        if ([lastAlert alertView] != nil) {
            [[lastAlert alertView] updateView];
        }
    }
}

- (void)cancelAllAlert {
    for (MXAlertOperation *alert in [[self queue] operations]) {
        [alert cancel];
    }
}
@end
