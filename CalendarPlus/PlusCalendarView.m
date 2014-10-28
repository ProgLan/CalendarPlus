//
//  PlusCalendarView.m
//  CalendarPlus
//
//  Created by Howon Song on 10/26/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "PlusCalendarView.h"

@implementation PlusCalendarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSelectedDate:(NSDate *)newSelectedDate; {
    [super setSelectedDate:newSelectedDate];
    self.initialVC.pickedDate = newSelectedDate; // store this variable for prepareForSegue method
    [self.initialVC performSegueWithIdentifier:@"GoToSecondViewController" sender:self.initialVC];
}

@end
