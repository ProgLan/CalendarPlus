//
//  AddEventViewController.m
//  CalendarPlus
//
//  Created by Howon Song on 10/27/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "AddEventViewController.h"
#import "AppDelegate.h"
#import "CalendarRowCellViewController.h"
#import "Utils.h"

@interface AddEventViewController ()

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventTitle.delegate = self;
    self.STARTDATELABEL = @"startDateSelected";
    self.STARTDATELABEL = @"endDateSelected";
    
    // Set button backgrounds
    UIImage *buttonImage = [[UIImage imageNamed:@"btn_carrot.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"btn_light_carrot.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.startDateButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.startDateButton setBackgroundImage:buttonImageHighlight forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [self.endDateButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.endDateButton setBackgroundImage:buttonImageHighlight forState:(UIControlStateHighlighted | UIControlStateSelected)];
    // Set button backgrounds Done
    
    [self setDateLables:self.firstDate];
    self.eventStore = [[EKEventStore alloc] init];
    
    
    
//    self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];
    self.addEventButton.enabled = NO;
    
//    graph related
//    [self setupGraphView];
    
    // CALENDAR RELATED
    [self setUpCalendarView:self.smallCalendarView];
    [self.smallCalendarView scrollToDate:self.firstDate animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // how come this method is not called??
    [appDelegate.eventManager checkEventStoreAccessForCalendar];
    if (appDelegate.eventManager.eventsAccessGranted) {
        self.addEventButton.enabled = YES;
        NSLog(@"event access granted");
    } else {
        NSLog(@"no permission");
    }
    [self.eventTitle becomeFirstResponder];
}

- (void)setInitDate:(NSDate *)pickedDate
{
    self.firstDate = pickedDate;
}

- (void)setDateLables:(NSDate*)firstSelectedDate
{
    [self.datePicker setDate:firstSelectedDate];
    NSDate *startDate = firstSelectedDate;
    NSTimeInterval anHourAfter = 1 * 60 * 60;
    NSDate *endDate = [startDate dateByAddingTimeInterval:anHourAfter];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd hh:mma"];
//    self.eventStartDate = startDate;
//    self.eventEndDate = endDate;
    self.startDateLabel.text = [dateFormatter stringFromDate:startDate];
    self.endDateLabel.text = [dateFormatter stringFromDate:endDate];
//    [self.smallCalendarView scrollToDate:endDate animated:NO];
}

- (IBAction)addEventBtnPressed:(id)sender
{
    EKEvent *myEvent = [EKEvent eventWithEventStore:self.eventStore];
    myEvent.title = self.eventTitle.text;
    myEvent.startDate = self.eventStartDate;
    myEvent.endDate = self.eventEndDate;
    myEvent.allDay = NO;
    
    [myEvent setCalendar:[self.eventStore defaultCalendarForNewEvents]];
    
    NSError *err;
    [self.eventStore saveEvent:myEvent span:EKSpanThisEvent error:&err];
    
    if (err) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Invalid input"
                              delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// This method is called when the user has granted permission to Calendar
-(void)accessGrantedForCalendar
{
    // Let's get the default calendar associated with our event store
    self.defaultCalendar = self.eventStore.defaultCalendarForNewEvents;
    // Enable the Add button
    self.addEventButton.enabled = YES;
//    // Fetch all events happening in the next 24 hours and put them into eventsList
//    self.eventsList = [self fetchEvents];
//    // Update the UI with the above events
//    [self.tableView reloadData];
}

// Fetch all events happening in the next 24 hours
- (NSMutableArray *)fetchEvents
{
    NSDate *startDate = [NSDate date];
    
    //Create the end date components
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.day = 1;
    
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
    // We will only search the default calendar for our events
    NSArray *calendarArray = [NSArray arrayWithObject:self.defaultCalendar];
    
    // Create the predicate
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:calendarArray];
    
    // Fetch all events that match the predicate
    NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    
    return events;
}

// Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             NSLog(@"yay we have permission");
             AddEventViewController * __weak weakSelf = self;
             // Let's ensure that our code will be executed from the main queue
             dispatch_async(dispatch_get_main_queue(), ^{
                 // The user has granted access to their Calendar; let's populate our UI with all events occuring in the next 24 hours.
                 [weakSelf accessGrantedForCalendar];
             });
         } else {
             NSLog(@"we dont have permission");
         }
     }];
}

// Check the authorization status of our application for Calendar
-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    NSLog(@"check Event Store AccessForCalendar");
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startDateButtonTapped:(id)sender {
    [self textFieldShouldReturn:self.eventTitle];
    self.startDateButton.selected = YES;
    self.datePicker.hidden = NO;
    self.currentDateLabel = self.STARTDATELABEL;
}

- (IBAction)endDateButtonTapped:(id)sender {
    [self textFieldShouldReturn:self.eventTitle];
    self.endDateButton.selected = YES;
    self.endDateButton.highlighted = YES;
    self.datePicker.hidden = NO;
    self.currentDateLabel = self.ENDDATELABEL;
}

// the user picked the date using the datepicker
- (IBAction)dateSelected:(id)sender {
    
    NSDate *dateSelected = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd hh:mma"];
    UIButton *dateCellButton = (UIButton *)[self.smallCalendarView viewWithTag:[dateSelected timeIntervalSince1970]];

    if (self.currentDateLabel == self.STARTDATELABEL) {
        self.eventStartDate = dateSelected;
        self.startDateLabel.text = [dateFormatter stringFromDate:dateSelected];
//        [self.smallCalendarView setSelectedDate:dateSelected];
        [dateCellButton setBackgroundColor: [UIColor redColor]];
        
        
    } else if (self.currentDateLabel == self.ENDDATELABEL) {
        self.eventEndDate = dateSelected;
        self.endDateLabel.text = [dateFormatter stringFromDate:dateSelected];
        [dateCellButton setBackgroundColor: [UIColor blueColor]];
//        [dateCellButton setBackgroundColor: [UIColor clearColor]];
    }
    self.datePicker.hidden = YES;
    
    NSLog(@"dateSelected: %@", dateSelected);
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

static CGPoint midPointForPoints(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

- (IBAction)displayGestureForTapRecognizer:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    NSLog(@"Touch location: %@", NSStringFromCGPoint(location));
    
    if (self.currentGraph != nil) {
        [self.currentGraph removeFromSuperlayer];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    self.currentGraph = shapeLayer;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor grayColor].CGColor;
    shapeLayer.lineWidth = 1.0;
    [self.view.layer addSublayer:shapeLayer];
    
    float xStart = 0.0;
    float xEnd = 370.0;
    float xRange = xEnd - xStart;
    
    NSDateComponents *startDateComponents = [self.calendar components:(NSCalendarUnitDay) fromDate:self.eventStartDate];
    NSInteger startDay = [startDateComponents day];
    NSDateComponents *endDateComponents = [self.calendar components:(NSCalendarUnitDay) fromDate:self.eventEndDate];
    NSInteger endDay = [endDateComponents day];
    
//    NSLog(@"startDay: %ld", (long)startDay);
//    NSLog(@"endDay: %ld", (long)endDay);
    
    NSInteger numDatesSelected = endDay - startDay + 1;
    float tickInterval = xRange / numDatesSelected;
    
//    NSLog(@"tickInterval %f", tickInterval);
    
    CGPoint origin = CGPointMake(xStart, 620.0);
    CGPoint endpt = CGPointMake(xEnd, 620.0);
    CGPoint midpt1 = midPointForPoints(origin, location);
    CGPoint midpt2 = midPointForPoints(location, endpt);
    CGPoint ctrlpt1 = CGPointMake(midpt1.x, midpt1.y+50);
    CGPoint ctrlpt2 = CGPointMake(midpt2.x, midpt2.y+50);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:origin];
    [path addQuadCurveToPoint:location controlPoint:ctrlpt1]; //ctrlpt1
    [path addQuadCurveToPoint:endpt controlPoint:ctrlpt2]; //ctrlpt2
    [shapeLayer setPath:path.CGPath];
    
//    Represent the workload on the calendar
    
    //Get a range of NSDate objects
    NSDate *currentDate = [self.eventStartDate copy];
    NSMutableArray *selectedDates = [[NSMutableArray alloc] init];
    NSMutableArray *fillHeightsArr = [[NSMutableArray alloc] init];
//    [selectedDates addObject:currentDate];
    float xPointOnBezierPath = 0.0;
    for (int i = 0; i < numDatesSelected; i++) {
        [selectedDates addObject:currentDate];
        NSDateComponents *aDayDiff = [[NSDateComponents alloc] init];
        aDayDiff.day = 1;
        NSDate *aDayAfter = [[NSCalendar currentCalendar] dateByAddingComponents:aDayDiff
                                                                          toDate:currentDate
                                                                         options:0];
        currentDate = aDayAfter;
        float prevXPoint = xPointOnBezierPath;
        xPointOnBezierPath = xPointOnBezierPath + tickInterval;
        float y1Beizer = [self getYFromBezierPath:prevXPoint location:location ctrlpt1:ctrlpt1 ctrlpt2:ctrlpt2 startpt:origin endpt:endpt];
        float y2Beizer = [self getYFromBezierPath:xPointOnBezierPath location:location ctrlpt1:ctrlpt1 ctrlpt2:ctrlpt2 startpt:origin endpt:endpt];
        float avgY1Y2 = (y1Beizer + y2Beizer) / 2.0;
        float fillHeightFromY1Y2 = origin.y - avgY1Y2;
        NSNumber *fhNum = [NSNumber numberWithFloat:fillHeightFromY1Y2];
        [fillHeightsArr addObject:fhNum];
    }
    NSLog(@"dates: %@", selectedDates);
    UIButton *firstButton = (UIButton *)[self.smallCalendarView viewWithTag:[[selectedDates objectAtIndex:0] timeIntervalSince1970]];
    float btnWidth = firstButton.frame.size.width;
    float btnHeight = firstButton.frame.size.height;
    fillHeightsArr = [self normalizeAndScale: fillHeightsArr btnHeight:btnHeight];
    for (int i = 0; i < numDatesSelected; i++) {
        UIButton *myButton = (UIButton *)[self.smallCalendarView viewWithTag:[[selectedDates objectAtIndex:i] timeIntervalSince1970]];
        float fillHeight = [fillHeightsArr[i] floatValue];
        UIImage *img = [self imageWithColor:[UIColor greenColor] buttonWidth:btnWidth buttonHeight:btnHeight fillHeight:fillHeight];
        [myButton setImage:img forState:UIControlStateNormal];
        [myButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -53.5, 0.0, 0.0)];
        [myButton setTitle:myButton.titleLabel.text forState:UIControlStateNormal];
    }
}

- (float)getYFromBezierPath:(float)x location:(CGPoint)location ctrlpt1:(CGPoint)ctrlpt1 ctrlpt2:(CGPoint)ctrlpt2 startpt:(CGPoint)startpt endpt:(CGPoint)endpt {
    float yVal;
    float tVal;
    if (x <= location.x) {
        tVal = [self getTvalFromBezierPath:x x0Val:startpt.x x1Val:ctrlpt1.x x2Val:location.x];
        yVal = [self getCoordFromBezierPath:tVal origin:startpt.y p1Val:ctrlpt1.y p2Val:location.y];
    } else {
        tVal = [self getTvalFromBezierPath:x x0Val:location.x x1Val:ctrlpt2.x x2Val:endpt.x];
        yVal = [self getCoordFromBezierPath:tVal origin:location.y p1Val:ctrlpt2.y p2Val:endpt.y];
    }
    return yVal;
}

- (NSMutableArray*)normalizeAndScale:(NSMutableArray*)nums btnHeight:(float)btnHeight {
    int length = [nums count];
    float max = [[nums valueForKeyPath:@"@max.floatValue"] floatValue];
    //NSNumber *sum = [nums valueForKeyPath:@"@sum.self"];
    //float sumFloat = [sum floatValue];
    for (int i=0; i<length; i++) {
        float num = [[nums objectAtIndex:i] floatValue];
        float normed_num = num / max;
        float scaled = normed_num * btnHeight;
        NSNumber *num_ns = [NSNumber numberWithFloat:scaled];
        [nums replaceObjectAtIndex:i withObject:num_ns];
    }
    return nums;
}

- (float)getTvalFromBezierPath:(float)x x0Val:(float)x0 x1Val:(float)x1 x2Val:(float)x2 {
//    NSLog(@"getTval: x: %f, x0: %f, x1: %f, x2: %f", x, x0, x1, x2);
    float tVal = (x-x0)/(2*(x1-x0));
    return tVal;
}

- (float)getCoordFromBezierPath:(float)t origin: (float)origin p1Val: (float)p1 p2Val: (float)p2 {
// tVal = (sqrt((-2.0 * x * x1) + (x * x0) + (x * x2) + pow(x1, 2) - (x0 * x2)) + x0 - x1) / (x0 - (2.0 * x1) + x2);
//    NSLog(@"v1: %f, v2: %f, v3: %f", (pow((1-t),2) * origin), (2 * t * (1-t) * p1), (pow(t,2) * p2));
    return (pow((1-t),2) * origin) + (2 * t * (1-t) * p1) + (pow(t,2) * p2);
}

//SmallCalendarView related

- (UIImage *)imageWithColor:(UIColor *)color buttonWidth:(float)bw buttonHeight:(float)bh fillHeight:(float)fh {
//    float heightOffset = btnHeight - h;
//    NSLog(@"btn height %f", h);
//    NSLog(@"height offset %f", heightOffset);
    CGRect rect = CGRectMake(0, 0, bw, bh);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGRect innerRect = CGRectMake(0 , bw - fh, bw, fh);
    [color setFill];
    UIRectFill(innerRect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setUpCalendarView:(TSQCalendarView *) calendarView {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendar = gregorian;
    calendarView.calendar = self.calendar;
    calendarView.rowCellClass = [CalendarRowCellViewController class];
    calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 1];
    calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 5];
    calendarView.backgroundColor = [UIColor colorWithRed:0.84f green:0.85f blue:0.86f alpha:1.0f];
    calendarView.pagingEnabled = YES;

//    CGFloat onePixel = 0.5f / [UIScreen mainScreen].scale;
    calendarView.contentInset = UIEdgeInsetsMake(0.0f, 0, 0.0f, 0);
    
}

@end
