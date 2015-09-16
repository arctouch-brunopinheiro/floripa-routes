//
//  SearchTableViewController.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/14/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

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
    spinnerView = [[SpinnerView alloc] initWithTableView:self.tableView];
    //[self findRoutesByStopName];
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
    return [resultRowsForSearch count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    NSDictionary *cellContent = [resultRowsForSearch objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellContent objectForKey:@"longName"];
    cell.tag = (int)[cellContent objectForKey:@"id"];
    // Configure the cell...
    
    return cell;
}


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
