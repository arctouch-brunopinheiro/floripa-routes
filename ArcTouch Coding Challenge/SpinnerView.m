//
//  SpinnerView.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/15/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "SpinnerView.h"

@implementation SpinnerView {

    UITableView *tableView;
    UIView *dimView;
    UIActivityIndicatorView *spinnerView;

}

#pragma mark - Setup (public)

- (id)initWithTableView:(UITableView *)tableViewForInstance
{
    self = [super init];
    if (self) {
        tableView = tableViewForInstance;
        [self setupDimView];
        [self setupSpinnerView];
    }
    return self;
}

#pragma mark - Setup (private)

- (void)setupDimView
{
    dimView = [[UIView alloc] initWithFrame:tableView.frame];
    dimView.backgroundColor = [UIColor cyanColor];
    dimView.alpha = 0.1;
}

- (void)setupSpinnerView
{
    spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinnerView.frame = tableView.frame;
    [spinnerView setCenter:CGPointMake(tableView.frame.size.width / 2, tableView.frame.size.height / 2)];
}

#pragma mark - Show/Hide Spinner (public)

- (void)showSpinner
{
    [tableView addSubview:dimView];
    [tableView addSubview:spinnerView];
    [spinnerView startAnimating];
}

- (void)hideSpinner
{
    [spinnerView stopAnimating];
    [spinnerView removeFromSuperview];
    [dimView removeFromSuperview];
}

@end
