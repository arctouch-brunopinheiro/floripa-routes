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
    // QUESTION: Why not properties?
    SpinnerView *spinnerView;
    WebAPIHandler *webAPIHandler;
    NSArray *resultRowsForSearch;
    
}

@synthesize searchController;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self setTitleForNavigationBar];
    [self setupWebAPIHandler];
    [self setupSearchController];
    [self setupSpinnerView];
    [self setupResultsForSearch];
}

#pragma mark - Setup

- (void)setTitleForNavigationBar
{
    self.navigationItem.title = kTitleSearchRoutes;
}

- (void)setupWebAPIHandler
{
    webAPIHandler = [[WebAPIHandler alloc] init];
    webAPIHandler.delegate = self;
}

- (void)setupSearchController
{
    searchController = [self getSearchController];
    self.tableView.tableHeaderView = searchController.searchBar;
}



- (void)setupSpinnerView
{
    spinnerView = [[SpinnerView alloc] initWithView:self.view];
}

- (void)setupResultsForSearch
{
    resultRowsForSearch = [[NSArray alloc] init];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCellIdentifier forIndexPath:indexPath];
    NSDictionary *cellContent = [resultRowsForSearch objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellContent objectForKey:kKeyLongName];
    cell.textLabel.font = [UIFont systemFontOfSize:kSearchCellLabelFontSize];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *cellContent = [resultRowsForSearch objectAtIndex:indexPath.row];
    UINavigationController *navController = [segue destinationViewController];
    // FIXME: This is just a suggestion! As you are initializing a variable just declared, you don't really need to cast since it is very easy to infer the type here.
    StopsTableViewController *stopsTableViewController = (StopsTableViewController *)([navController viewControllers][0]);
    stopsTableViewController.routeId = [cellContent objectForKey:kKeyId];
}

#pragma mark - Delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = [self prepareSearchTextForSearch:searchBar.text];
    [self.searchController setActive:NO];
    [spinnerView showSpinner];
    [webAPIHandler findRoutesByStopName:searchString];
}

- (void)updateSearchTableViewControllerWithRows:(NSArray *)rows
{
    [spinnerView hideSpinner];
    resultRowsForSearch = rows;
    [self.tableView reloadData];
}

- (void)requestDidFail
{
    [spinnerView hideSpinner];
}

#pragma mark - Search Bar
// FIXME: 'get' is a prefix for accessor method names in other languages, this is a factory method. You should name it 'createSearchController' or something alike.
// QUESTION: An alternative here would be to use the property accessor and make it lazy. Can you tell me how you could implement it?
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

- (NSString *)prepareSearchTextForSearch:(NSString *)searchText
{
    return [NSString stringWithFormat:@"%%%@%%", searchText];
}

@end
