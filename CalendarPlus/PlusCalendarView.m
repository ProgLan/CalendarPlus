//
//  PlusCalendarView.m
//  CalendarPlus
//
//  Created by Howon Song on 10/26/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "PlusCalendarView.h"
#import "AppDelegate.h"

@implementation PlusCalendarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSelectedDate:(NSDate *)newSelectedDate; {
    [super setSelectedDate:newSelectedDate];
    self.initialVC.pickedDate = newSelectedDate; // store this variable for prepareForSegue method
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.eventManager.eventsList = [appDelegate.eventManager fetchEvents:newSelectedDate];
    [self.initialVC.tableView reloadData];
}

@end
