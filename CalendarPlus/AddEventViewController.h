//
//  AddEventViewController.h
//  CalendarPlus
//
//  Created by Howon Song on 10/27/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

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
@property NSDate *eventStartDate;
@property NSDate *eventEndDate;

// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEventButton;


- (IBAction)addEventBtnPressed:(id)sender;

@property (strong, nonatomic) NSDate* firstDate;

- (void)setInitDate:(NSDate*)pickedDate;
- (void)setDateLables:(NSDate*)dateInit;

@end
