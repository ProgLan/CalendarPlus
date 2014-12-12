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
    self.maxBtnHeight = 39.0; //FIXME: hardcoded values: can be found in AddCalendarEventRowController
    self.maxBtnWidth = 53.5;
    
    // Set button backgrounds
//    UIImage *buttonImage = [[UIImage imageNamed:@"btn_carrot.png"]
//                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
//    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"btn_light_carrot.png"]
//                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
//    [self.startDateButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [self.startDateButton setBackgroundImage:buttonImageHighlight forState:(UIControlStateHighlighted | UIControlStateSelected)];
//    [self.endDateButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [self.endDateButton setBackgroundImage:buttonImageHighlight forState:(UIControlStateHighlighted | UIControlStateSelected)];
    // Set button backgrounds Done
    
    [self setDateLables:self.firstDate endDate:self.eventEndDate];
    self.eventStore = [[EKEventStore alloc] init];
    
    // HOWON 12/10/14 see if sharing this with todayWidget works
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.CalendarPlus"];
    [sharedDefaults setObject:@"hello there" forKey:@"helloString"];
    
    self.reminderDurations = [[NSMutableArray alloc] initWithCapacity:0];
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
            float fillHeight = (numOccupiedHours / self.availableHours) * self.maxBtnHeight;
            UIImage *btnImg;
            
            if (fillHeight >= self.maxBtnHeight) {
                fillHeight = self.maxBtnHeight;
            }
            btnImg = [self imageWithColor:greyBtnColor buttonWidth:self.maxBtnWidth buttonHeight:self.maxBtnHeight fillHeight:fillHeight];
            
//            if (fillHeight >= self.maxBtnHeight) {
//                fillHeight = self.maxBtnHeight;
//                btnImg = [self imageWithColor:pinkBtnColor buttonWidth:self.maxBtnWidth buttonHeight:self.maxBtnHeight fillHeight:fillHeight];
//            } else {
//                btnImg = [self imageWithColor:greyBtnColor buttonWidth:self.maxBtnWidth buttonHeight:self.maxBtnHeight fillHeight:fillHeight];
//            }
            
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
    NSLog(@"stored FillHEights: %@", self.storedFillHeights);
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
    
    // Howon 12/5/14 I have to add reminders here.
    [self addReminders:self.selectedDates reminderDurations:self.reminderDurations];
    
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

- (NSMutableArray*)distributeWorkload:(NSMutableArray *)fillHeightsArr numDatesSelected:(int)arrSize loc:(CGPoint)location transformingScale:(float)tfScale btnHeight:(float)btnHeight {
//    float fillHeight = btnHeight * tfScale;
    // not sure what the fillHeight should be here
    float fillHeight = tfScale * 10;
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
    circle.position = CGPointMake(location.x+radius, location.y-radius);
    circle.fillColor = [self.utils colorFromHexString:@"#1abc9c"].CGColor;
    circle.strokeColor = [self.utils colorFromHexString:@"#16a085"].CGColor;
    circle.lineWidth = 2;
    
    self.currentCircle = circle;
    [self.view.layer addSublayer:circle];
}


- (void)drawWorkloadGraph:(CGPoint)location recognizerState:(UIGestureRecognizerState)recognizerState {
    NSDateComponents *startDateComponents = [self.calendar components:(NSCalendarUnitDay) fromDate:self.eventStartDate];
    NSInteger startDay = [startDateComponents day];
    NSDateComponents *endDateComponents = [self.calendar components:(NSCalendarUnitDay) fromDate:self.eventEndDate];
    NSInteger endDay = [endDateComponents day];
    NSInteger numDatesSelected = endDay - startDay + 1;
    NSDate *currentDate = [self.calendar dateBySettingHour:0 minute:0 second:0 ofDate:self.eventStartDate options:0];
    
    float circleX = location.x;
    float circleY = location.y;
    
    if (recognizerState == UIGestureRecognizerStateBegan) {
        if (self.currentCircle != nil) {
            [self.currentCircle removeFromSuperlayer];
        }
    }
    
    self.selectedDates = [self populateSelectedDates:currentDate numSelectedDates:(int)numDatesSelected];
    self.graphView.hidden = NO;
    
    // Howon: transforming bezier path
    int numHoursAvailable = (int)numDatesSelected * 8;
    // workButton1: 430 ~ 405 - least amount of work (the less fixLocationY is, the bigger the graph is)
    // workButton2: 405 ~ 380
    // workButton3: 380 ~ 355
    // workButton4: 355 ~ 330
    int workload = 0;
    if (location.y < 355 && location.y >= 330) {
        workload = 14 * 8;
        //NSLog(@"Two weeks. Available: %i, Workload: %i", numHoursAvailable, workload);
    } else if (location.y < 380 && location.y >= 355) {
        workload = 7 * 8;
        //NSLog(@"One week. Available: %i, Workload: %i", numHoursAvailable, workload);
    } else if (location.y < 405 && location.y >= 380) {
        workload = 8;
        //NSLog(@"One day. Available: %i, Workload: %i", numHoursAvailable, workload);
    } else if (location.y < 430 && location.y >= 405) {
        workload = 1;
        //NSLog(@"One hour. Available: %i, Workload: %i", numHoursAvailable, workload);
    }
    float transformingScale = workload / (float)numHoursAvailable;
    
    UIButton *firstButton = (UIButton *)[self.smallCalendarView viewWithTag:[self.eventStartDate timeIntervalSince1970]];
    float btnWidth = firstButton.frame.size.width;
    float btnHeight = firstButton.frame.size.height;

    if (transformingScale > 1) {
//        NSLog(@"we cannot draw the graph");
        int numColoredButtons = [self.coloredButtons count];
        for (int i = 0; i < numColoredButtons; i++) {
            UIButton *cb = [self.coloredButtons objectAtIndex:i];
            [cb setImage:[self imageWithColor:[UIColor clearColor] buttonWidth:btnWidth buttonHeight:btnHeight fillHeight:btnHeight] forState:UIControlStateNormal];
        }
        [self.coloredButtons removeAllObjects];
        
        for (int i = 0; i < numDatesSelected; i++) {
            int btnTag = [[self.selectedDates objectAtIndex:i] timeIntervalSince1970];
            NSNumber *btnTagNumber = [NSNumber numberWithInt:btnTag];
            UIButton *myButton = (UIButton *)[self.smallCalendarView viewWithTag:btnTag];
            [self.coloredButtons addObject:myButton];
            UIImage *img = [self imageWithColor:[UIColor redColor] buttonWidth:btnWidth buttonHeight:btnHeight fillHeight:btnHeight];
            [myButton setImage:img forState:UIControlStateNormal];
            [myButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -53.5, 0.0, 0.0)];
            [myButton setTitle:myButton.titleLabel.text forState:UIControlStateNormal];
        }
        return;
    }
    
    // Howon 12/10/14 I also want to show the user where he touched
    if (recognizerState == UIGestureRecognizerStateEnded) {
        [self drawCircle:location];
    }
    
    // HOWON: set a fixed location for the bezier graph 11/24/14
    // WATCH OUT IF YOU ARE PLANNING TO USE LOCATION VARIABLE AFTER THIS
    location.y = 330.0;
    
    NSLog(@"Touch location: %@", NSStringFromCGPoint(location));
    
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
    //    [self.graphView.layer addSublayer:shapeLayer];
    //    [self.view.layer addSublayer:shapeLayer];
    
    // 12/10/14: can I add a user feedback shape here??
    
    float xStart = 188.0;
    float xEnd = 370.0;
    float yStart = 425.0;
    float xRange = xEnd - xStart;
    
    float tickInterval = xRange / numDatesSelected;
    
    CGPoint origin = CGPointMake(xStart, yStart);
    CGPoint endpt = CGPointMake(xEnd, yStart);
    CGPoint midpt1 = midPointForPoints(origin, location);
    CGPoint midpt2 = midPointForPoints(location, endpt);
    CGPoint ctrlpt1 = CGPointMake(midpt1.x, midpt1.y+50);
    CGPoint ctrlpt2 = CGPointMake(midpt2.x, midpt2.y+50);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:origin];
    [path addQuadCurveToPoint:location controlPoint:ctrlpt1]; //ctrlpt1
    [path addQuadCurveToPoint:endpt controlPoint:ctrlpt2]; //ctrlpt2
    [shapeLayer setPath:path.CGPath];
    
    //Represent the workload on the calendar
    //Get a range of NSDate objects
    //    NSMutableArray *selectedDates = [[NSMutableArray alloc] init];
    NSMutableArray *fillHeightsArr = [[NSMutableArray alloc] init];
    float xPointOnBezierPath = xStart;
    float xTickLabel = (tickInterval/2.0);
    
    if (self.tickDateLabelContainer != nil) {
        [self.tickDateLabelContainer removeFromSuperview];
    }
    
    self.tickDateLabelContainer = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 30)];
    self.tickDateLabelContainer.backgroundColor = [UIColor clearColor];
    [self.graphView addSubview:self.tickDateLabelContainer];
    
// working here
    float epsilon = 10.0;
    float xMid = (origin.x + endpt.x)/2.0;
    if (location.x >= xMid-epsilon && location.x <= xMid+epsilon) {
        // HOWON: if x falls in the middle, then return an evenly distributed workload
        fillHeightsArr = [self distributeWorkload:fillHeightsArr numDatesSelected:(int)numDatesSelected loc:location transformingScale:transformingScale btnHeight:btnHeight];
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
        fillHeightsArr = [self normalizeAndScale: fillHeightsArr btnHeight:btnHeight scaleFactor:transformingScale];
    }
    
    //    NSLog(@"after normalizing: %@", fillHeightsArr);
    // Clear all previously colored buttons
    
    int numColoredButtons = [self.coloredButtons count];
    for (int i = 0; i < numColoredButtons; i++) {
        UIButton *cb = [self.coloredButtons objectAtIndex:i];
        [cb setImage:[self imageWithColor:[UIColor clearColor] buttonWidth:btnWidth buttonHeight:btnHeight fillHeight:btnHeight] forState:UIControlStateNormal];
    }
    [self.coloredButtons removeAllObjects];
    UIColor *prettyBtnColor = [self.utils colorFromHexString:@"#1ABC9C"];
    
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
            int reminderDuration = (int)((fillHeight/btnHeight) * 60 * 8); // 8 hours in minutes * fraction
            [self.reminderDurations addObject:[NSNumber numberWithInt:reminderDuration]];
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
//        [NSNumber numberWithInteger:i]
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

- (IBAction)displayGestureForTapRecognizer:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    [self drawWorkloadGraph:location recognizerState:recognizer.state];
}

- (IBAction)displayGestureForPanRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    [self drawWorkloadGraph:location recognizerState:recognizer.state];
    
    
//    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        [self drawWorkloadGraph:location isEndMotion:false isStartMotion:true];
//    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"gesture ending state");
//        [self drawWorkloadGraph:location isEndMotion:true isStartMotion:false];
//    } else {
//        [self drawWorkloadGraph:location isEndMotion:false isStartMotion:true];
//    }
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

- (NSMutableArray*)normalizeAndScale:(NSMutableArray*)nums btnHeight:(float)btnHeight scaleFactor:(float)scaleFactor {
    int length = [nums count];
    float realmax = [[nums valueForKeyPath:@"@max.floatValue"] floatValue];
//    float max = 30.0; // the smaller this value is, the more each cell is filled by Bezier path
    float max = realmax;
    for (int i=0; i<length; i++) {
        float num = [[nums objectAtIndex:i] floatValue];
        float normed_num = num / max;
        float scaled = normed_num * btnHeight * scaleFactor;
        if (scaled < 0) {
            scaled = 0.0;
        }
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
