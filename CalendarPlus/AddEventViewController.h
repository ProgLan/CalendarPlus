//
//  AddEventViewController.h
//  CalendarPlus
//
//  Created by Howon Song on 10/27/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <TimesSquare/TimesSquare.h>
#import "SmallCalendarView.h"
#import "Utils.h"
//@class SmallCalendarView;

@interface AddEventViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
- (IBAction)startDateButtonTapped:(id)sender;
- (IBAction)endDateButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *eventTitle;
- (IBAction)dateSelected:(id)sender;
@property (strong, nonatomic) NSString *currentDateLabel;
@property NSString *const STARTDATELABEL;
@property NSString *const ENDDATELABEL;

//FIXME: not sure if its okay to set global variables like this
@property (strong, nonatomic) NSDate *eventStartDate;
@property (strong, nonatomic) NSDate *eventEndDate;

// EKEventStore instance associated with the current Calendar application
@property (strong, nonatomic) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (strong, nonatomic) EKCalendar *defaultCalendar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEventButton;


- (IBAction)addEventBtnPressed:(id)sender;

@property (strong, nonatomic) NSDate* firstDate;

- (void)setInitDate:(NSDate*)pickedDate;
- (void)setDateLables:(NSDate*)dateInit;

// Drawing a line graph
@property (weak, nonatomic) IBOutlet UIView *graphView;
@property (strong, nonatomic) CAShapeLayer *currentGraph;

@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapRecognizer;
- (IBAction)displayGestureForTapRecognizer:(UITapGestureRecognizer *)recognizer;

// PanGesture Recognizer
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;
- (IBAction)displayGestureForPanRecognizer:(UIPanGestureRecognizer *)recognizer;




// SmallCalendarView

@property (nonatomic, strong) NSCalendar *calendar;
@property (strong, nonatomic) IBOutlet SmallCalendarView *smallCalendarView;

@property (strong, nonatomic) NSMutableArray* coloredButtons;
@property (nonatomic,strong) Utils *utils;

//@property (strong, nonatomic) NSMutableArray *tickDateLabels;
@property (strong, nonatomic) UIView *tickDateLabelContainer;

//workload buttons
@property (weak, nonatomic) IBOutlet UILabel *workButton4;
@property (weak, nonatomic) IBOutlet UILabel *workButton3;
@property (weak, nonatomic) IBOutlet UILabel *workButton2;
@property (weak, nonatomic) IBOutlet UILabel *workButton1;

- (NSMutableArray*)populateSelectedDates:(NSDate *)currentDate numSelectedDates:(int)numDatesSelected;
- (void)addReminder:(NSString*)title startDateComps:(NSDateComponents*)startDateComps dueDateComps:(NSDateComponents*)dueDateComps;

// temporary variables that hold reminder component information
@property (strong, nonatomic) NSMutableArray *selectedDates;
@property (strong, nonatomic) NSMutableArray *reminderDurations;
@property AppDelegate *appDelegate;

// 12/4/14 added
@property float maxBtnHeight;
@property float maxBtnWidth;
@property float availableHours;

// 12/8/14 added
@property (strong, nonatomic) NSMutableDictionary *storedFillHeights;
//@property (strong, nonatomic) NSMutableArray *storedFillHeights;



@end
