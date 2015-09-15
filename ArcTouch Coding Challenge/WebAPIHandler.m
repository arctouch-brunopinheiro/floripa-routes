//
//  WebAPIHandler.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/14/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

@import UIKit;

#import "WebAPIHandler.h"

@implementation WebAPIHandler


#pragma mark - Perform Searches (public)

- (void)findRoutesByStopName:(NSString *)stopName
{
    NSMutableURLRequest *request = [self getMutableURLRequest:kUrl_findRoutesByStopName];
    NSMutableDictionary *requestDictionary = [self getRequestDictionaryForStopName:stopName];
    [self addRequestDictionary:requestDictionary ToURLRequest:request];
    [self performURLRequest:request];
}

#pragma mark - Delegates (private)

- (void)hideSpinnerOnSearchTableViewController
{

}

- (void)showSpinnerOnSearchTableViewController
{
    
}

- (void)updateSearchTableViewControllerWithRows:(NSArray *)rows
{

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

- (NSMutableDictionary *)getRequestDictionaryForStopName:(NSString *)stopName
{
    NSMutableDictionary *paramsDictionary = [[NSMutableDictionary alloc] init];
    [paramsDictionary setObject:stopName forKey:@"stopName"];
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    [requestDictionary setObject:paramsDictionary forKey:@"params"];
    return requestDictionary;
}

#pragma mark - Perform URL Request (private)

- (void)performURLRequest:(NSMutableURLRequest *)request
{
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responseCode, NSData *responseData, NSError *responseError) {
        
        
        if ([responseData length] > 0 && responseError == nil){
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        } else if ([responseData length] == 0 && responseError == nil){
            NSLog(@"data error: %@", responseError);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error accessing the data" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
        }else if (responseError != nil && responseError.code == NSURLErrorTimedOut){
            NSLog(@"data timeout: %d", NSURLErrorTimedOut);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"connection timeout" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
        }else if (responseError != nil){
            NSLog(@"data download error: %@",responseError);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"data download error" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark - Show Alerts

- (void)testJSONService
{
    NSMutableURLRequest *request = [self getMutableURLRequest:kUrl_findRoutesByStopName];
    NSMutableDictionary *requestDictionary = [self getRequestDictionaryForStopName:@"%lauro linhares%"];
    [self addRequestDictionary:requestDictionary ToURLRequest:request];
    [self performURLRequest:request];
}

@end
