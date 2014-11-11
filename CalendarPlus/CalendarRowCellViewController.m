//
//  CalendarRowCellViewController.m
//  CalendarPlus
//
//  Created by Howon Song on 10/19/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "CalendarRowCellViewController.h"

@implementation CalendarRowCellViewController

- (void)layoutViewsForColumnAtIndex:(NSUInteger)index inRect:(CGRect)rect;
{
    // Move down for the row at the top
    rect.origin.y += self.columnSpacing;
    rect.size.height -= (self.bottomRow ? 2.0f : 1.0f) * self.columnSpacing;
    [super layoutViewsForColumnAtIndex:index inRect:rect];
}

- (UIImage *)todayBackgroundImage;
{
    return [[UIImage imageNamed:@"todays_date_custom.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
}

- (UIImage *)selectedBackgroundImage;
{
    return [[UIImage imageNamed:@"selected_date_custom.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
}

- (UIImage *)selectedBackgroundImageTest;
{
    return [[UIImage imageNamed:@"CalendarSelectedDate.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
}

- (UIImage *)notThisMonthBackgroundImage;
{
    return [[UIImage imageNamed:@"CalendarPreviousMonth.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
}

- (UIImage *)backgroundImage;
{
    NSLog(@"background img called");
    return [UIImage imageNamed:[NSString stringWithFormat:@"CalendarRow%@.png", self.bottomRow ? @"Bottom" : @""]];
    
}


@end
