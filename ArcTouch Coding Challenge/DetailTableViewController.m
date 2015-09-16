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
    NSArray *resultRowsForSearch;
    CGFloat heightForCell;
    int selectedRow;
    
}

@end

@implementation DetailTableViewController

@synthesize routeId;

- (void)viewDidLoad {
    [super viewDidLoad];
    heightForCell = 20;
    resultRowsForSearch = [[NSArray alloc] init];
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
    return [resultRowsForSearch count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
    
    NSDictionary *cellContent = [resultRowsForSearch objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellContent objectForKey:@"name"];
    return cell;
}

#pragma mark - Cell Details

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    int row = (int)[indexPath row];
    selectedRow = row;
    
    heightForCell = 100;
    [tableView beginUpdates];
    [tableView endUpdates];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 50;
    if ([indexPath row] == selectedRow) {
        height = heightForCell;
    }
    return height;
}


#pragma mark - Delegates

- (void)updateDetailTableViewControllerWithRows:(NSArray *)rows
{
    resultRowsForSearch = rows;
    [self.tableView reloadData];
}


@end
