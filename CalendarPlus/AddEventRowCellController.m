//
//  AddEventRowCellController.m
//  CalendarPlus
//
//  Created by Howon Song on 11/14/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "AddEventRowCellController.h"
#import "Utils.h"

@implementation AddEventRowCellController

- (void)layoutViewsForColumnAtIndex:(NSUInteger)index inRect:(CGRect)rect;
{
    // Move down for the row at the top
    rect.origin.y += self.columnSpacing;
    rect.size.height -= (self.bottomRow ? 2.0f : 1.0f) * self.columnSpacing;
    [super layoutViewsForColumnAtIndex:index inRect:rect];
}

- (UIImage *)todayBackgroundImage;
{
    // I dont want todayBackground to show
    // return [[UIImage imageNamed:@"todays_date_custom.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    
    Utils* utils = [[Utils alloc] init];
    UIImage* img = [utils imageWithColor:[UIColor clearColor] buttonWidth:1.0 buttonHeight:1.0 fillHeight:1.0];
    return [img stretchableImageWithLeftCapWidth:4 topCapHeight:4];
}

- (UIImage *)selectedBackgroundImage;
{
    return [[UIImage imageNamed:@"selected_date_custom.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
}

- (UIImage *)notThisMonthBackgroundImage;
{
    return [[UIImage imageNamed:@"CalendarPreviousMonth.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
}

- (UIImage *)backgroundImage;
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"CalendarRow%@.png", self.bottomRow ? @"Bottom" : @""]];
    
}

+ (CGFloat)cellHeight;
{
    return 35.0f;
}

@end
