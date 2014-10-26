//
//  CalendarViewController.m
//  CalendarPlus
//
//  Created by Howon Song on 10/19/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarRowCellViewController.h"
#import <TimesSquare/TimesSquare.h>

@interface CalendarViewController ()

//@property (nonatomic, retain) NSTimer *timer; // not sure why it's needed yet.

@end


// This is to access TSQCalendarView from this CaeldnarViewController?
@interface TSQCalendarView (AccessingPrivateStuff)

@property (nonatomic, readonly) UITableView *tableView; // Where is it used??

@end

//


@implementation CalendarViewController

- (void)setCalendar:(NSCalendar *)calendar;
{
    _calendar = calendar; // what is this? what kind of variable is _variable_name?
    
    self.navigationItem.title = calendar.calendarIdentifier;
    self.tabBarItem.title = calendar.calendarIdentifier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    TSQCalendarView *calendarView = [[TSQCalendarView alloc] init];
//    calendarView.calendar = self.calendar;
//    calendarView.rowCellClass = [CalendarRowCellViewController class];
//    calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 1];
//    calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 5];
//    calendarView.backgroundColor = [UIColor colorWithRed:0.84f green:0.85f blue:0.86f alpha:1.0f];
//    calendarView.pagingEnabled = YES;
//    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
//    calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);
//    
//    self.view = calendarView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
