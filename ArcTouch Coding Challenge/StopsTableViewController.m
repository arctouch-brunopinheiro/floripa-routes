//
//  StopsTableViewController.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/15/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "DeparturesViewController.h"
#import "SpinnerView.h"
#import "StopsTableViewController.h"

@interface StopsTableViewController () {
    
    SpinnerView *spinnerView;
    WebAPIHandler *webAPIHandler;
    NSArray *rowsForStops;
    int departureCellRow;
    int departureCellColumn;
    
}

@end

@implementation StopsTableViewController

@synthesize routeId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;
    [self setTitleForNavigationBar];
    [self setupWebAPIHandler];
    [self setupSpinnerView];
    [self setupRowsForStops];
    [spinnerView showSpinner];
    [webAPIHandler findStopsByRouteId:[routeId stringValue]];
}

#pragma mark - Setup

- (void)setTitleForNavigationBar
{
    self.navigationItem.title = kTitleStops;
}

- (void)setupWebAPIHandler
{
    webAPIHandler = [[WebAPIHandler alloc] init];
    webAPIHandler.delegate = self;
}

- (void)setupSpinnerView
{
    spinnerView = [[SpinnerView alloc] initWithView:self.view];
}

- (void)setupRowsForStops
{
    rowsForStops = [[NSArray alloc] init];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rowsForStops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStopsCellIdentifer forIndexPath:indexPath];
    NSDictionary *cellContent = [rowsForStops objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellContent objectForKey:kKeyName];
    cell.textLabel.font = [UIFont systemFontOfSize:kStopsCellLabelFontSize];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DeparturesViewController *departuresViewController = [segue destinationViewController];
    departuresViewController.routeId = routeId;
}

#pragma mark - Delegates

- (void)updateStopsTableViewControllerWithRows:(NSArray *)rows
{
    [spinnerView hideSpinner];
    rowsForStops = rows;
    [self.tableView reloadData];
}

@end
