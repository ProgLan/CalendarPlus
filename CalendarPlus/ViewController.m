//
//  ViewController.m
//  CalendarPlus
//
//  Created by Howon Song on 10/19/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "ViewController.h"
#import "CalendarRowCellViewController.h"
#import "PlusCalendarView.h"
@import EventKit;

@interface ViewController ()

// The database with calendar events and reminders
@property (strong, nonatomic) EKEventStore *eventStore;

// Indicates whether app has access to event store.
@property (nonatomic) BOOL isAccessToEventStoreGranted;

// The data source for the table view
@property (strong, nonatomic) NSMutableArray *todoItems;

@end

// This is to access TSQCalendarView from this CalendarViewController?
//@interface TSQCalendarView (AccessingPrivateStuff)
//
//@property (nonatomic, readonly) UITableView *tableView; // Where is it used??
//
//@end
//

@implementation ViewController

// FROM THE COOKBOOK

//how Is this a function???
- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

- (void)updateAuthorizationStatusToAccessEventStore {
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    switch (authorizationStatus) {
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"This app doesn't have access to your Reminders." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
            [self.calendarTable reloadData];
            break;
        }
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            [self.calendarTable reloadData];
            break;
        case EKAuthorizationStatusNotDetermined: {
            __weak ViewController *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    weakSelf.isAccessToEventStoreGranted = granted;
                                                    [weakSelf.calendarTable reloadData];
                                                });
                                            }];
            break;
        }
    }
}

// COOKBOOKE ENDS

- (void)setCalendar:(NSCalendar *)calendar;
{
    _calendar = calendar; // what is this? what kind of variable is _variable_name?
//    self.navigationItem.title = calendar.calendarIdentifier;
//    self.tabBarItem.title = calendar.calendarIdentifier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCalendarView:self.myCalendarView];
    [self setCalendar: self.calendar];
    [self updateAuthorizationStatusToAccessEventStore]; // grants access
    self.myCalendarView.initialVC = self;
}

- (void)setUpCalendarView:(TSQCalendarView *) calendarView {
    calendarView.calendar = self.calendar;
    calendarView.rowCellClass = [CalendarRowCellViewController class];
    calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 1];
    calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 5];
    calendarView.backgroundColor = [UIColor colorWithRed:0.84f green:0.85f blue:0.86f alpha:1.0f];
    calendarView.pagingEnabled = YES;
    CGFloat onePixel = 3.0f / [UIScreen mainScreen].scale;
    calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
