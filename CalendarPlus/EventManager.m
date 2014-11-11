//
//  EventManager.m
//  CalendarPlus
//
//  Created by Howon Song on 10/28/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "EventManager.h"
#import <UIKit/UIKit.h> //FIXME: is it okay to import UIKit from a model?

@implementation EventManager

// Check the authorization status of our application for Calendar
-(instancetype)init
{
    self = [super init];
    self.eventStore = [[EKEventStore alloc] init];
    self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];
    [self checkEventStoreAccessForCalendar];
    [self requestCalendarAccess];
    return self;
}

-(void)checkEventStoreAccessForCalendar
{
    NSLog(@"checking event store for permission");
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status)
    {
        // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

-(void)requestCalendarAccess
{
    NSLog(@"requestCalendarAccess");
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             NSLog(@"access granted!");
             self.eventsAccessGranted = granted;
             [self accessGrantedForCalendar];
         } else {
             NSLog(@"Use disallowed access to calendar");
         }
     }];
}

// Fetch all events happening in the next 24 hours
- (NSMutableArray *)fetchEvents: (NSDate*)startDate
{
    startDate = [[NSCalendar currentCalendar] dateBySettingHour:0 minute:0 second:0 ofDate:startDate options:0];
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.day = 1;
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
    // We will only search the default calendar for our events
    NSArray *calendarArray = [NSArray arrayWithObject:self.defaultCalendar];
//    NSLog(@"startDate? %@", startDate);
//    NSLog(@"endDate? %@", endDate);
    
    // Create the predicate
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:calendarArray];
    NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    return events;
}

// This method is called when the user has granted permission to Calendar
-(void)accessGrantedForCalendar
{
//    NSLog(@"accessGrantedForCalendar called");
    self.defaultCalendar = self.eventStore.defaultCalendarForNewEvents;
    self.eventsAccessGranted = YES;
}


@end
