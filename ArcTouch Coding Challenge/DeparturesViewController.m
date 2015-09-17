//
//  DeparturesViewController.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/16/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "DeparturesViewController.h"

@interface DeparturesViewController ()

@end

@implementation DeparturesViewController {

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
    [self setTitleForNavigationBar];
    [self drawHeaders];
    [self setupWebAPIHandler];
    [webAPIHandler findDeparturesByRouteId:[routeId stringValue]];
}

- (void)setTitleForNavigationBar
{
    self.navigationItem.title = @"Departures";
}

- (void)setupScrollView
{
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled = YES;
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
    NSArray *headers = @[@"Weekdays", @"Saturdays", @"Sundays"];
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
        label.text = [[departuresForWeekdays objectAtIndex:i] objectForKey:@"time"];
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
        label.text = [[departuresForSaturdays objectAtIndex:i] objectForKey:@"time"];
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
        label.text = [[departuresForSundays objectAtIndex:i] objectForKey:@"time"];
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
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)getFormattedLabelForDepartures
{
    UILabel *label = [[UILabel alloc] initWithFrame:[self getFrameForCurrentLabel]];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    return label;
}

- (CGRect)getFrameForCurrentLabel
{
    int labelWidth = (self.view.frame.size.width - kLabelMargin * 4) / 3;
    int labelPositionX = kLabelMargin + (currentColumn * (labelWidth + kLabelMargin));
    int labelPositionY = kLabelMargin + (currentRow * (kLabelHeight + kLabelMargin));
    return CGRectMake(labelPositionX,  labelPositionY, labelWidth, kLabelHeight);
}

#pragma mark - Data Handling

- (void)separateRowsToDepartureArrays:(NSArray *)rows
{
    [self initDepartureArrays];
    for (NSDictionary *row in rows) {
        if ([[row objectForKey:@"calendar"] isEqualToString:@"WEEKDAY"]) {
            [departuresForWeekdays addObject:row];
        } else if ([[row objectForKey:@"calendar"] isEqualToString:@"SATURDAY"]) {
            [departuresForSaturdays addObject:row];
        } else if ([[row objectForKey:@"calendar"] isEqualToString:@"SUNDAY"]) {
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
    [self separateRowsToDepartureArrays:rows];
    [self drawDeparturesForWeekdays];
    [self drawDeparturesForSaturdays];
    [self drawDeparturesForSundays];
}

@end
