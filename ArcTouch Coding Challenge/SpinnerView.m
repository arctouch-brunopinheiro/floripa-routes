//
//  SpinnerView.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/15/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "SpinnerView.h"

@implementation SpinnerView {

    UIView *parentView;
    UIView *dimView;
    UIActivityIndicatorView *spinnerView;

}

- (id)initWithView:(UIView *)viewForInstance
{
    self = [super init];
    if (self) {
        parentView = viewForInstance;
        [self setupDimView];
        [self setupSpinnerView];
    }
    return self;
}

#pragma mark - Setup Elements

- (void)setupDimView
{
    dimView = [[UIView alloc] initWithFrame:parentView.frame];
    dimView.backgroundColor = [UIColor whiteColor];
    dimView.alpha = 0.5;
    [dimView addSubview:[self getLabel]];
}

- (void)setupSpinnerView
{
    spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinnerView.frame = parentView.frame;
    [spinnerView setCenter:CGPointMake(parentView.frame.size.width / 2, parentView.frame.size.height / 2)];
}

- (UILabel *)getLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:[self getFrameForLabel]];
    label.text = kSpinnerLabelText;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (CGRect)getFrameForLabel
{
    int labelWidth = parentView.frame.size.width;
    int labelPositionY = (parentView.frame.size.height / 2) + kSpinnerLabelTopMargin;
    return CGRectMake(0, labelPositionY, labelWidth, kLabelHeight);
}

#pragma mark - Show/Hide Spinner

- (void)showSpinner
{
    [parentView addSubview:dimView];
    [parentView addSubview:spinnerView];
    [spinnerView startAnimating];
}

- (void)hideSpinner
{
    [spinnerView stopAnimating];
    [spinnerView removeFromSuperview];
    [dimView removeFromSuperview];
}

@end
