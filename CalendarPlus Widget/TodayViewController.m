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
    [super viewDidLoad];
    self.eventStore = [[EKEventStore alloc] init];
    self.todayEvents = [self fetchEvents];
    self.preferredContentSize = CGSizeMake(self.preferredContentSize.width, [self.todayEvents count] * 44.0);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)fetchEvents
{
    EKEventStore *eventStore = self.eventStore;
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
    NSMutableArray *reminderEvents = [[NSMutableArray alloc] init];
    
    for (int i=0; i < [todayEvents count]; i++) {
        EKEvent *event = [todayEvents objectAtIndex:i];
        if (!([event.title rangeOfString:@":!:"].location == NSNotFound)) {
            [reminderEvents addObject:[todayEvents objectAtIndex:i]];
        }
    }
    return reminderEvents;
}

// Table view related
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.todayEvents count];
}

- (IBAction)displayGestureForTapRecognizer:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *eventTitle = cell.textLabel.text;
    
    NSString *eventToRemove;
    NSError *err = nil;
    
    for (int i=0; i < [self.todayEvents count]; i++) {
        EKEvent *tmpEvent = self.todayEvents[i];
        NSString *tmpTitle = [tmpEvent.title substringFromIndex:3];
        if ([tmpTitle isEqual:eventTitle]) {
            eventToRemove = tmpEvent.eventIdentifier;
            break;
        }
    }
    
    EKEvent *toBeRemoved = [eventStore eventWithIdentifier:eventToRemove];
    [eventStore removeEvent:toBeRemoved span:EKSpanThisEvent error:&err];
    if(err){
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)displayGestureForLongPressRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    NSURL *appURL = [NSURL URLWithString:@"calendarplushome://"];
    [self.extensionContext openURL:appURL completionHandler:nil];
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
//    NSDate *startD = currentEvent.startDate;
//    NSDate *endD = currentEvent.endDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mma"];
    NSString *eventTitle = [currentEvent.title substringFromIndex:3];
    eventTitle = [NSString stringWithFormat:@"%@", eventTitle];
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
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
