//
//  PlusCalendarView.h
//  CalendarPlus
//
//  Created by Howon Song on 10/26/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//
//

//#import "TSQCalendarView.h"
#import <TimesSquare/TSQCalendarView.h>
#import "ViewController.h"

@interface PlusCalendarView : TSQCalendarView

@property (nonatomic, weak) ViewController *initialVC;

@end
