//
//  WebAPIHandler.h
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/14/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

@import UIKit;
@import Foundation;
// FIXME: The delegate protocols' method names are not in accordance with the standards. 
@protocol WebAPISearchDelegate <NSObject>

- (void)updateSearchTableViewControllerWithRows:(NSArray *)rows;
- (void)requestDidFail;

@end

@protocol WebAPIStopsDelegate <NSObject>

- (void)updateStopsTableViewControllerWithRows:(NSArray *)rows;

@end

@protocol WebAPIDeparturesDelegate <NSObject>

- (void)updateDeparturesViewControllerWithRows:(NSArray *)rows;
- (void)requestDidFail;

@end

@interface WebAPIHandler : NSObject
// QUESTION: Why did you use an untyped delegate?
// QUESTION: Can you think of a way to make this property safer using protocols?
// QUESTION: How else could you do this without using a delegate?
@property (nonatomic, assign) id delegate;

#pragma mark - Perform Searches (public)

- (void)findRoutesByStopName:(NSString *)stopName;
- (void)findDeparturesByRouteId:(NSString *)routeId;
- (void)findStopsByRouteId:(NSString *)routeId;

@end
