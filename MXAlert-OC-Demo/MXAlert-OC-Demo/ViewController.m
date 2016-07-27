//
//  ViewController.m
//  MXAlertView-OC-Demo
//
//  Created by Meniny on 16/7/27.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "ViewController.h"
#import "MXAlert.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray <NSString *>* textArray;
@end

@implementation ViewController

- (NSMutableArray<NSString *> *)textArray {
    if (_textArray == nil) {
        _textArray = [NSMutableArray array];
    }
    return _textArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[self textArray] addObjectsFromArray:@[@"About", @"Info", @"Inquire", @"Input", @"Loading", @"Points", @"Image", @"Detail"]];
    
    UITableView *tableView = [UITableView new];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setTableFooterView:[UIView new]];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self view] addSubview:tableView];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[t]|" options:0 metrics:nil views:@{@"t": tableView}]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[t]|" options:0 metrics:nil views:@{@"t": tableView}]];
}

#pragma mark - UITableView Delegate & DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"MXSomeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    [[cell textLabel] setText:[[self textArray] objectAtIndex:[indexPath row]]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MXAlert *alert = [MXAlert buildWithType:[indexPath row]];
    [alert setTitle:[[self textArray] objectAtIndex:[indexPath row]]];
    [alert setSubtitle:@"A Subtitle"];
    [alert setMessage:@"This is a Message, HAHHAHAHAHAHHAHHAAHAHAHAHHAHAHAH"];
    [alert setIcon:[UIImage imageNamed:@"Logo"]];
    [alert setDetailImage:[UIImage imageNamed:@"Detail"]];
    [alert setPositiveButton:@"OK" onClickListener:^(MXAlertOperation * _Nonnull alertView, NSString * _Nonnull inputString) {
        NSLog(@"Input: %@", inputString);
        [alertView hide];
    }];
    [alert setNegativeButton:@"Cancel" onClickListener:^(MXAlertOperation * _Nonnull alertView, NSString * _Nonnull inputString) {
        if ([inputString length]) {
            NSLog(@"Input: %@", inputString);
        }
        [alertView hide];
    }];
    [alert setAddedPoints:200];
    [alert setTotalPoints:700];
    [alert show];
    if ([alert type] == MXAlertTypeLoading) {
        __weak typeof(alert) weakAlert = alert;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakAlert hide];
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self textArray] count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
