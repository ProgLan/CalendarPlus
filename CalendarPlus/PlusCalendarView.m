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
    NSLog(@"override worked");
    [super setSelectedDate:newSelectedDate];
}

@end
