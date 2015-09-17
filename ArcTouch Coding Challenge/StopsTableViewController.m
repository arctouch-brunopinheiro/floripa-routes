//
//  StopsTableViewController.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/15/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "DeparturesViewController.h"
#import "StopsTableViewController.h"

@interface StopsTableViewController () {
    
    WebAPIHandler *webAPIHandler;
    NSArray *rowsForRoutes;
    NSArray *departuresForRoute;
    int departureCellRow;
    int departureCellColumn;
    
}

@end

@implementation StopsTableViewController

@synthesize routeId;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0); // change to only once
    [self setTitleForNavigationBar];
    rowsForRoutes = [[NSArray alloc] init];
    webAPIHandler = [[WebAPIHandler alloc] init];
    webAPIHandler.delegate = self;
    [webAPIHandler findStopsByRouteId:[routeId stringValue]];
}

- (void)setTitleForNavigationBar
{
    self.navigationItem.title = @"Stops";
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rowsForRoutes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
    
    NSDictionary *cellContent = [rowsForRoutes objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellContent objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
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
    rowsForRoutes = rows;
    [webAPIHandler findDeparturesByRouteId:[routeId stringValue]];
    [self.tableView reloadData];
}

@end
