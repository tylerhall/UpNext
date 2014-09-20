//
//  CalHelper.m
//  Up Next
//
//  Created by Tyler Hall on 9/19/14.
//  Copyright (c) 2014 Click On Tyler. All rights reserved.
//

#import "CalHelper.h"

@implementation CalHelper

+ (void)requestCalendarAccess
{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {

    }];
}

+ (EKEvent *)fetchNextEvent
{
    if(![EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent]) {
        return nil;
    }

    EKEventStore *store = [[EKEventStore alloc] init];
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    NSPredicate *predicate = [store predicateForEventsWithStartDate:now
                                                            endDate:oneYearFromNow
                                                          calendars:nil];
    
    NSArray *events = [store eventsMatchingPredicate:predicate];
    NSArray *sortedEvents = [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    
    for(EKEvent *event in sortedEvents) {
        if(!event.isAllDay) {
            return event;
        }
    }
    
    return nil;
}

+ (NSString *)relativeStringFromDate:(NSDate *)date
{
    NSTimeInterval ts = [date timeIntervalSinceNow];
    
    NSInteger remainder;
    
    NSInteger days = ts / 86400;
    remainder = ts - (86400 * days);
    
    NSInteger hours = remainder / 3600;
    remainder = remainder - (3600 * hours);
    
    NSInteger minutes = remainder / 60;

    NSString *daysString = @"";
    if(days == 1) {
        daysString = @"1 day ";
    } else if(days > 1) {
        daysString = [NSString stringWithFormat:@"%ld days ", (long)days];
    }
    
    NSString *hoursString = @"";
    if(hours == 1) {
        hoursString = @"1 hour ";
    } else if (hours > 1) {
        hoursString = [NSString stringWithFormat:@"%ld hours ", (long)hours];
    }
    
    NSString *minutesString = @"";
    if(minutes == 1) {
        minutesString = @"1 minute";
    } else if(minutes > 1) {
        minutesString = [NSString stringWithFormat:@"%ld minutes", (long)minutes];
    }

    return [NSString stringWithFormat:@"%@%@%@", daysString, hoursString, minutesString];
}

@end
