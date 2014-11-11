//
//  SmallCalendarView.h
//  CalendarPlus
//
//  Created by Howon Song on 11/9/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import <TimesSquare/TSQCalendarView.h>
#import "ViewController.h"

@interface SmallCalendarView : TSQCalendarView

//@property (nonatomic, weak) ViewController *initialVC;

- (void)setSelectedDate:(NSDate *)newSelectedDate;

@end
