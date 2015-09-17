//
//  DeparturesViewController.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/16/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "DeparturesViewController.h"
#import "SpinnerView.h"

@interface DeparturesViewController ()

@end

@implementation DeparturesViewController {

    SpinnerView *spinnerView;
    WebAPIHandler *webAPIHandler;
    NSMutableArray *departuresForWeekdays;
    NSMutableArray *departuresForSaturdays;
    NSMutableArray *departuresForSundays;
    UIScrollView *scrollView;
    int currentRow;
    int currentColumn;
    
}

@synthesize routeId;

#pragma mark - Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollView];
    [self.view addSubview:scrollView];
    [self setupSpinnerView];
    [self setTitleForNavigationBar];
    [self setupWebAPIHandler];
    [spinnerView showSpinner];
    [webAPIHandler findDeparturesByRouteId:[routeId stringValue]];
}

- (void)setTitleForNavigationBar
{
    self.navigationItem.title = kTitleDepartures;
}

- (void)setupScrollView
{
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled = YES;
}

- (void)setupSpinnerView
{
    spinnerView = [[SpinnerView alloc] initWithView:self.view];
}

- (void)setupWebAPIHandler
{
    webAPIHandler = [[WebAPIHandler alloc] init];
    webAPIHandler.delegate = self;
}

#pragma mark - Showing Data

- (void)drawHeaders
{
    currentRow = 0;
    NSArray *headers = @[kHeaderWeekday, kHeaderSaturday, kHeaderSunday];
    for (int i = 0; i < [headers count]; i++) {
        currentColumn = i;
        UILabel *label = [self getFormattedLabelForHeaders];
        label.text = [headers objectAtIndex:i];
        [scrollView addSubview:label];
    }
}

- (void)drawDeparturesForWeekdays
{
    currentColumn = 0;
    for (int i = 0; i < [departuresForWeekdays count]; i++) {
        currentRow = i + 1;
        UILabel *label = [self getFormattedLabelForDepartures];
        label.text = [[departuresForWeekdays objectAtIndex:i] objectForKey:kKeyTime];
        [scrollView addSubview:label];
        if (i == ([departuresForWeekdays count] - 1)) {
            CGFloat scrollViewHeight = label.frame.origin.y + kLabelHeight + kLabelMargin;
            [self updateHeightForScrollView:scrollViewHeight];
        }
    }
}

- (void)drawDeparturesForSaturdays
{
    currentColumn = 1;
    for (int i = 0; i < [departuresForSaturdays count]; i++) {
        currentRow = i + 1;
        UILabel *label = [self getFormattedLabelForDepartures];
        label.text = [[departuresForSaturdays objectAtIndex:i] objectForKey:kKeyTime];
        [scrollView addSubview:label];
        if (i == ([departuresForSaturdays count] - 1)) {
            CGFloat scrollViewHeight = label.frame.origin.y + kLabelHeight + kLabelMargin;
            [self updateHeightForScrollView:scrollViewHeight];
        }
    }
}

- (void)drawDeparturesForSundays
{
    currentColumn = 2;
    for (int i = 0; i < [departuresForSundays count]; i++) {
        currentRow = i + 1;
        UILabel *label = [self getFormattedLabelForDepartures];
        label.text = [[departuresForSundays objectAtIndex:i] objectForKey:kKeyTime];
        [scrollView addSubview:label];
        if (i == ([departuresForSundays count] - 1)) {
            CGFloat scrollViewHeight = label.frame.origin.y + kLabelHeight + kLabelMargin;
            [self updateHeightForScrollView:scrollViewHeight];
        }
    }
}

- (void)updateHeightForScrollView:(CGFloat)height
{
    if (scrollView.contentSize.height < height) {
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, height);
    }
}

#pragma mark - Creating Labels

- (UILabel *)getCurrentLabel
{
    return [[UILabel alloc] initWithFrame:[self getFrameForCurrentLabel]];
}

- (UILabel *)getFormattedLabelForHeaders
{
    UILabel *label = [[UILabel alloc] initWithFrame:[self getFrameForCurrentLabel]];
    label.font = [UIFont systemFontOfSize:kHeaderLabelFontSize];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)getFormattedLabelForDepartures
{
    UILabel *label = [[UILabel alloc] initWithFrame:[self getFrameForCurrentLabel]];
    label.font = [UIFont systemFontOfSize:kDeparturesLabelFontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    return label;
}

- (CGRect)getFrameForCurrentLabel
{
    int labelWidth = (self.view.frame.size.width - kLabelMargin * 4) / 3;
    int labelPositionX = kLabelMargin + (currentColumn * (labelWidth + kLabelMargin));
    int labelPositionY = kLabelMargin + (currentRow * (kLabelHeight + kLabelMargin));
    return CGRectMake(labelPositionX, labelPositionY, labelWidth, kLabelHeight);
}

#pragma mark - Data Handling

- (void)separateRowsToDepartureArrays:(NSArray *)rows
{
    [self initDepartureArrays];
    for (NSDictionary *row in rows) {
        if ([[row objectForKey:kKeyCalendar] isEqualToString:kKeyWeekday]) {
            [departuresForWeekdays addObject:row];
        } else if ([[row objectForKey:kKeyCalendar] isEqualToString:kKeySaturday]) {
            [departuresForSaturdays addObject:row];
        } else if ([[row objectForKey:kKeyCalendar] isEqualToString:kKeySunday]) {
            [departuresForSundays addObject:row];
        }
    }
}

- (void)initDepartureArrays
{
    departuresForWeekdays = [[NSMutableArray alloc] init];
    departuresForSaturdays = [[NSMutableArray alloc] init];
    departuresForSundays = [[NSMutableArray alloc] init];
}

#pragma mark - Delegates

- (void)updateDeparturesViewControllerWithRows:(NSArray *)rows
{
    [spinnerView hideSpinner];
    [self separateRowsToDepartureArrays:rows];
    [self drawHeaders];
    [self drawDeparturesForWeekdays];
    [self drawDeparturesForSaturdays];
    [self drawDeparturesForSundays];
}

- (void)requestDidFail
{
    [spinnerView hideSpinner];
}

@end
