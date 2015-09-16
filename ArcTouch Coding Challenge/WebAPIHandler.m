//
//  WebAPIHandler.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/14/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

@import UIKit;

#import "WebAPIHandler.h"

@implementation WebAPIHandler {

    NSString *searchType;

}

@synthesize delegate;

#pragma mark - Perform Searches (public)

- (void)findRoutesByStopName:(NSString *)stopName
{
    searchType = kSearchType_findRoutesByStopName;
    [self showSpinnerOnSearchTableViewController];
    NSMutableURLRequest *request = [self getMutableURLRequest:kUrl_findRoutesByStopName];
    NSMutableDictionary *requestDictionary = [self getRequestDictionaryForParam:stopName ForKey:kKeyStopName];
    [self addRequestDictionary:requestDictionary ToURLRequest:request];
    [self performURLRequest:request];
}

- (void)findDeparturesByRouteId:(NSString *)routeId
{
    searchType = kSearchType_findDeparturesByRouteId;
    NSMutableURLRequest *request = [self getMutableURLRequest:kUrl_findDeparturesByRouteId];
    NSMutableDictionary *requestDictionary = [self getRequestDictionaryForParam:routeId ForKey:kKeyRouteId];
    [self addRequestDictionary:requestDictionary ToURLRequest:request];
    [self performURLRequest:request];
}

- (void)findStopsByRouteId:(NSString *)routeId
{
    searchType = kSearchType_findStopsByRouteId;
    NSMutableURLRequest *request = [self getMutableURLRequest:kUrl_findStopsByRouteId];
    NSMutableDictionary *requestDictionary = [self getRequestDictionaryForParam:routeId ForKey:kKeyRouteId];
    [self addRequestDictionary:requestDictionary ToURLRequest:request];
    [self performURLRequest:request];
}

#pragma mark - Delegates (private)

- (void)showSpinnerOnSearchTableViewController
{
    if([delegate respondsToSelector:@selector(showSpinnerOnSearchTableViewController)]) {
        [delegate showSpinnerOnSearchTableViewController];
    }
}

- (void)hideSpinnerOnSearchTableViewController
{
    if([delegate respondsToSelector:@selector(hideSpinnerOnSearchTableViewController)]) {
        [delegate hideSpinnerOnSearchTableViewController];
    }
}

- (void)updateSearchTableViewControllerWithRows:(NSArray *)rows
{
    if([delegate respondsToSelector:@selector(updateSearchTableViewControllerWithRows:)]) {
        [delegate updateSearchTableViewControllerWithRows:rows];
    }
}

- (void)updateDetailTableViewControllerWithRows:(NSArray *)rows
{
    if([delegate respondsToSelector:@selector(updateDetailTableViewControllerWithRows:)]) {
        [delegate updateDetailTableViewControllerWithRows:rows];
    }
}

- (void)updateDetailTableViewControllerWithDepartures:(NSArray *)departures
{
    if([delegate respondsToSelector:@selector(updateDetailTableViewControllerWithDepartures:)]) {
        [delegate updateDetailTableViewControllerWithDepartures:departures];
    }
}

#pragma mark - Create URL Request (private)

- (NSString *)getAuthenticationValue
{
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", kUsername, kPassword];
    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authenticationValue = [authenticationData base64EncodedStringWithOptions:0];
    return [NSString stringWithFormat:@"Basic %@", authenticationValue];
}

- (NSMutableURLRequest *)getMutableURLRequest:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self addCommonHeadersToMutableURLRequest:request];
    return request;
}

- (void)addCommonHeadersToMutableURLRequest:(NSMutableURLRequest *)request
{
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[self getAuthenticationValue] forHTTPHeaderField:@"Authorization"];
    [request addValue:kCustomHeaderValue forHTTPHeaderField:kCustomHeaderField];
    [request setHTTPMethod:@"POST"];
}

- (void)addRequestDictionary:(NSMutableDictionary *)requestDictionary ToURLRequest:(NSMutableURLRequest *)request
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:0 error:nil];
    [request setHTTPBody:jsonData];
}

- (NSMutableDictionary *)getRequestDictionaryForParam:(NSString *)param ForKey:(NSString *)key
{
    NSMutableDictionary *paramsDictionary = [[NSMutableDictionary alloc] init];
    [paramsDictionary setObject:param forKey:key];
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    [requestDictionary setObject:paramsDictionary forKey:@"params"];
    return requestDictionary;
}

#pragma mark - Perform URL Request (private)

- (void)performURLRequest:(NSMutableURLRequest *)request
{
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responseCode, NSData *responseData, NSError *responseError) {
        if ([responseData length] > 0 && responseError == nil){
            if (![self isResponseDataContainingResults:responseData]) {
                [self showAlertForError:@"The search returned no results"];
            } else {
                [self returnResponseDataToView:responseData];
            }
            [self hideSpinnerOnSearchTableViewController];
        } else if ([responseData length] == 0 && responseError == nil){
            [self showAlertForError:@"The data could not be accessed"];
        } else if (responseError != nil && responseError.code == NSURLErrorTimedOut){
            [self showAlertForError:@"The connection timed out"];
        } else if (responseError != nil){
            [self showAlertForError:@"The data could not be downloaded"];
        }
    }];
}

#pragma mark - Handling URL Response (private)

- (void)returnResponseDataToView:(NSData *)responseData
{
    if ([searchType isEqualToString:kSearchType_findRoutesByStopName]) {
        [self updateSearchTableViewControllerWithRows:[self prepareResponseDataForView:responseData]];
    } else if ([searchType isEqualToString:kSearchType_findStopsByRouteId]) {
        [self updateDetailTableViewControllerWithRows:[self prepareResponseDataForView:responseData]];
    } else if ([searchType isEqualToString:kSearchType_findDeparturesByRouteId]) {
        [self updateDetailTableViewControllerWithDepartures:[self prepareResponseDataForView:responseData]];
    }
}

- (NSArray *)prepareResponseDataForView:(NSData *)responseData
{
    NSDictionary *rawResponse = [self decodeResponseData:responseData];
    return [rawResponse objectForKey:@"rows"];
}

- (NSDictionary *)decodeResponseData:(NSData *)responseData
{
    return [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
}

- (BOOL)isResponseDataContainingResults:(NSData *)responseData
{
    BOOL isContainingResults = YES;
    NSDictionary *rawResponse = [self decodeResponseData:responseData];
    if ([[rawResponse objectForKey:@"rows"] count] == 0) {
        isContainingResults = NO;
    }
    return isContainingResults;
}

- (void)showAlertForError:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

@end
