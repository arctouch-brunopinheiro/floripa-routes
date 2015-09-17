//
//  DeparturesViewController.m
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/16/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#import "DeparturesViewController.h"
#import "WebAPIHandler.h"

@interface DeparturesViewController ()

@end

@implementation DeparturesViewController {

    WebAPIHandler *webAPIHandler;
    int currentRow;
    int currentColumn;
    
}

@synthesize routeId;

- (void)viewDidLoad {
    [super viewDidLoad];
    webAPIHandler = [[WebAPIHandler alloc] init];
    webAPIHandler.delegate = self;
    [webAPIHandler findDeparturesByRouteId:[routeId stringValue]];
    [self drawHeaderLabels];
    NSLog(@"ROUTEID %@", routeId);
    // Do any additional setup after loading the view.
}

- (void)drawHeaderLabels
{
    currentRow = 0;
    NSArray *headers = @[@"Weekdays", @"Saturdays", @"Sundays"];
    for (int i = 0; i < [headers count]; i++) {
        currentColumn = i;
        UILabel *headerLabel = [self getCurrentLabel];
        headerLabel.backgroundColor = [UIColor redColor];
        headerLabel.text = [headers objectAtIndex:i];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.view addSubview:headerLabel];
    }
    currentRow++;
    currentColumn = 0;
}

- (UILabel *)getCurrentLabel
{
    return [[UILabel alloc] initWithFrame:[self getFrameForCurrentLabel]];
}

- (CGRect)getFrameForCurrentLabel
{
    int labelWidth = (self.view.frame.size.width - 40) / 3;
    int labelHeight = 20;
    int labelPositionX = 10 + (currentColumn * (labelWidth + 10));
    int labelPositionY = 30 + self.navigationController.navigationBar.frame.size.height + (currentRow * (labelHeight + 10));
    return CGRectMake(labelPositionX,  labelPositionY, labelWidth, labelHeight);
}

@end
