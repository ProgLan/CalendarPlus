//
//  ViewController.h
//  CalendarPlus
//
//  Created by Howon Song on 10/19/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TimesSquare/TimesSquare.h>
#import <EventKit/EventKit.h>

@class PlusCalendarView;

@interface ViewController : UIViewController

@property (nonatomic, strong) NSCalendar *calendar;
@property (strong, nonatomic) IBOutlet PlusCalendarView *myCalendarView;
@property (strong, nonatomic) IBOutlet UITableView *calendarTable;
@property (nonatomic, strong) NSDate *pickedDate;
// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

@end

