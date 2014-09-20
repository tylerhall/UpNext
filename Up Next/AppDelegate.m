//
//  AppDelegate.m
//  Up Next
//
//  Created by Tyler Hall on 9/19/14.
//  Copyright (c) 2014 Click On Tyler. All rights reserved.
//

#import "AppDelegate.h"
#import "CalHelper.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSMenuItem *mnuTitle;
@property (weak) IBOutlet NSMenuItem *mnuDateTime;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self installStatusItem];
    [CalHelper requestCalendarAccess];
    [self updateMenu];

    self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(updateMenu) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)installStatusItem
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setTitle:@"No Events"];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.menu];
}

- (void)updateMenu
{
    EKEvent *event = [CalHelper fetchNextEvent];
    if(!event) {
        self.statusItem.title = @"No Events";
        self.mnuTitle.title = @"No Upcoming Event";
        self.mnuDateTime.title = @"";
    } else {
        self.statusItem.title = [CalHelper relativeStringFromDate:event.startDate];
        self.mnuTitle.title = event.title;

        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MMMM d - h:mm a";
        self.mnuDateTime.title = [df stringFromDate:event.startDate];
    }
}

@end
