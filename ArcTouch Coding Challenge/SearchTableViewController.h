//
//  SearchTableViewController.h
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/14/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "WebAPIHandler.h"
#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController <UISearchBarDelegate, WebAPISearchDelegate>

@property (strong, nonatomic) UISearchController *searchController;

@end
