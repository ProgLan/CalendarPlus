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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect frame = CGRectInset(self.bounds, 0, 0);
    return CGRectContainsPoint(frame, point) ? self : nil;
}

//+ (CGFloat)cellHeight;
//{
//    return 46.0f;
//}

@end
