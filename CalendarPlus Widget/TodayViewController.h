//
//  TodayViewController.h
//  CalendarPlus Widget
//
//  Created by Howon Song on 12/12/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TodayViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *todayEvents;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
- (IBAction)displayGestureForTapRecognizer:(UITapGestureRecognizer *)recognizer;
- (IBAction)displayGestureForLongPressRecognizer:(UILongPressGestureRecognizer *)recognizer;
@property (strong, nonatomic) EKEventStore *eventStore;
@end
