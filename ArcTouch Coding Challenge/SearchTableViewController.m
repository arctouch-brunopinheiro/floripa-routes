//
//  SearchTableViewController.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/14/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "SearchTableViewController.h"
#import "WebAPIHandler.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController {

    WebAPIHandler *webAPIHandler;
    NSArray *resultsForSearch;
    
}

@synthesize searchController;

- (void)viewDidLoad {
    [super viewDidLoad];
    webAPIHandler = [[WebAPIHandler alloc] init];
    resultsForSearch = [[NSArray alloc] init];
    [self setupSearchBar];
    [self findRoutesByStopName];
    /*
    UIView *spinnerBackGroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    spinnerBackGroundView.backgroundColor = [UIColor blackColor];
    spinnerBackGroundView.alpha = 0.1;
    [self.tableView addSubview:spinnerBackGroundView];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(160,124)];
    [self.tableView addSubview:spinner];
    spinner.frame = self.tableView.frame;
    [spinner startAnimating];*/
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultsForSearch count];
}
/*

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    NSString *searchString = searchBar.text;
    // update celldata array
    //
    NSLog(@"SEARCHED FOR: %@", searchString);
}

#pragma mark - Web API

- (void)findRoutesByStopName
{
    [webAPIHandler testJSONService];
}

@end
