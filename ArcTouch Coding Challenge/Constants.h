//
//  Constants.h
//  ArcTouch Coding Challenge
//
//  Created by Mike Quade on 9/14/15.
//  Copyright (c) 2015 Mike Quade. All rights reserved.
//

#ifndef ArcTouch_Coding_Challenge_Constants_h
#define ArcTouch_Coding_Challenge_Constants_h

#pragma mark - Cells

#define kCellLabelFontSize 14

#pragma mark - Departures View

#define kDeparturesLabelFontSize 12
#define kHeaderLabelFontSize 14
#define kHeaderSaturday @"Saturday"
#define kHeaderSunday @"Sunday"
#define kHeaderWeekday @"Weekday"
#define kLabelHeight 20
#define kLabelMargin 5
#define kTitleDepartures @"Departures"

#pragma mark - Spinner

#define kSpinnerLabelText @"fetching data.."
#define kSpinnerLabelTopMargin 25

#pragma mark - Web API

#define kCustomHeaderField @"X-AppGlu-Environment"
#define kCustomHeaderValue @"staging"
#define kKeyCalendar @"calendar"
#define kKeyRouteId @"routeId"
#define kKeySaturday @"SATURDAY"
#define kKeySunday @"SUNDAY"
#define kKeyStopName @"stopName"
#define kKeyTime @"time"
#define kKeyWeekday @"WEEKDAY"
#define kPassword @"DtdTtzMLQlA0hk2C1Yi5pLyVIlAQ68"
#define kSearchType_findRoutesByStopName @"findRoutesByStopName"
#define kSearchType_findDeparturesByRouteId @"findDeparturesByRouteId"
#define kSearchType_findStopsByRouteId @"findStopsByRouteId"
#define kUrl_findRoutesByStopName @"https://api.appglu.com/v1/queries/findRoutesByStopName/run"
#define kUrl_findDeparturesByRouteId @"https://api.appglu.com/v1/queries/findDeparturesByRouteId/run"
#define kUrl_findStopsByRouteId @"https://api.appglu.com/v1/queries/findStopsByRouteId/run"
#define kUsername @"WKD4N7YMA1uiM8V"

#endif
