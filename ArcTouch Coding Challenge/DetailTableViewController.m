//
//  DetailTableViewController.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/15/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController () {
    
    WebAPIHandler *webAPIHandler;
    NSArray *rowsForRoutes;
    NSArray *departuresForRoute;
    int departureCellRow;
    int departureCellColumn;
    
}

@end

@implementation DetailTableViewController

@synthesize routeId;

- (void)viewDidLoad {
    [super viewDidLoad];
    rowsForRoutes = [[NSArray alloc] init];
    webAPIHandler = [[WebAPIHandler alloc] init];
    webAPIHandler.delegate = self;
    [webAPIHandler findStopsByRouteId:[routeId stringValue]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return cell;
}

#pragma mark - Cell Details

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *cellContent = [rowsForRoutes objectAtIndex:indexPath.row];
    [webAPIHandler findDeparturesByRouteId:[[cellContent objectForKey:@"id"] stringValue]];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}


- (void)addDeparturesToSelectedCell:(NSArray *)departures
{
    departureCellColumn = 0;
    departureCellRow = 0;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    for (NSDictionary *departure in departures) {
        UILabel *label = [self getLabelForCellDetails:cell];
        label.text = @"test";
        [cell addSubview:label];
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (UILabel *)getLabelForCellDetails:(UITableViewCell *)cell
{
    return [[UILabel alloc] initWithFrame:[self getFrameForCellDetailsLabel:cell]];
}

- (CGRect)getFrameForCellDetailsLabel:(UITableViewCell *)cell
{
    int labelWidth = (cell.frame.size.width - 40) / 3;
    int labelHeight = 20;
    int labelPositionX = 10 + (departureCellColumn * (labelWidth + 10));
    int labelPositionY = 10 + (departureCellRow + (labelHeight + 10));
    return CGRectMake(labelPositionX, labelPositionY, labelWidth, labelHeight);
}

#pragma mark - Delegates

- (void)updateDetailTableViewControllerWithRows:(NSArray *)rows
{
    rowsForRoutes = rows;
    [webAPIHandler findDeparturesByRouteId:[routeId stringValue]];
    [self.tableView reloadData];
}

- (void)updateDetailTableViewControllerWithDepartures:(NSArray *)departures
{
    [self addDeparturesToSelectedCell:departures];
}


@end
