//
//  WebAPIHandler.h
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/14/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebAPISearchDelegate <NSObject>

- (void)hideSpinnerOnSearchTableViewController;
- (void)showSpinnerOnSearchTableViewController;
- (void)updateSearchTableViewControllerWithRows:(NSArray *)rows;

@end

@protocol WebAPISearchDetailsDelegate <NSObject>

- (void)updateDetailTableViewControllerWithRows:(NSArray *)rows;

@end

@protocol WebAPIDeparturesDelegate <NSObject>

- (void)updateDeparturesViewControllerWithRows:(NSArray *)rows;

@end

@interface WebAPIHandler : NSObject

@property (nonatomic, assign) id delegate;

#pragma mark - Perform Searches (public)

- (void)findRoutesByStopName:(NSString *)stopName;
- (void)findDeparturesByRouteId:(NSString *)routeId;
- (void)findStopsByRouteId:(NSString *)routeId;

@end
