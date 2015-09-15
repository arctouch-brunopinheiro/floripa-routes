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

@interface WebAPIHandler : NSObject

@property (nonatomic, assign) id delegate;

- (void)testJSONService;

@end
