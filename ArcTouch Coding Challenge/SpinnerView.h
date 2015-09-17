//
//  SpinnerView.h
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/15/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface SpinnerView : NSObject

#pragma mark - Setup (public)

- (id)initWithView:(UIView *)viewForInstance;

#pragma mark - Show/Hide Spinner (public)

- (void)showSpinner;
- (void)hideSpinner;

@end
