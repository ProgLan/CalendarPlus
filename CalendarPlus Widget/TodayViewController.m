//
//  TodayViewController.m
//  CalendarPlus Widget
//
//  Created by Howon Song on 12/12/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "EventManager.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    NSLog(@"view did load");
    [super viewDidLoad];
    self.todayEvents = [self fetchEvents];
    for (int i = 0; i < [self.todayEvents count]; i++) {
        EKEvent *event = [self.todayEvents objectAtIndex:i];
        NSLog(@"title: %@", event.title);
//        NSLog(@"startDate: %@", event.startDate);
//        NSLog(@"endDate: %@", event.endDate);
//        NSLog(@"eventIdentifier: %@", event.eventIdentifier);
//        NSLog(@"availability: %d", event.availability);
    }
//    NSLog(@"todayEvents: %@", todayEvents);
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)fetchEvents
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKCalendar *calendar = eventStore.defaultCalendarForNewEvents;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *today = [NSDate date];
    NSDate *startDate = [gregorian dateBySettingHour:0 minute:0 second:0 ofDate:today options:0];
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.day = 1;
    NSDate *endDate = [gregorian dateByAddingComponents:tomorrowDateComponents
                                                 toDate:startDate
                                                options:0];
    NSMutableArray *todayEvents = [[NSMutableArray alloc] init];
    NSArray *calendarArray = [NSArray arrayWithObject:calendar];
    
    
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate
                                                                 endDate:endDate
                                                               calendars:calendarArray];
    todayEvents = [NSMutableArray arrayWithArray:[eventStore eventsMatchingPredicate:predicate]];
    return todayEvents;
}

// Table view related
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.todayEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowATIndexPath is called??");
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    EKEvent *currentEvent = [self.todayEvents objectAtIndex:indexPath.row];
    NSDate *startD = currentEvent.startDate;
    NSDate *endD = currentEvent.endDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mma"];
    NSString *eventTitle = currentEvent.title;
    
    //NSString *eventTitle = [NSString stringWithFormat:@"%@ - %@: %@", [dateFormatter stringFromDate:startD], [dateFormatter stringFromDate:endD], currentEvent.title];
    cell.textLabel.text = eventTitle;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}
// -- Table view related

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    // Perform any setup necessary in order to update the view.
//    NSLog(@"widgetPErformUpdate");
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.CalendarPlus"];
//    NSMutableArray *calendars = [[NSMutableArray alloc] init];
//    calendars = [sharedDefaults objectForKey:@"calendars"];
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
