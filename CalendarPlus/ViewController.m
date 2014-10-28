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
#import "AddEventViewController.h"

@interface ViewController ()

@end

// This is to access TSQCalendarView from this CalendarViewController?
//@interface TSQCalendarView (AccessingPrivateStuff)
//
//@property (nonatomic, readonly) UITableView *tableView; // Where is it used??
//
//@end
//

@implementation ViewController

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
    self.myCalendarView.initialVC = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GoToSecondViewController"]) {
        AddEventViewController *addEventVC = [segue destinationViewController];
        [addEventVC setInitDate:self.pickedDate];
    }
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
