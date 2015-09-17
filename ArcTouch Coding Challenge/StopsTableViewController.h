//
//  StopsTableViewController.h
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/15/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "WebAPIHandler.h"

@import UIKit;

@interface StopsTableViewController : UITableViewController <WebAPISearchDetailsDelegate>

@property (strong, nonatomic) NSNumber *routeId;

@end
