//
//  DeparturesViewController.h
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/16/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "WebAPIHandler.h"

@import UIKit;

@interface DeparturesViewController : UIViewController <WebAPIDeparturesDelegate>

@property (strong, nonatomic) NSNumber *routeId;

@end
