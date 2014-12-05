//
//  EventManager.h
//  CalendarPlus
//
//  Created by Howon Song on 10/28/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>

@interface EventManager : NSObject

// EKEventStore instance associated with the current Calendar application
@property (strong, nonatomic) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (strong, nonatomic) EKCalendar *defaultCalendar;

// Selected date's event list
@property (nonatomic, strong) NSMutableArray *eventsList;

@property BOOL eventsAccessGranted;

- (void)checkEventStoreAccessForCalendar;
- (void)requestCalendarAccess;
- (NSMutableArray *)fetchEvents:(NSDate*)startDate;
- (void)accessGrantedForCalendar;
- (UIImage *)imageWithColor:(UIColor*)color width:(float)w height:(float)h;

@end
