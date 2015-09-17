//
//  SearchTableViewController.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/14/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "StopsTableViewController.h"
#import "SearchTableViewController.h"
#import "SpinnerView.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController {

    SpinnerView *spinnerView;
    WebAPIHandler *webAPIHandler;
    NSArray *resultRowsForSearch;
    
}

@synthesize searchController;

- (void)viewDidLoad {
    [super viewDidLoad];
    webAPIHandler = [[WebAPIHandler alloc] init];
    webAPIHandler.delegate = self;

    resultRowsForSearch = [[NSArray alloc] init];
    
    [self setupSearchBar];
    spinnerView = [[SpinnerView alloc] initWithView:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultRowsForSearch count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    NSDictionary *cellContent = [resultRowsForSearch objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellContent objectForKey:@"longName"];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *cellContent = [resultRowsForSearch objectAtIndex:indexPath.row];
    
    UINavigationController *navController = [segue destinationViewController];
    StopsTableViewController *stopsTableViewController = (StopsTableViewController *)([navController viewControllers][0]);
    

    
    //DetailTableViewController *destinationViewController = [segue destinationViewController];
    stopsTableViewController.routeId = [cellContent objectForKey:@"id"];
}

#pragma mark - Delegates

- (void)hideSpinnerOnSearchTableViewController
{
    [spinnerView hideSpinner];
}

- (void)showSpinnerOnSearchTableViewController
{
    [spinnerView showSpinner];
}

- (void)updateSearchTableViewControllerWithRows:(NSArray *)rows
{
    resultRowsForSearch = rows;
    [self.tableView reloadData];
}

#pragma mark - Search Bar

- (void)setupSearchBar
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = [self prepareSearchTextForSearch:searchBar.text];
    [webAPIHandler findRoutesByStopName:searchString];
}

#pragma mark - Helpers

- (NSString *)prepareSearchTextForSearch:(NSString *)searchText
{
    return [NSString stringWithFormat:@"%%%@%%", searchText];
}

@end
