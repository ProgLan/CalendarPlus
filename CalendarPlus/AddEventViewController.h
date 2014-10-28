//
//  AddEventViewController.h
//  CalendarPlus
//
//  Created by Howon Song on 10/27/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import <UIKit/UIKit.h>

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


@end
