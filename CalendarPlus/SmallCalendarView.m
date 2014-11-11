//
//  SmallCalendarView.m
//  CalendarPlus
//
//  Created by Howon Song on 11/9/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "SmallCalendarView.h"
//#import "AppDelegate.h"

@implementation SmallCalendarView


//  Only override drawRect: if you perform custom drawing.
//  An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
     NSLog(@"drawRect");
 }

//- (void)setSelectedDate:(NSDate *)newSelectedDate; {
//    [super setSelectedDate:newSelectedDate];
//    self.initialVC.pickedDate = newSelectedDate; // store this variable for prepareForSegue method
//    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    appDelegate.eventManager.eventsList = [appDelegate.eventManager fetchEvents:newSelectedDate];
//    [self.initialVC.tableView reloadData];
//}

//- (void)setSelectedDate:(NSDate *)newSelectedDate;
//{
//    // clamp to beginning of its day
//    NSDate *startOfDay = [self clampDate:newSelectedDate toComponents:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit];
//    
//    if ([self.delegate respondsToSelector:@selector(calendarView:shouldSelectDate:)] && ![self.delegate calendarView:self shouldSelectDate:startOfDay]) {
//        return;
//    }
//    
//    [[self cellForRowAtDate:_selectedDate] selectColumnForDate:nil];
//    [[self cellForRowAtDate:startOfDay] selectColumnForDate:startOfDay];
//    NSIndexPath *newIndexPath = [self indexPathForRowAtDate:startOfDay];
//    CGRect newIndexPathRect = [self.tableView rectForRowAtIndexPath:newIndexPath];
//    CGRect scrollBounds = self.tableView.bounds;
//    
//    if (self.pagingEnabled) {
//        CGRect sectionRect = [self.tableView rectForSection:newIndexPath.section];
//        [self.tableView setContentOffset:sectionRect.origin animated:YES];
//    } else {
//        if (CGRectGetMinY(scrollBounds) > CGRectGetMinY(newIndexPathRect)) {
//            [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        } else if (CGRectGetMaxY(scrollBounds) < CGRectGetMaxY(newIndexPathRect)) {
//            [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        }
//    }
//    
//    _selectedDate = startOfDay;
//    
//    //    Howon adding part
//    NSString *dateString = [NSDateFormatter localizedStringFromDate:startOfDay
//                                                          dateStyle:NSDateFormatterShortStyle
//                                                          timeStyle:NSDateFormatterFullStyle];
//    
//    NSLog(@"selected: %@", dateString);
//    
//    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
//        [self.delegate calendarView:self didSelectDate:startOfDay];
//    }
//    
//    //    //Howon adding part
//}

@end
