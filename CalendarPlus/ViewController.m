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
    self.pickedDate = [NSDate date];
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self setUpCalendarView:self.myCalendarView];
    [self setCalendar: self.calendar];
    self.myCalendarView.initialVC = self;
    [self.myCalendarView scrollToDate:self.pickedDate animated:NO];
    
//    tableView color
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewBackground.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
}

- (IBAction)clickGoToDetailedView:(id)sender
{
    [self performSegueWithIdentifier:@"GoToSecondViewController" sender:self];
}


// Table view related
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.appDelegate.eventManager.eventsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    EKEvent *currentEvent = [self.appDelegate.eventManager.eventsList objectAtIndex:indexPath.row];
    NSDate *startD = currentEvent.startDate;
    NSDate *endD = currentEvent.endDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mma"];
    NSString *eventTitle = [NSString stringWithFormat:@"%@ - %@: %@", [dateFormatter stringFromDate:startD], [dateFormatter stringFromDate:endD], currentEvent.title];
    cell.textLabel.text = eventTitle;
    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
//    backView.backgroundColor = [UIColor clearColor];
//    cell.backgroundView = backView;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textColor = [UIColor whiteColor];
    return cell;
}
// -- Table view related

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.pickedDate != nil) {
        self.appDelegate.eventManager.eventsList = [self.appDelegate.eventManager fetchEvents:self.pickedDate];
        [self.tableView reloadData];
    }
}

@end
