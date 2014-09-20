//
//  CalHelper.h
//  Up Next
//
//  Created by Tyler Hall on 9/19/14.
//  Copyright (c) 2014 Click On Tyler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface CalHelper : NSObject

+ (void)requestCalendarAccess;
+ (EKEvent *)fetchNextEvent;
+ (NSString *)relativeStringFromDate:(NSDate *)date;

@end
