//
//  AddEventViewController.m
//  CalendarPlus
//
//  Created by Howon Song on 10/27/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "AddEventViewController.h"

@interface AddEventViewController ()

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventTitle.delegate = self;
    self.STARTDATELABEL = @"startDateSelected";
    self.STARTDATELABEL = @"endDateSelected";
    
    
    UIImage *buttonImage = [[UIImage imageNamed:@"btn_carrot.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"btn_light_carrot.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.startDateButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.startDateButton setBackgroundImage:buttonImageHighlight forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [self.endDateButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.endDateButton setBackgroundImage:buttonImageHighlight forState:(UIControlStateHighlighted | UIControlStateSelected)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startDateButtonTapped:(id)sender {
    [self textFieldShouldReturn:self.eventTitle];
//    [UIView animateWithDuration:1 animations:nil completion:^(BOOL finished) {
//        self.startDateButton.highlighted = YES;
//        self.startDateButton.selected = YES;
//    }];
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

- (IBAction)dateSelected:(id)sender {
    NSDate *dateSelected = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd hh:mma"];
    if (self.currentDateLabel == self.STARTDATELABEL) {
        self.startDateLabel.text = [dateFormatter stringFromDate:dateSelected];
    } else if (self.currentDateLabel == self.ENDDATELABEL) {
        self.endDateLabel.text = [dateFormatter stringFromDate:dateSelected];
    } else {
        NSLog(@"else block");
    }
    
//    if ([self.startDateButton isFirstResponder]) {
//        self.startDateLabel.text = [dateFormatter stringFromDate:dateSelected];
//    } else if ([self.endDateLabel isFirstResponder]) {
//        self.endDateLabel.text = [dateFormatter stringFromDate:dateSelected];
//    } else {
//        NSLog(@"else block");
//    }
    NSLog(@"dateSelected called");
    
}

//-(IBAction)dateValueChanged:(id)sender
//{
//    NSDate *dateSelected = [picker date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//    
//    if ([firstTextField isFirstResponder])
//    {
//        firstTextField.text = [dateFormatter stringFromDate:dateSelected];
//    }
//    else if ([self.endTextField isFirstResponder])
//    {
//        secondTextField.text = [dateFormatter stringFromDate:dateSelected];
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)startDateButtonTouchUp:(id)sender {
    [self.startDateButton setSelected:YES];
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
