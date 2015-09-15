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

- (void)testJSONService
{
    NSString *username = @"WKD4N7YMA1uiM8V";
    NSString *password = @"DtdTtzMLQlA0hk2C1Yi5pLyVIlAQ68";
    
    NSString *customHeaderField = @"X-AppGlu-Environment";
    NSString *customHeaderValue = @"staging";

    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authenticationValue = [authenticationData base64EncodedStringWithOptions:0];
    
    NSString *urlString = @"https://api.appglu.com/v1/queries/findRoutesByStopName/run";
    NSURL *URL = [NSURL URLWithString:urlString];

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"Basic %@", authenticationValue] forHTTPHeaderField:@"Authorization"];
    [request addValue:customHeaderValue forHTTPHeaderField:customHeaderField];
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setObject:@"%lauro linhares%" forKey:@"stopName"];
    
    
    NSMutableDictionary *jsonDictionary = [[NSMutableDictionary alloc] init];
    [jsonDictionary setObject:query forKey:@"params"];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  
    
    [request setHTTPBody:jsonData];
   
    
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

@end
