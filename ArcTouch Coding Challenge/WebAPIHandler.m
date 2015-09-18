//
//  WebAPIHandler.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/14/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "WebAPIHandler.h"

@implementation WebAPIHandler {
    // QUESTION: Why not a property?
    NSString *searchType;

}
// QUESTION: Why are you synthesizing this property?
@synthesize delegate;

#pragma mark - Perform Searches (public)

- (void)findRoutesByStopName:(NSString *)stopName
{
    searchType = kSearchType_findRoutesByStopName;
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

- (void)updateSearchTableViewControllerWithRows:(NSArray *)rows
{
    if([delegate respondsToSelector:@selector(updateSearchTableViewControllerWithRows:)]) {
        [delegate updateSearchTableViewControllerWithRows:rows];
    }
}

- (void)updateStopsTableViewControllerWithRows:(NSArray *)rows
{
    if([delegate respondsToSelector:@selector(updateStopsTableViewControllerWithRows:)]) {
        [delegate updateStopsTableViewControllerWithRows:rows];
    }
}

- (void)updateDeparturesViewControllerWithRows:(NSArray *)rows
{
    if([delegate respondsToSelector:@selector(updateDeparturesViewControllerWithRows:)]) {
        [delegate updateDeparturesViewControllerWithRows:rows];
    }
}

- (void)requestDidFail
{
    if([delegate respondsToSelector:@selector(requestDidFail)]) {
        [delegate requestDidFail];
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
// FIXME: method names starting with "get" are unusual and the parameter is not expressed in this name either.
// A better name here could be: mutableRequestWithURLString:(NSString *)urlString
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
    // FIXME: "CustomHeader" is not a name that makes clear what is being passed here
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
            if (![self isResponseDataContainingResults:responseData]) { // FIXME: 'isEmptyResponse' would be more clear about the intention here
                [self showAlertForError:@"The search returned no results"];
                [self requestDidFail];// QUESTION: By reading this method name I suppose by the context that we are propagating the failure, but the intention of the method is not really clear. Can you think of a better name?
            } else {
                [self returnResponseDataToView:responseData];
            }
        } else if ([responseData length] == 0 && responseError == nil){
            // QUESTION: Is that ok for this class to be spawning alerts? Why?
            [self showAlertForError:@"The data could not be accessed"];
            [self requestDidFail];
        } else if (responseError != nil && responseError.code == NSURLErrorTimedOut){
            [self showAlertForError:@"The connection timed out"];
            [self requestDidFail];
        } else if (responseError != nil){
            [self showAlertForError:@"The data could not be downloaded"];
            [self requestDidFail];
        }
        // QUESTION: Nested if/elses make it very hard to understand the flow of the program. Any alternative?
    }];
}

#pragma mark - Handling URL Response (private)
// QUESTION: How do you know it is a view or view controller who is going to receive the data? (I know it was you who implemented the caller too, but let's assume the general case :P)
// QUESTION: Can you tell me why this is not a good name?
- (void)returnResponseDataToView:(NSData *)responseData
{
    // QUESTION: How else could you handle this without using strings?
    if ([searchType isEqualToString:kSearchType_findRoutesByStopName]) {
        [self updateSearchTableViewControllerWithRows:[self prepareResponseDataForView:responseData]];
    } else if ([searchType isEqualToString:kSearchType_findStopsByRouteId]) {
        [self updateStopsTableViewControllerWithRows:[self prepareResponseDataForView:responseData]];
    } else if ([searchType isEqualToString:kSearchType_findDeparturesByRouteId]) {
        [self updateDeparturesViewControllerWithRows:[self prepareResponseDataForView:responseData]];
    }
}
// QUESTION: What are exactly the responsibilities of this class? Is this method according to them? Why?
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
