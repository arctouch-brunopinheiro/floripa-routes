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

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.showsVerticalScrollIndicator=YES;
    scrollView.scrollEnabled=YES;
    scrollView.userInteractionEnabled=YES;
    [self.view addSubview:scrollView];
    [self drawHeaderLabels];
    webAPIHandler = [[WebAPIHandler alloc] init];
    webAPIHandler.delegate = self;
    [webAPIHandler findDeparturesByRouteId:[routeId stringValue]];
}

- (void)drawHeaderLabels
{
    currentRow = 0;
    NSArray *headers = @[@"Weekdays", @"Saturdays", @"Sundays"];
    for (int i = 0; i < [headers count]; i++) {
        currentColumn = i;
        UILabel *headerLabel = [self getCurrentLabel];
        headerLabel.backgroundColor = [UIColor redColor];
        headerLabel.text = [headers objectAtIndex:i];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        [scrollView addSubview:headerLabel];
    }
    currentRow++;
    currentColumn = 0;
}

- (void)drawWeekdayDepartures
{
    currentRow = 1;
    for (int i = 0; i < [departuresForWeekdays count]; i++) {
        currentRow = i;
        UILabel *headerLabel = [self getCurrentLabel];
        headerLabel.backgroundColor = [UIColor yellowColor];
        headerLabel.text = [[departuresForWeekdays objectAtIndex:i] objectForKey:@"time"];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:headerLabel];
    }
}

- (UILabel *)getCurrentLabel
{
    return [[UILabel alloc] initWithFrame:[self getFrameForCurrentLabel]];
}

- (CGRect)getFrameForCurrentLabel
{
    int labelWidth = (self.view.frame.size.width - 40) / 3;
    int labelHeight = 20;
    int labelPositionX = 10 + (currentColumn * (labelWidth + 10));
    int labelPositionY = 30 + self.navigationController.navigationBar.frame.size.height + (currentRow * (labelHeight + 10));
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
    return CGRectMake(labelPositionX,  labelPositionY, labelWidth, labelHeight);
}

#pragma mark - Departures Data Handling

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
    [self drawWeekdayDepartures];
}

@end
