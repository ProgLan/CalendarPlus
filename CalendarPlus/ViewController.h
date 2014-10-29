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
#import "AppDelegate.h"

@class PlusCalendarView;

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSCalendar *calendar;
@property (strong, nonatomic) IBOutlet PlusCalendarView *myCalendarView;
@property (strong, nonatomic) IBOutlet UITableView *calendarTable;
@property (nonatomic, strong) NSDate *pickedDate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goToDetailedView;
- (IBAction)clickGoToDetailedView:(id)sender;
@property AppDelegate *appDelegate;

@end

