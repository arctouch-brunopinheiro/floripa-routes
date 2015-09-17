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
    [self setupWebAPIHandler];
    [self setupSearchController];
    [self setupSpinnerView];
    [self setupResultsForSearch];
}

#pragma mark - Setup

- (void)setupWebAPIHandler
{
    webAPIHandler = [[WebAPIHandler alloc] init];
    webAPIHandler.delegate = self;
}

- (void)setupResultsForSearch
{
    resultRowsForSearch = [[NSArray alloc] init];
}

- (void)setupSpinnerView
{
    spinnerView = [[SpinnerView alloc] initWithView:self.view];
}

- (void)setupSearchController
{
    searchController = [self getSearchController];
    self.tableView.tableHeaderView = searchController.searchBar;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    NSDictionary *cellContent = [resultRowsForSearch objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellContent objectForKey:@"longName"];
    cell.textLabel.font = [UIFont systemFontOfSize:kCellLabelFontSize];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *cellContent = [resultRowsForSearch objectAtIndex:indexPath.row];
    UINavigationController *navController = [segue destinationViewController];
    StopsTableViewController *stopsTableViewController = (StopsTableViewController *)([navController viewControllers][0]);
    stopsTableViewController.routeId = [cellContent objectForKey:@"id"];
}

#pragma mark - Delegates

- (void)hideSpinnerOnSearchTableViewController
{
    //[spinnerView hideSpinner];
}

- (void)showSpinnerOnSearchTableViewController
{
    //[spinnerView showSpinner];
}

- (void)updateSearchTableViewControllerWithRows:(NSArray *)rows
{
    [spinnerView hideSpinner];
    resultRowsForSearch = rows;
    [self.tableView reloadData];
}

#pragma mark - Search Bar

- (UISearchController *)getSearchController
{
    UISearchController *controller = [[UISearchController alloc] initWithSearchResultsController:nil];
    [self addConfigToSearchController:controller];
    [self addStylesToSearchController:controller];
    return controller;
}

- (void)addConfigToSearchController:(UISearchController *)controller
{
    controller.dimsBackgroundDuringPresentation = NO;
    controller.searchBar.delegate = self;
    [controller.searchBar sizeToFit];
}

- (void)addStylesToSearchController:(UISearchController *)controller
{
    [controller.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [controller.searchBar setBackgroundImage:[UIImage imageWithCGImage:(__bridge CGImageRef)([UIColor clearColor])]];
    controller.searchBar.tintColor = self.navigationController.navigationBar.barTintColor;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = [self prepareSearchTextForSearch:searchBar.text];
    [self.searchController setActive:NO];
    [spinnerView showSpinner];
    [webAPIHandler findRoutesByStopName:searchString];
}

- (NSString *)prepareSearchTextForSearch:(NSString *)searchText
{
    return [NSString stringWithFormat:@"%%%@%%", searchText];
}

@end
