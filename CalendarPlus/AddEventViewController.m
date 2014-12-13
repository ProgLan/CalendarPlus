//
//  AddEventViewController.m
//  CalendarPlus
//
//  Created by Howon Song on 10/27/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "AddEventViewController.h"
#import "AppDelegate.h"
#import "AddEventRowCellController.h"

@interface AddEventViewController ()

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.utils = [[Utils alloc] init];
    self.eventTitle.delegate = self;
    self.STARTDATELABEL = @"startDateSelected";
    self.STARTDATELABEL = @"endDateSelected";
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.availableHours = 8;
    self.maxBtnHeight = 37.0; //FIXME: hardcoded values: can be found in AddCalendarEventRowController
    self.maxBtnWidth = 53.5;
    
    [self setDateLables:self.firstDate endDate:self.eventEndDate];
    self.eventStore = [[EKEventStore alloc] init];
    
    // HOWON 12/10/14 see if sharing this with todayWidget works
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.CalendarPlus"];
    [sharedDefaults setObject:@"hello there" forKey:@"helloString"];
    
    self.reminderDurations = [[NSMutableArray alloc] initWithCapacity:0];
    self.eventDurations = [[NSMutableArray alloc] initWithCapacity:0];
//    self.selectedDates = [[NSMutableArray alloc] initWithCapacity:0];
    
//    self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];
    self.addEventButton.enabled = NO;
    // CALENDAR RELATED
    [self setUpCalendarView:self.smallCalendarView];
    [self.smallCalendarView scrollToDate:self.firstDate animated:NO];
    
    self.coloredButtons = [[NSMutableArray alloc] init];
    self.datePicker.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
//    NSLog(@"labelContainer before init: %@", self.tickDateLabelContainer);
    self.tickDateLabelContainer = [[UIView alloc] init];
//    NSLog(@"labelContainer after init: %@", self.tickDateLabelContainer);
//    self.tickDateLabels = [[NSMutableArray alloc] init];
    // labels
//    UILabel *hrLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 600, 50, 20)];
//    [hrLabel setTextColor:[UIColor blackColor]];
//    [hrLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
//    hrLabel.text = @"10hrs";
//    [self.view addSubview:hrLabel];
    
    self.storedFillHeights = [[NSMutableDictionary alloc] init];
}


- (void)markExistingEvents {
//    NSLog(@"mark existing events starts");
    UIColor *pinkBtnColor = [self.utils colorFromHexString:@"#D2527F"];
    UIColor *greyBtnColor = [self.utils colorFromHexString:@"#6C7A89"];
    NSDate* startDate = self.eventStartDate;
//    NSLog(@"startDate: %@", startDate);
    NSDateComponents *dateComponents = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:startDate];
    [dateComponents setDay:1];
    [dateComponents setHour:0];
    startDate = [self.calendar dateFromComponents:dateComponents];
    NSDate* currentDate = startDate;
    for (int i = 0; i < 30; i++) { //FIXME: find either 30 or 31
        NSMutableArray* events = [[NSMutableArray alloc] init];
        events = [self.appDelegate.eventManager fetchEvents:currentDate];
        int numEvents = (int)[events count];
        NSTimeInterval timeOfAllEvents = 0;
        for (int j = 0; j < numEvents; j++) {
            EKEvent *event = [events objectAtIndex:j];
            NSTimeInterval diff = [event.endDate timeIntervalSinceDate:event.startDate];
            timeOfAllEvents += diff;
        }
        float numOccupiedHours = (float)floor(timeOfAllEvents/3600);
        if (numOccupiedHours > 0.0) {
            float fillHeight = (numOccupiedHours / (float)self.availableHours) * self.maxBtnHeight;
            UIImage *btnImg;
            
            if (fillHeight >= self.maxBtnHeight) {
                fillHeight = self.maxBtnHeight;
            }
            btnImg = [self imageWithColor:greyBtnColor buttonWidth:self.maxBtnWidth buttonHeight:self.maxBtnHeight fillHeight:fillHeight];
            
            int btnTag = [currentDate timeIntervalSince1970];
            UIButton *myButton = (UIButton *)[self.smallCalendarView viewWithTag:btnTag];
            [myButton setImage:btnImg forState:UIControlStateNormal];
            [myButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -53.5, 0.0, 0.0)];
            [myButton setTitle:myButton.titleLabel.text forState:UIControlStateNormal];
            
            NSNumber *btnTagNumber = [NSNumber numberWithInt:btnTag]; // btnTag = [currentDate timeIntervalSince1970];
            NSNumber *value = [self.storedFillHeights objectForKey:btnTagNumber];
            [self.storedFillHeights setObject:[NSNumber numberWithFloat:fillHeight] forKey:btnTagNumber];
            
//            [self.storedFillHeights setObject:[NSNumber numberWithFloat: fillHeight] atIndexedSubscript:i];
            
        }
        currentDate = [self makeTomorrowDate:currentDate];
    }
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
    [self markExistingEvents];
}

- (void)setInitDate:(NSDate *)pickedDate
{
    self.firstDate = pickedDate;
    // I don't see a diff between eventStartDate and firstDate..
    // FIXME later
    self.eventStartDate = pickedDate;
    self.eventEndDate = [self makeTomorrowDate:pickedDate];
}

- (void)setDateLables:(NSDate*)firstSelectedDate endDate:(NSDate*)endDate
{
    [self.datePicker setDate:firstSelectedDate];
    NSDate *startDate = firstSelectedDate;
//    NSTimeInterval anHourAfter = 1 * 60 * 60;
//    NSDate *endDate = [startDate dateByAddingTimeInterval:anHourAfter];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd hh:mma"];
    self.startDateLabel.text = [dateFormatter stringFromDate:startDate];
    self.endDateLabel.text = [dateFormatter stringFromDate:endDate];
}

- (void)addReminder:(NSString*)title startDateComps:(NSDateComponents*)startDateComps dueDateComps:(NSDateComponents*)dueDateComps {
//    FIXME: right now, we just add a reminder naively: when there's an open timeslot for a certain duration, we add it.
    // or.. let's just add at 00:00 for now.
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
    reminder.title = title;
//    NSLog(@"log: year: %ld, month: %ld, day: %ld", (long)startDateComps.year, (long)startDateComps.month, (long)startDateComps.day);
    reminder.startDateComponents = startDateComps;
    reminder.dueDateComponents = dueDateComps;
    [reminder setCalendar:[self.eventStore defaultCalendarForNewReminders]];
    NSError *err;
    [self.eventStore saveReminder:reminder commit:YES error:&err];
    if (err) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Invalid reminder!"
                              delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        [alert show];
    } else {
        // reminder doesn't have to redirect to the previous view
        //        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addEvent:(NSString*)eventTitle startDate:(NSDate*)startDate endDate:(NSDate*)endDate isReminder:(BOOL)isReminder
{
    NSLog(@"addEvent starts");
    EKEvent *myEvent = [EKEvent eventWithEventStore:self.eventStore];
    [myEvent setCalendar:[self.eventStore defaultCalendarForNewEvents]];
    
    if (isReminder) {
        eventTitle = [NSString stringWithFormat:@":!: %@", eventTitle];
    }
    
    myEvent.title = eventTitle;
    myEvent.startDate = startDate;
    myEvent.endDate = endDate;
    myEvent.allDay = NO;
    
    NSLog(@"title: %@", eventTitle);
    NSLog(@"startDate: %@", startDate);
    NSLog(@"endDate: %@", endDate);
    
    NSError *err;
    [self.eventStore saveEvent:myEvent span:EKSpanThisEvent error:&err];
    
    if (err) {
        NSLog(@"err?: %@", err);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Invalid input hi there"
                              delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"added an event! %@", eventTitle);
}

- (IBAction)addEventBtnPressed:(id)sender
{
    //[self addEvent:self.eventTitle.text startDate:self.eventStartDate endDate:self.eventEndDate isReminder:NO];
    [self addEvents:self.eventTitle.text selectedDates:self.selectedDates eventDurations:self.eventDurations];
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

- (NSDate*)makeTomorrowDate:(NSDate*)startDate
{
    //Create the end date components
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.day = 1;
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
    return endDate;
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

- (IBAction)endDateButtonTapped:(id)sender {
    [self textFieldShouldReturn:self.eventTitle];
    self.endDateButton.selected = YES;
    self.endDateButton.highlighted = YES;
    self.datePicker.hidden = NO;
    self.currentDateLabel = self.ENDDATELABEL;
//    self.graphView.hidden = YES;
    if (self.currentGraph != nil) {
        [self.currentGraph removeFromSuperlayer];
    }
}

// the user picked the date using the datepicker (the scrolling datepicker)
- (IBAction)dateSelected:(id)sender {
    
    NSDate *dateSelected = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd hh:mma"];
    
    UIButton *dateCellButton = (UIButton *)[self.smallCalendarView viewWithTag:[dateSelected timeIntervalSince1970]];

    if (self.currentDateLabel == self.STARTDATELABEL) {
        self.eventStartDate = dateSelected;
        self.startDateLabel.text = [dateFormatter stringFromDate:dateSelected];
        
    } else if (self.currentDateLabel == self.ENDDATELABEL) {
        self.eventEndDate = dateSelected;
        self.endDateLabel.text = [dateFormatter stringFromDate:dateSelected];
//        [dateCellButton setBackgroundColor: [UIColor blueColor]];
    }
    self.datePicker.hidden = YES;
//    self.graphView.hidden = NO;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

static CGPoint midPointForPoints(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

- (NSMutableArray*)distributeWorkload:(int)arrSize transformingScale:(float)tfScale btnHeight:(float)btnHeight {
    NSMutableArray *fillHeightsArr = [[NSMutableArray alloc] init];
    float fillHeight = tfScale * btnHeight;
    NSNumber *fhNum = [NSNumber numberWithFloat:fillHeight];
    for (int i = 0; i < arrSize; i++) {
        [fillHeightsArr addObject:fhNum];
    }
    return fillHeightsArr;
}

- (NSMutableArray*)populateSelectedDates:(NSDate *)currentDate numSelectedDates:(int)numDatesSelected {
    NSMutableArray *selectedDates = [[NSMutableArray alloc] init];
    for (int i = 0; i < numDatesSelected; i++) {
        [selectedDates addObject:currentDate];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d"];
        //
        NSDateComponents *aDayDiff = [[NSDateComponents alloc] init];
        aDayDiff.day = 1;
        NSDate *aDayAfter = [[NSCalendar currentCalendar] dateByAddingComponents:aDayDiff
                                                                          toDate:currentDate
                                                                         options:0];
        currentDate = aDayAfter;
    }
    return selectedDates;
}

- (void)drawCircle:(CGPoint)location {
    if (self.currentCircle != nil) {
        [self.currentCircle removeFromSuperlayer];
    }
    
    int radius = 10;
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    
//    circle.position = CGPointMake(circleX, circleY);
    circle.position = CGPointMake(location.x-radius, location.y-radius);
    circle.fillColor = [self.utils colorFromHexString:@"#1abc9c"].CGColor;
    circle.strokeColor = [self.utils colorFromHexString:@"#16a085"].CGColor;
    circle.lineWidth = 2;
    
    self.currentCircle = circle;
    [self.view.layer addSublayer:circle];
}

- (float)calculateWorkload:(float)locY maxY:(float)maxY yRange:(float)yRange maxHours:(float)maxHours {
    float workload;
    if (locY > maxY) {
        workload = 0.0;
        return workload;
    }
    workload = ((maxY - locY) / yRange) * maxHours;
    return workload;
}


- (void)drawWorkloadGraph:(CGPoint)location recognizerState:(UIGestureRecognizerState)recognizerState {
    NSDateComponents *startDateComponents = [self.calendar components:(NSCalendarUnitDay) fromDate:self.eventStartDate];
    NSInteger startDay = [startDateComponents day];
    NSDateComponents *endDateComponents = [self.calendar components:(NSCalendarUnitDay) fromDate:self.eventEndDate];
    NSInteger endDay = [endDateComponents day];
    NSInteger numDatesSelected = endDay - startDay + 1;
    NSDate *currentDate = [self.calendar dateBySettingHour:0 minute:0 second:0 ofDate:self.eventStartDate options:0];
    
    if (recognizerState == UIGestureRecognizerStateBegan) {
        if (self.currentCircle != nil) {
            [self.currentCircle removeFromSuperlayer];
        }
    }
    
    self.selectedDates = [self populateSelectedDates:currentDate numSelectedDates:(int)numDatesSelected];
    self.graphView.hidden = NO;
    
    // Howon: transforming bezier path
    float numHoursAvailable = numDatesSelected * 8.0;
    float maxHours = 8.0 * 14.0; // 8 * 14 (two weeks of workload is maximum)
    float maxY = 420.0;
    float minY = 320.0;
    float yRange = maxY - minY;
    float workload = [self calculateWorkload:location.y maxY:maxY yRange:yRange maxHours:maxHours];
    
    float transformingScale = workload / numHoursAvailable; // To get fillHeight, btnHeight * transformingScale
    
    UIButton *firstButton = (UIButton *)[self.smallCalendarView viewWithTag:[self.eventStartDate timeIntervalSince1970]];
    float btnWidth = firstButton.frame.size.width;
    float btnHeight = firstButton.frame.size.height;

    
    // Howon 12/10/14 I also want to show the user where he touched
    if (recognizerState == UIGestureRecognizerStateEnded) {
        [self drawCircle:location];
    }
    
    if (self.currentGraph != nil) {
        [self.currentGraph removeFromSuperlayer];
    }
    
    // This shapeLayer is actually hidden.
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    self.currentGraph = shapeLayer;
    shapeLayer.strokeColor = [self.utils colorFromHexString:@"#16A085"].CGColor;
    shapeLayer.fillColor = [self.utils colorFromHexString:@"#1ABC9C"].CGColor;
    shapeLayer.lineWidth = 1.0;
    
    // Uncomment the lines below to see what kind of shape is drawn when you touch the input area
    //    To hide the graph, just comment these out. Howon: visible graph
    [self.graphView.layer addSublayer:shapeLayer];
    [self.view.layer addSublayer:shapeLayer];
    
    // Define the input area
    float xStart = 188.0;
    float xEnd = 370.0;
    float yStart = maxY;
    float xRange = xEnd - xStart;
    
    // HOWON / 12/13/14: testing
    
    CGPoint bezierLocation = location;
    bezierLocation.y = minY;
    
    float tickInterval = xRange / numDatesSelected;
    
    CGPoint origin = CGPointMake(xStart, yStart);
    CGPoint endpt = CGPointMake(xEnd, yStart);
    CGPoint midpt1 = midPointForPoints(origin, bezierLocation);
    CGPoint midpt2 = midPointForPoints(bezierLocation, endpt);
    CGPoint ctrlpt1 = CGPointMake(midpt1.x, midpt1.y+50);
    CGPoint ctrlpt2 = CGPointMake(midpt2.x, midpt2.y+50);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:origin];
    [path addQuadCurveToPoint:location controlPoint:ctrlpt1]; //ctrlpt1
    [path addQuadCurveToPoint:endpt controlPoint:ctrlpt2]; //ctrlpt2
    [shapeLayer setPath:path.CGPath];
    
    NSMutableArray *fillHeightsArr = [[NSMutableArray alloc] init];
    float xPointOnBezierPath = xStart;
    float xTickLabel = (tickInterval/2.0);
    float epsilon = 10.0; // how much area in the middle you consider as "I want to evenly distribute my work"
    float xMid = (origin.x + endpt.x)/2.0;
    if (location.x >= xMid-epsilon && location.x <= xMid+epsilon) {
        // HOWON: if x falls in the middle, then return an evenly distributed workload
        fillHeightsArr = [self distributeWorkload:(int)numDatesSelected transformingScale:transformingScale btnHeight:btnHeight];
    } else {
        for (int i = 0; i < numDatesSelected; i++) {
            float prevXPoint = xPointOnBezierPath;
            xPointOnBezierPath = xPointOnBezierPath + tickInterval;
            xTickLabel += tickInterval;
            float y1Beizer = [self getYFromBezierPath:prevXPoint location:location ctrlpt1:ctrlpt1 ctrlpt2:ctrlpt2 startpt:origin endpt:endpt];
            float y2Beizer = [self getYFromBezierPath:xPointOnBezierPath location:location ctrlpt1:ctrlpt1 ctrlpt2:ctrlpt2 startpt:origin endpt:endpt];
            float avgY1Y2 = (y1Beizer + y2Beizer) / 2.0;
            float fillHeightFromY1Y2 = origin.y - avgY1Y2;
            NSNumber *fhNum = [NSNumber numberWithFloat:fillHeightFromY1Y2];
            [fillHeightsArr addObject:fhNum];
        }
        fillHeightsArr = [self normalize: fillHeightsArr btnHeight:btnHeight workload:workload numHoursADay:8];
    }

    int numColoredButtons = (int)[self.coloredButtons count];
    for (int i = 0; i < numColoredButtons; i++) {
        UIButton *cb = [self.coloredButtons objectAtIndex:i];
        [cb setImage:[self imageWithColor:[UIColor clearColor] buttonWidth:btnWidth buttonHeight:btnHeight fillHeight:btnHeight] forState:UIControlStateNormal];
    }
    [self.coloredButtons removeAllObjects];
    
    for (int i = 0; i < numDatesSelected; i++) {
        NSDate* selectedDate = [self.selectedDates objectAtIndex:i];
        int btnTag = [selectedDate timeIntervalSince1970];
        NSNumber *btnTagNumber = [NSNumber numberWithInt:btnTag];
        UIButton *myButton = (UIButton *)[self.smallCalendarView viewWithTag:btnTag];
        [self.coloredButtons addObject:myButton];
        
        float currentFillHeight = [[self.storedFillHeights objectForKey:btnTagNumber] floatValue];
//        NSLog(@"currentfillHeight: %f", currentFillHeight);
        float fillHeight = [fillHeightsArr[i] floatValue];
        
        UIImage *img = [self combinedImage:btnWidth buttonHeight:btnHeight fillHeight1:fillHeight fillHeight2:currentFillHeight];
        
        [myButton setImage:img forState:UIControlStateNormal];
        [myButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -53.5, 0.0, 0.0)];
        
        // 12/7/14: perform this step only at the end of pan or tap gesture
        if (recognizerState == UIGestureRecognizerStateEnded) {
            [myButton setTitle:myButton.titleLabel.text forState:UIControlStateNormal];
            int reminderDuration = (int)((fillHeight/btnHeight) * 60.0 * 8.0); // 8 hours in minutes * fraction
            //[self.reminderDurations addObject:[NSNumber numberWithInt:reminderDuration]];
            [self.eventDurations addObject:[NSNumber numberWithInt:reminderDuration]];
        }
    }

}

- (void)addReminders:(NSMutableArray *)selectedDates reminderDurations:(NSMutableArray *)reminderDurations {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd hh:mma"];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit                       | NSSecondCalendarUnit;
    int numDatesSelected = (int)[selectedDates count];
    for (int i = 0; i < numDatesSelected; i++) {
        int reminderDuration = (int)[[reminderDurations objectAtIndex:i] integerValue];
        NSDate *selectedDate = [selectedDates objectAtIndex:i];
        NSDateComponents *startDateComponents = [self.calendar components:unitFlags fromDate:selectedDate];
        NSDateComponents *componentsDiff = [[NSDateComponents alloc] init];
        componentsDiff.minute = reminderDuration; // why am I pulling out only minutes??
        NSDate *dueDate = [self.calendar dateByAddingComponents:componentsDiff toDate:selectedDate options:0];
        NSDateComponents *dueDateComponents = [self.calendar components:unitFlags fromDate:dueDate];
        
        NSString *reminderTitle = [NSString stringWithFormat:@"[re]start: %@, due: %@", [dateFormatter stringFromDate:selectedDate], [dateFormatter stringFromDate:dueDate]];
        [self addReminder:reminderTitle startDateComps:startDateComponents dueDateComps:dueDateComponents];
        NSLog(@"Added: %@", reminderTitle);
    }
}

- (void)addEvents:(NSString *)eventTitle selectedDates:(NSMutableArray *)selectedDates eventDurations:(NSMutableArray *)eventDurations {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd hh:mma"];
    int numDatesSelected = (int)[selectedDates count];
    for (int i = 0; i < numDatesSelected; i++) {
        int eventDuration = (int)[[eventDurations objectAtIndex:i] integerValue];
        NSDate *selectedDate = [selectedDates objectAtIndex:i];
        NSDateComponents *componentsDiff = [[NSDateComponents alloc] init];
        componentsDiff.minute = eventDuration;
        NSDate *dueDate = [self.calendar dateByAddingComponents:componentsDiff toDate:selectedDate options:0];
        [self addEvent:eventTitle startDate:selectedDate endDate:dueDate isReminder:YES];
        NSLog(@"Added a reminder event: %@", eventTitle);
    }
}

- (IBAction)displayGestureForTapRecognizer:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    [self drawWorkloadGraph:location recognizerState:recognizer.state];
}

- (IBAction)displayGestureForPanRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    [self drawWorkloadGraph:location recognizerState:recognizer.state];
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

// 12/13/14: Howon: fixed normalization process to get accurate workload distribution
- (NSMutableArray*)normalize:(NSMutableArray*)nums btnHeight:(float)btnHeight workload:(float)workload numHoursADay:(int)numHoursADay {
    // Process:
    // initial nums = Y-values from Bezier curve [30,20,20,10]. Divide each by the max value
    // then, [1,2/3,2/3,1/3]. Now divide each element by the sum of the array.
    // then, [0.375, 0.25, 0.25, 0.125]. Now multiply by the total workload. (let's say we have 10 hours of work)
    // then, [3.75, 2.5, 2.5, 1.25]. Now each cell represents number of hours that must be worked on that day.
    // For example, on the first day, the user has to work 10 hours. Now divide each by the total number of
    // available hours for each day. The default is 8 hours (we consider people only work for 8 hours a day)
    // then, [0.46875, 0.3125, 0.3125, 0.15625]. Then we have an array of the ratio of each cell's fillHeight to btnHeight.
    // Multiply each by the btnHeight to get the correct representation of workload for each cell's filled area. (btnHeight=37.5)
    // Then, [17.578125, 11.71875, 11.71875, 5.859375]. This is the final fillHeight array. If an element has
    // a value greater than btnHeight it means
    // the schedule is not feasible (there is more work to do than free time that day)
    // [self normalize: fillHeightsArr btnHeight:btnHeight workload:workload numHoursADay:8];
    
    int length = (int)[nums count];
    
    // First, divide everything by the max of the array
    float max = [[nums valueForKeyPath:@"@max.floatValue"] floatValue];
    for (int i=0; i<length; i++) {
        float num = [[nums objectAtIndex:i] floatValue];
        float normed_num1 = (num / max);
        NSNumber *tmp = [NSNumber numberWithFloat:normed_num1];
        [nums replaceObjectAtIndex:i withObject:tmp];
    }
    
    // Second, divide everything by the sum of the updated array, and compute more to get the appropriate fillHeight
    float sum_normed_nums = [[nums valueForKeyPath:@"@sum.self"] floatValue];
    for (int i=0; i<length; i++) {
        float num = [[nums objectAtIndex:i] floatValue];
        float normed_num2 = (((num / sum_normed_nums) * workload) / numHoursADay) * btnHeight;
        NSNumber *tmp2 = [NSNumber numberWithFloat:normed_num2];
        [nums replaceObjectAtIndex:i withObject:tmp2];
    }
    
    // Array of fillHeights
    return nums;
}

- (float)getTvalFromBezierPath:(float)x x0Val:(float)x0 x1Val:(float)x1 x2Val:(float)x2 {
//    NSLog(@"getTval: x: %f, x0: %f, x1: %f, x2: %f", x, x0, x1, x2);
    float tVal = (x-x0)/(2*(x1-x0));
    return tVal;
}

- (float)getCoordFromBezierPath:(float)t origin: (float)origin p1Val: (float)p1 p2Val: (float)p2 {
    return (pow((1-t),2) * origin) + (2 * t * (1-t) * p1) + (pow(t,2) * p2);
}

//SmallCalendarView related

- (UIImage *)imageWithColor:(UIColor *)color buttonWidth:(float)bw buttonHeight:(float)bh fillHeight:(float)fh {
    CGRect rect = CGRectMake(0, 0, bw, bh);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGRect innerRect = CGRectMake(0 , bh - fh, bw, fh);
    [color setFill];
    UIRectFill(innerRect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)combinedImage:(float)bw buttonHeight:(float)bh fillHeight1:(float)fh1 fillHeight2:(float)fh2 {
    // fh1 for graphBtnColor (goes bottom)
    // fh2 for currentFillHeight, greyBtnColor (goes up)
    UIColor *graphBtnColor = [self.utils colorFromHexString:@"#1ABC9C"];
    UIColor *greyBtnColor = [self.utils colorFromHexString:@"#6C7A89"];
    if ((fh1 + fh2) > bh) {
//        UIColor *pinkBtnColor = [self.utils colorFromHexString:@"#D2527F"];
        return [self imageWithColor:greyBtnColor buttonWidth:bw buttonHeight:bh fillHeight:bh];
    }
    CGRect rect = CGRectMake(0, 0, bw, bh);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGRect innerBottomRect = CGRectMake(0 , bh - fh1, bw, fh1);
    CGRect innerUpperRect = CGRectMake(0 , bh - fh2 - fh1, bw, fh2);
    [graphBtnColor setFill];
    UIRectFill(innerBottomRect);
    [greyBtnColor setFill];
    UIRectFill(innerUpperRect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setUpCalendarView:(TSQCalendarView *) calendarView {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendar = gregorian;
    calendarView.calendar = self.calendar;
    calendarView.rowCellClass = [AddEventRowCellController class];
    calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 1];
    calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 5];
    calendarView.backgroundColor = [UIColor colorWithRed:0.84f green:0.85f blue:0.86f alpha:1.0f];
    //calendarView.pagingEnabled = YES;
    calendarView.pagingEnabled = NO;
    calendarView.contentInset = UIEdgeInsetsMake(0.0f, 0, 0.0f, 0);
}

@end
